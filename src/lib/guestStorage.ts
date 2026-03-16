const GUEST_CARDS_KEY = 'yield_guest_card_slugs'

export const DEFAULT_CARD_SLUGS = [
  'chase_sapphire_preferred',
  'apple_card',
  'amex_gold',
  'citi_double_cash',
  'capital_one_venture',
  'discover_it_cash',
]

export function getGuestCardSlugs(): string[] {
  try {
    const raw = localStorage.getItem(GUEST_CARDS_KEY)
    if (!raw) return []
    return JSON.parse(raw) as string[]
  } catch {
    return []
  }
}

export function setGuestCardSlugs(slugs: string[]): void {
  localStorage.setItem(GUEST_CARDS_KEY, JSON.stringify(slugs))
}

export function clearGuestCardSlugs(): void {
  localStorage.removeItem(GUEST_CARDS_KEY)
}
