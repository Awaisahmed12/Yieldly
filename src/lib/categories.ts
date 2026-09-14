import type { CardUnlockRow, CategoryRow, RewardRateRow, SubpromptOption } from '../types/reward'

export const GUEST_CATEGORY_SLUGS = [
  'dining', 'groceries', 'gas', 'travel', 'streaming', 'online_shopping',
]

// Everyday categories a user always needs an answer for, even when every card
// earns the base rate (the result page then shows a tie at 1x).
const ALWAYS_SHOWN = ['groceries', 'dining', 'gas', 'car_rental']

const BASE_CATEGORY_SLUGS = [
  'groceries', 'online_groceries', 'dining', 'gas', 'travel', 'flights', 'hotels',
  'streaming', 'pharmacy', 'entertainment', 'transit',
  'online_shopping', 'rent', 'wholesale_clubs', 'car_rental', 'beauty',
  'utilities', 'fitness', 'ev_charging', 'foreign_spending', 'other',
]

/**
 * Get all category slugs the user should see.
 * Base categories always shown + brand categories unlocked by user's cards.
 */
export function getUnlockedCategorySlugs(
  userCardIds: string[],
  allUnlocks: CardUnlockRow[]
): string[] {
  const brandUnlocks = allUnlocks
    .filter(u => userCardIds.includes(u.card_id))
    .map(u => u.category_slug)

  return [...new Set([...BASE_CATEGORY_SLUGS, ...brandUnlocks])]
}

/**
 * Filter out categories where none of the user's cards earn more than base rate.
 * Only show a category if at least one user card has a rate > 1x on it.
 */
export function filterRelevantCategories(
  slugs: string[],
  userCardIds: string[],
  allRates: RewardRateRow[]
): string[] {
  const hasFlatBonus = allRates.some(r =>
    userCardIds.includes(r.card_id) && r.category_slug === 'other' && r.rate > 1.0
  )
  return slugs.filter(slug => {
    // other/foreign_spending always shown if user has cards
    if (slug === 'other') return userCardIds.length > 0
    if (slug === 'foreign_spending') return userCardIds.length > 0
    if (ALWAYS_SHOWN.includes(slug)) return userCardIds.length > 0

    // A card with an elevated base rate (e.g. Freedom Unlimited 1.5%, Double Cash 2%)
    // beats 1x in every category, so every category is worth showing.
    if (hasFlatBonus) return true

    return allRates.some(r =>
      userCardIds.includes(r.card_id) &&
      r.category_slug === slug &&
      r.rate > 1.0
    )
  })
}

/**
 * Check if tapping a category needs a sub-prompt (e.g., "Which airline?").
 * Returns options if >= 2 brand children of this category are unlocked.
 */
export function getSubpromptOptions(
  categorySlug: string,
  userCardIds: string[],
  allUnlocks: CardUnlockRow[],
  allCategories: CategoryRow[]
): SubpromptOption[] | null {
  const children = allCategories.filter(c => c.parent_slug === categorySlug)
  if (children.length === 0) return null

  const unlockedChildren = children.filter(child =>
    allUnlocks.some(u => userCardIds.includes(u.card_id) && u.category_slug === child.slug)
  )

  if (unlockedChildren.length >= 2) {
    return unlockedChildren.map(c => ({ slug: c.slug, label: c.display_name }))
  }

  return null
}

export type CategoryUsage = Record<string, { count: number; last: number }>

// Tuning for the usage-based promotion. Kept deliberately conservative: the
// grid should feel familiar, with only a user's clear favourites moving up.
export const USAGE_HALF_LIFE_DAYS = 30   // a tap counts half as much after 30 days
export const USAGE_MIN_TAPS = 3          // decayed taps needed before a tile can move
export const USAGE_MIN_SHARE = 0.15      // …and at least 15% of all decayed taps
export const USAGE_MAX_PROMOTED = 3      // at most one grid row is promoted

/**
 * Decayed tap score: count × 0.5^(days since last tap / half-life).
 */
export function usageScore(entry: { count: number; last: number } | undefined, now: number): number {
  if (!entry || entry.count <= 0) return 0
  const days = Math.max(0, (now - entry.last) / 86_400_000)
  return entry.count * Math.pow(0.5, days / USAGE_HALF_LIFE_DAYS)
}

/**
 * Order categories for the home grid. Starts from the incoming (best-rate) order
 * and promotes at most USAGE_MAX_PROMOTED clear favourites to the front; every
 * other tile keeps its position and 'other' stays last.
 */
export function orderByUsage<T extends { slug: string }>(
  categories: T[],
  usage: CategoryUsage,
  now: number = Date.now()
): T[] {
  const scored = categories.map(c => ({ c, score: c.slug === 'other' ? 0 : usageScore(usage[c.slug], now) }))
  const total = scored.reduce((sum, x) => sum + x.score, 0)
  if (total === 0) return categories

  const promoted = scored
    .filter(x => x.score >= USAGE_MIN_TAPS && x.score / total >= USAGE_MIN_SHARE)
    .sort((a, b) => b.score - a.score)
    .slice(0, USAGE_MAX_PROMOTED)
    .map(x => x.c)
  if (promoted.length === 0) return categories

  const rest = categories.filter(c => !promoted.includes(c))
  return [...promoted, ...rest]
}
