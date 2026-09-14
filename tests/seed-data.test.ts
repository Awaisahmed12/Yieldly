/**
 * Regression suite for the hand-written reward data.
 * Every fact here was verified against issuer terms; when a card changes,
 * update the seed AND the assertion together.
 */
import { describe, expect, it } from 'vitest'
import { loadSeed, rateOf } from './seed-parser'

// The seed files plus every migration that adds/changes static data after them.
const data = loadSeed(undefined, [
  'supabase/migrations/0003_foreign_transaction_fee.sql',
  'supabase/migrations/0004_add_missing_cards.sql',
  'supabase/migrations/0006_new_categories.sql',
  'supabase/migrations/0007_new_category_rates.sql',
  'supabase/migrations/0008_canadian_cards.sql',
  'supabase/migrations/0009_online_groceries.sql',
])

describe('seed integrity', () => {
  it('parses the full catalogue', () => {
    expect(Object.keys(data.cards).length).toBeGreaterThanOrEqual(92)
    expect(data.rates.length).toBeGreaterThanOrEqual(300)
  })

  it('every rate and unlock references a known card and category', () => {
    const cats = new Set([...data.categories, 'foreign_spending', 'car_rental'])
    for (const r of data.rates) {
      expect(data.cards[r.cardSlug], `unknown card ${r.cardSlug}`).toBeDefined()
      expect(cats.has(r.category), `unknown category ${r.category} on ${r.cardSlug}`).toBe(true)
    }
    for (const u of data.unlocks) {
      expect(data.cards[u.cardSlug], `unknown card ${u.cardSlug}`).toBeDefined()
      expect(cats.has(u.category), `unknown category ${u.category}`).toBe(true)
    }
  })

  it('every card belongs to a seeded bank', () => {
    const banks = new Set(data.banks)
    for (const c of Object.values(data.cards)) expect(banks.has(c.bank), `${c.slug} → bank ${c.bank}`).toBe(true)
  })


  it('caps always carry a period and are explained in notes', () => {
    for (const r of data.rates.filter(r => r.cap != null)) {
      expect(r.period, `${r.cardSlug}/${r.category} cap without period`).not.toBeNull()
      expect(r.notes, `${r.cardSlug}/${r.category} cap without notes`).toBeTruthy()
    }
  })
})

describe('Chase Sapphire Preferred', () => {
  const slug = 'chase_sapphire_preferred'
  it('does not earn a grocery bonus in store', () => {
    // 3x is online grocery orders only; in-store supermarkets are 1x.
    expect(rateOf(data, slug, 'groceries')).toBeUndefined()
  })
  it('earns 3x on online grocery orders', () => {
    const r = rateOf(data, slug, 'online_groceries')
    expect(r?.rate).toBe(3)
    expect(r?.type).toBe('multiplier')
    expect(r?.notes).toMatch(/Walmart/)
  })
  it('reflects the June 2026 refresh', () => {
    expect(rateOf(data, slug, 'gas')?.rate).toBe(3)
    expect(rateOf(data, slug, 'ev_charging')?.rate).toBe(3)
    expect(rateOf(data, slug, 'travel')?.rate).toBe(5)
    expect(rateOf(data, slug, 'dining')?.rate).toBe(3)
    expect(rateOf(data, slug, 'streaming')?.rate).toBe(3)
    expect(rateOf(data, slug, 'flights')?.rate).toBe(2)
    expect(rateOf(data, slug, 'hotels')?.rate).toBe(2)
    expect(rateOf(data, slug, 'transit')?.rate).toBe(2)
    expect(rateOf(data, slug, 'car_rental')?.rate).toBe(2)
    expect(data.cards[slug].annualFee).toBe(95)
    expect(data.cards[slug].ftf).toBe(0)
  })
})

describe('Canadian cards', () => {
  it('Amex Cobalt: 5x eats & drinks with a $2,500/mo cap, 3x streaming, 2x gas/transit/travel', () => {
    const slug = 'amex_cobalt'
    const card = data.cards[slug]
    expect(card.bank).toBe('amex')
    expect(card.currency).toBe('MR')
    expect(card.cpp).toEqual([1.0, 1.5, 2.2])
    expect(card.annualFee).toBeCloseTo(15.99 * 12, 2)
    expect(card.ftf).toBe(2.5)
    for (const cat of ['dining', 'groceries', 'uber_eats']) {
      const r = rateOf(data, slug, cat)
      expect(r?.rate, cat).toBe(5)
      expect(r?.cap, cat).toBe(2500)
      expect(r?.period, cat).toBe('monthly')
    }
    expect(rateOf(data, slug, 'streaming')?.rate).toBe(3)
    for (const cat of ['gas', 'transit', 'uber', 'travel', 'flights', 'hotels']) expect(rateOf(data, slug, cat)?.rate, cat).toBe(2)
    expect(rateOf(data, slug, 'other')).toBeUndefined()
    expect(data.unlocks.filter(u => u.cardSlug === slug).map(u => u.category).sort()).toEqual(['uber', 'uber_eats'])
  })

  it('TD Aeroplan Visa Infinite: 1.5x gas, EV, groceries and direct Air Canada; $139 fee', () => {
    const slug = 'td_aeroplan_visa_infinite'
    const card = data.cards[slug]
    expect(card.bank).toBe('td')
    expect(data.banks).toContain('td')
    expect(card.currency).toBe('Aeroplan')
    expect(card.annualFee).toBe(139)
    expect(card.ftf).toBe(2.5)
    for (const cat of ['gas', 'ev_charging', 'groceries', 'flights']) expect(rateOf(data, slug, cat)?.rate, cat).toBe(1.5)
    expect(rateOf(data, slug, 'flights')?.notes).toMatch(/Air Canada/)
    expect(rateOf(data, slug, 'dining')).toBeUndefined()
  })
})
