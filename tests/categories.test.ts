import { describe, expect, it } from 'vitest'
import { filterRelevantCategories, orderByUsage, type CategoryUsage } from '../src/lib/categories'
import type { RewardRateRow } from '../src/types/reward'

const rate = (card_id: string, category_slug: string, rate: number): RewardRateRow => ({
  id: `${card_id}:${category_slug}`, card_id, category_slug, rate, rate_type: 'multiplier',
  cap_amount: null, cap_period: null, notes: null, effective_from: null, effective_until: null, created_at: '',
})

describe('filterRelevantCategories', () => {
  const slugs = ['groceries', 'online_groceries', 'dining', 'gas', 'beauty', 'streaming', 'other', 'foreign_spending']

  it('always shows everyday categories when the user has cards, even at 1x', () => {
    // Sapphire Preferred after the fix: 3x online groceries, 3x streaming, nothing in store.
    const rates = [rate('csp', 'online_groceries', 3), rate('csp', 'streaming', 3)]
    const shown = filterRelevantCategories(slugs, ['csp'], rates)
    expect(shown).toContain('groceries')
    expect(shown).toContain('dining')
    expect(shown).toContain('gas')
    expect(shown).toContain('online_groceries')
    expect(shown).toContain('other')
    expect(shown).not.toContain('beauty')
  })

  it('shows nothing without cards', () => {
    expect(filterRelevantCategories(slugs, [], [])).toEqual([])
  })
})

describe('orderByUsage', () => {
  const NOW = Date.UTC(2026, 8, 14)
  const DAY = 86_400_000
  const grid = ['travel', 'dining', 'gas', 'streaming', 'flights', 'hotels', 'transit', 'other'].map(slug => ({ slug }))
  const slugs = (list: { slug: string }[]) => list.map(c => c.slug)
  const tap = (count: number, daysAgo = 0) => ({ count, last: NOW - daysAgo * DAY })

  it('keeps the incoming order when nothing has been tapped', () => {
    expect(slugs(orderByUsage(grid, {}, NOW))).toEqual(slugs(grid))
  })

  it('does not move a tile below the tap threshold', () => {
    const usage: CategoryUsage = { transit: tap(2), dining: tap(1) }
    expect(slugs(orderByUsage(grid, usage, NOW))).toEqual(slugs(grid))
  })

  it('promotes a clear favourite to the first slot and leaves everything else alone', () => {
    const usage: CategoryUsage = { transit: tap(5) }
    expect(slugs(orderByUsage(grid, usage, NOW))).toEqual(['transit', 'travel', 'dining', 'gas', 'streaming', 'flights', 'hotels', 'other'])
  })

  it('never promotes more than one row', () => {
    const usage: CategoryUsage = { transit: tap(9), hotels: tap(8), flights: tap(7), streaming: tap(6), gas: tap(5) }
    const ordered = slugs(orderByUsage(grid, usage, NOW))
    expect(ordered.slice(0, 3)).toEqual(['transit', 'hotels', 'flights'])
    // the rest keep their original relative order
    expect(ordered.slice(3)).toEqual(['travel', 'dining', 'gas', 'streaming', 'other'])
  })

  it('lets recent habits outweigh old ones', () => {
    const usage: CategoryUsage = { hotels: tap(10, 180), transit: tap(4, 2) }
    const ordered = slugs(orderByUsage(grid, usage, NOW))
    expect(ordered[0]).toBe('transit')
    expect(ordered).not.toContain(undefined)
    // 10 taps six months ago decay to ~0.16, below the threshold, so hotels is not promoted
    expect(ordered.slice(1)).toEqual(['travel', 'dining', 'gas', 'streaming', 'flights', 'hotels', 'other'])
  })

  it('ignores a small share of taps and keeps other last', () => {
    const usage: CategoryUsage = { transit: tap(30), dining: tap(3), other: tap(50) }
    const ordered = slugs(orderByUsage(grid, usage, NOW))
    expect(ordered[0]).toBe('transit')
    expect(ordered.indexOf('dining')).toBe(2) // unchanged: 3 of 33 taps is under the 15% share
    expect(ordered[ordered.length - 1]).toBe('other')
  })
})
