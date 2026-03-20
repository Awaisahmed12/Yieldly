import type { CardUnlockRow, CategoryRow, RewardRateRow, SubpromptOption } from '../types/reward'

export const GUEST_CATEGORY_SLUGS = [
  'dining', 'groceries', 'gas', 'travel', 'streaming', 'online_shopping',
]

const BASE_CATEGORY_SLUGS = [
  'groceries', 'dining', 'gas', 'travel', 'flights', 'hotels',
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
  return slugs.filter(slug => {
    // other/foreign_spending always shown if user has cards
    if (slug === 'other') return userCardIds.length > 0
    if (slug === 'foreign_spending') return userCardIds.length > 0
    // car_rental is always shown (has reward_rates and most users benefit from knowing)
    if (slug === 'car_rental') return allRates.some(r => userCardIds.includes(r.card_id) && r.category_slug === slug)

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
