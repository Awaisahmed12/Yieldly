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
  'supabase/migrations/0010_data_audit_fixes.sql',
  'supabase/migrations/0011_data_audit_pass2.sql',
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

describe('seed files mirror the migrations', () => {
  // Migrations are the source of truth for a live database; the seed files must
  // reproduce the same end state for a fresh one (FTF excluded: migration 0003
  // back-fills it with UPDATE lists that the seed never carried).
  const seedOnly = loadSeed()
  it('same cards, names, fees, currencies and valuations', () => {
    for (const c of Object.values(data.cards)) {
      const s = seedOnly.cards[c.slug]
      expect(s, `card ${c.slug} missing from seed`).toBeDefined()
      expect([s.displayName, s.fullName, s.currency, s.annualFee, s.cpp], c.slug).toEqual([c.displayName, c.fullName, c.currency, c.annualFee, c.cpp])
    }
  })
  it('same reward rates', () => {
    const key = (r: { cardSlug: string; category: string }) => `${r.cardSlug}:${r.category}`
    const a = new Map(data.rates.map(r => [key(r), r]))
    const b = new Map(seedOnly.rates.map(r => [key(r), r]))
    for (const [k, r] of a) expect(b.get(k), k).toEqual(r)
    for (const k of b.keys()) expect(a.has(k), `seed-only row ${k}`).toBe(true)
  })
  it('same unlocks and inactive cards', () => {
    const k = (u: { cardSlug: string; category: string }) => `${u.cardSlug}:${u.category}`
    expect(seedOnly.unlocks.map(k).sort()).toEqual(data.unlocks.map(k).sort())
    expect(seedOnly.inactive.sort()).toEqual(data.inactive.sort())
  })
})

describe('data rules', () => {
  it('notes only say "via"/"portal" when the bonus needs the issuer portal', () => {
    // The tiebreaker treats these words as a portal restriction, so a direct-booking
    // rate must not use them. Rows here are portal-only by design.
    const portalOnly = data.rates.filter(r => /\bvia |portal/i.test(r.notes ?? ''))
    for (const r of portalOnly) {
      expect(r.notes, `${r.cardSlug}/${r.category}`).not.toMatch(/booked direct(ly)?[^;]*via /i)
    }
  })
  it('flat-rate bonuses live on the other row; base 1x cards have none', () => {
    for (const slug of ['chase_freedom_unlimited', 'citi_double_cash', 'wells_fargo_active_cash', 'amex_hilton_honors', 'amex_hilton_surpass', 'amex_hilton_aspire', 'amex_marriott_brilliant', 'chase_marriott_boundless', 'chase_ihg_one_rewards_traveler']) {
      expect(rateOf(data, slug, 'other')?.rate, slug).toBeGreaterThan(1)
    }
    for (const slug of ['amex_platinum', 'amex_business_platinum', 'amex_delta_platinum_business', 'chase_sapphire_reserve', 'amex_gold']) {
      expect(rateOf(data, slug, 'other'), slug).toBeUndefined()
    }
  })
})

describe('September 2026 audit corrections', () => {
  it('Chase', () => {
    expect(data.cards.chase_freedom_flex.ftf).toBe(0)
    expect(data.cards.chase_sapphire_reserve.annualFee).toBe(795)
    expect(rateOf(data, 'chase_sapphire_reserve', 'travel')?.rate).toBe(8)
    expect(rateOf(data, 'chase_sapphire_reserve', 'flights')?.rate).toBe(4)
    expect(rateOf(data, 'chase_sapphire_reserve', 'hotels')?.rate).toBe(4)
    expect(rateOf(data, 'chase_sapphire_reserve', 'transit')).toBeUndefined()
    expect(rateOf(data, 'chase_amazon_prime_visa', 'travel')?.rate).toBe(5)
    expect(data.cards.chase_united_explorer.annualFee).toBe(150)
    expect(rateOf(data, 'chase_united_explorer', 'united')?.rate).toBe(3)
    expect(rateOf(data, 'chase_united_explorer', 'flights')).toBeUndefined()
    expect(data.cards.chase_united_club_infinite.annualFee).toBe(695)
    expect(rateOf(data, 'chase_united_club_infinite', 'united')?.rate).toBe(5)
    expect(data.cards.chase_united_quest.annualFee).toBe(350)
    expect(rateOf(data, 'chase_united_quest', 'united')?.rate).toBe(4)
    expect(rateOf(data, 'chase_united_quest', 'streaming')?.rate).toBe(2)
    expect(rateOf(data, 'chase_marriott_boundless', 'groceries')?.cap).toBe(6000)
    expect(rateOf(data, 'chase_marriott_boundless', 'other')?.rate).toBe(2)
    expect(rateOf(data, 'chase_marriott_bold', 'travel')).toBeUndefined()
    expect(rateOf(data, 'chase_hyatt', 'fitness')?.rate).toBe(2)
    expect(data.cards.chase_southwest_plus.annualFee).toBe(99)
    expect(rateOf(data, 'chase_southwest_plus', 'southwest')?.rate).toBe(2)
    expect(rateOf(data, 'chase_southwest_plus', 'gas')?.cap).toBe(5000)
    expect(rateOf(data, 'chase_southwest_plus', 'dining')).toBeUndefined()
    expect(data.cards.chase_southwest_premier.annualFee).toBe(149)
    expect(rateOf(data, 'chase_southwest_premier', 'dining')?.cap).toBe(8000)
    expect(data.cards.chase_southwest_priority.annualFee).toBe(229)
    expect(rateOf(data, 'chase_southwest_priority', 'southwest')?.rate).toBe(4)
    expect(rateOf(data, 'chase_ink_business_cash', 'online_shopping')).toBeUndefined()
    expect(rateOf(data, 'chase_ink_business_preferred', 'travel')?.rate).toBe(3)
    expect(rateOf(data, 'chase_ink_business_preferred', 'dining')).toBeUndefined()
    expect(rateOf(data, 'chase_ihg_one_rewards_premier', 'hotels')?.rate).toBe(5)
    expect(rateOf(data, 'chase_ihg_one_rewards_traveler', 'other')?.rate).toBe(2)
    expect(data.cards.chase_aeroplan.annualFee).toBe(195)
    expect(rateOf(data, 'chase_aeroplan', 'gas')?.rate).toBe(2)
  })
  it('American Express', () => {
    expect(data.cards.amex_gold.annualFee).toBe(325)
    expect(rateOf(data, 'amex_gold', 'dining')?.cap).toBe(50000)
    expect(rateOf(data, 'amex_gold', 'hotels')?.rate).toBe(5)
    expect(rateOf(data, 'amex_gold', 'online_groceries')?.rate).toBe(4)
    expect(data.cards.amex_platinum.annualFee).toBe(895)
    expect(rateOf(data, 'amex_platinum', 'flights')?.cap).toBe(500000)
    expect(rateOf(data, 'amex_platinum', 'travel')).toBeUndefined()
    expect(rateOf(data, 'amex_blue_cash_everyday', 'streaming')).toBeUndefined()
    expect(rateOf(data, 'amex_blue_cash_preferred', 'online_groceries')?.rate).toBe(6)
    expect(rateOf(data, 'amex_delta_blue', 'groceries')).toBeUndefined()
    for (const slug of ['amex_delta_blue', 'amex_delta_gold', 'amex_delta_platinum', 'amex_delta_reserve', 'amex_delta_gold_business', 'amex_delta_platinum_business']) {
      expect(rateOf(data, slug, 'flights'), slug).toBeUndefined()
      expect(data.unlocks.some(u => u.cardSlug === slug && u.category === 'delta'), slug).toBe(true)
    }
    expect(rateOf(data, 'amex_delta_reserve', 'dining')).toBeUndefined()
    for (const slug of ['amex_hilton_honors', 'amex_hilton_surpass', 'amex_hilton_aspire', 'amex_marriott_brilliant', 'amex_marriott_bonvoy_business', 'amex_hilton_honors_business']) {
      expect(rateOf(data, slug, 'hotels'), slug).toBeUndefined()
    }
    expect(rateOf(data, 'amex_hilton_surpass', 'online_shopping')?.rate).toBe(4)
    expect(rateOf(data, 'amex_hilton_aspire', 'car_rental')?.rate).toBe(7)
    expect(rateOf(data, 'amex_business_gold', 'groceries')).toBeUndefined()
    expect(rateOf(data, 'amex_business_gold', 'travel')?.rate).toBe(3)
    expect(data.cards.amex_business_platinum.annualFee).toBe(895)
    expect(data.cards.amex_everyday_preferred.ftf).toBe(2.7)
    expect(data.cards.amex_blue_business_plus.ftf).toBe(2.7)
    expect(data.cards.amex_cash_magnet.fullName).toBe('Cash Magnet® Card')
    expect(data.cards.amex_hilton_honors_business.annualFee).toBe(195)
    expect(rateOf(data, 'amex_hilton_honors_business', 'other')?.rate).toBe(5)
    expect(rateOf(data, 'amex_delta_platinum_business', 'transit')?.rate).toBe(1.5)
  })
  it('Capital One and Citi', () => {
    expect(data.cards.capital_one_savorone.displayName).toBe('Savor')
    expect(rateOf(data, 'capital_one_savorone', 'uber')).toBeUndefined()
    expect(rateOf(data, 'capital_one_savorone', 'hotels')?.rate).toBe(5)
    expect(rateOf(data, 'capital_one_venture_x', 'hotels')?.rate).toBe(10)
    expect(rateOf(data, 'capital_one_quicksilver', 'travel')?.rate).toBe(5)
    expect(data.cards.capital_one_spark_miles.displayName).toBe('Venture Business')
    expect(rateOf(data, 'citi_custom_cash', 'transit')?.cap).toBe(500)
    expect(rateOf(data, 'citi_double_cash', 'travel')?.rate).toBe(5)
    expect(rateOf(data, 'citi_strata_premier', 'travel')?.rate).toBe(10)
    expect(rateOf(data, 'citi_strata_premier', 'ev_charging')?.rate).toBe(3)
    expect(data.cards.citi_strata_premier.cpp).toEqual([1, 1.5, 1.8])
    expect(rateOf(data, 'citi_costco', 'entertainment')).toBeUndefined()
    expect(rateOf(data, 'citi_costco', 'streaming')).toBeUndefined()
    expect(rateOf(data, 'citi_costco', 'ev_charging')?.cap).toBe(7000)
    expect(rateOf(data, 'citi_aadvantage_platinum_select', 'hotels')).toBeUndefined()
    expect(data.cards.citi_aadvantage_executive.annualFee).toBe(695)
    expect(rateOf(data, 'citi_aadvantage_mileup', 'online_groceries')?.rate).toBe(2)
  })
  it('Wells Fargo, Bank of America, US Bank', () => {
    expect(rateOf(data, 'wells_fargo_autograph', 'entertainment')).toBeUndefined()
    expect(rateOf(data, 'wells_fargo_autograph', 'flights')?.rate).toBe(3)
    expect(rateOf(data, 'wells_fargo_autograph_journey', 'dining')?.rate).toBe(3)
    expect(rateOf(data, 'wells_fargo_autograph_journey', 'hotels')?.type).toBe('multiplier')
    expect(rateOf(data, 'bofa_customized_cash', 'dining')?.cap).toBe(2500)
    expect(rateOf(data, 'bofa_customized_cash', 'pharmacy')?.rate).toBe(3)
    expect(rateOf(data, 'bofa_premium_rewards', 'flights')?.rate).toBe(2)
    expect(data.cards.bofa_alaska_airlines.displayName).toBe('Atmos Rewards Ascent Visa')
    expect(data.cards.bofa_alaska_airlines.annualFee).toBe(95)
    expect(rateOf(data, 'bofa_alaska_airlines', 'streaming')?.rate).toBe(2)
    expect(data.cards.bofa_alaska_airlines_business.annualFee).toBe(70)
    expect(data.cards.usbank_altitude_reserve.cpp).toEqual([1, 1, 1])
    expect(rateOf(data, 'usbank_altitude_reserve', 'flights')?.rate).toBe(3)
    expect(rateOf(data, 'usbank_altitude_go', 'dining')?.cap).toBe(2000)
    expect(rateOf(data, 'usbank_altitude_go', 'online_groceries')?.rate).toBe(2)
    expect(rateOf(data, 'usbank_cash_plus', 'transit')?.rate).toBe(5)
    expect(rateOf(data, 'usbank_cash_plus', 'dining')?.rate).toBe(2)
  })
  it('other issuers', () => {
    expect(data.inactive.sort()).toEqual(['barclays_aadvantage_aviator_red', 'bilt_mastercard', 'ebay_mastercard'])
    expect(data.cards.bilt_blue.annualFee).toBe(0)
    expect(rateOf(data, 'bilt_blue', 'rent')?.rate).toBe(1.25)
    expect(rateOf(data, 'bilt_blue', 'dining')).toBeUndefined()
    expect(rateOf(data, 'paypal_cashback', 'other')?.rate).toBe(1.5)
    expect(rateOf(data, 'synchrony_sams_club', 'sams_club')?.rate).toBe(3)
    expect(rateOf(data, 'synchrony_sams_club', 'ev_charging')?.cap).toBe(6000)
    expect(data.cards.barclays_wyndham_rewards_earner_plus.annualFee).toBe(95)
    expect(data.cards.barclays_wyndham_rewards_earner_plus.ftf).toBe(0)
    expect(rateOf(data, 'barclays_wyndham_rewards_earner_plus', 'dining')?.rate).toBe(4)
    expect(rateOf(data, 'barclays_wyndham_rewards_earner_plus', 'groceries')?.rate).toBe(4)
    expect(rateOf(data, 'robinhood_gold_card', 'travel')?.rate).toBe(5)
    expect(data.unlocks.filter(u => u.cardSlug === 'apple_card').map(u => u.category).sort()).toEqual(['apple', 'uber', 'uber_eats'])
    expect(rateOf(data, 'apple_card', 'dining')).toBeUndefined()
    expect(rateOf(data, 'amazon_store_card', 'amazon')?.rate).toBe(5)
    expect(data.unlocks.some(u => u.cardSlug === 'amazon_store_card' && u.category === 'whole_foods')).toBe(true)
    expect(rateOf(data, 'discover_it_student', 'groceries')?.cap).toBe(1500)
  })
})

describe('September 2026 audit, second verification pass', () => {
  it('base rates on flat-rate cards', () => {
    const base: Record<string, number> = {
      chase_freedom_unlimited: 1.5, chase_ink_business_unlimited: 1.5, citi_double_cash: 2, wells_fargo_active_cash: 2,
      wells_fargo_signify_business_cash: 2, capital_one_venture: 2, capital_one_venture_x: 2, capital_one_quicksilver: 1.5,
      capital_one_venture_one: 1.25, capital_one_spark_cash: 2, capital_one_spark_miles_select: 1.5, bofa_premium_rewards: 1.5,
      bofa_travel_rewards: 1.5, discover_it_miles: 1.5, fidelity_rewards_visa: 2, robinhood_gold_card: 3, paypal_cashback: 1.5,
      apple_card: 2, amex_cash_magnet: 1.5, amex_blue_business_plus: 2, amex_hilton_honors: 3, amex_marriott_brilliant: 2,
      chase_marriott_boundless: 2, chase_ihg_one_rewards_traveler: 2, chase_ihg_one_rewards_premier: 3,
    }
    for (const [slug, rate] of Object.entries(base)) expect(rateOf(data, slug, 'other')?.rate, slug).toBe(rate)
    for (const slug of ['chase_sapphire_preferred', 'chase_sapphire_reserve', 'amex_gold', 'amex_platinum', 'citi_custom_cash', 'citi_strata_premier', 'capital_one_savorone', 'wells_fargo_autograph', 'usbank_altitude_go', 'bilt_blue', 'barclays_jetblue_plus', 'discover_it_cash']) {
      expect(rateOf(data, slug, 'other'), slug).toBeUndefined()
    }
  })
  it('foreign transaction fees', () => {
    expect(data.cards.citi_costco.ftf).toBe(0)
    expect(data.cards.usbank_altitude_go.ftf).toBe(3)
    expect(data.cards.robinhood_gold_card.ftf).toBe(3)
    expect(data.cards.chase_freedom_flex.ftf).toBe(0)
    expect(data.cards.chase_freedom_unlimited.ftf).toBe(3)
  })
  it('rows added or corrected', () => {
    expect(rateOf(data, 'amex_green', 'flights')?.rate).toBe(3)
    expect(rateOf(data, 'amex_green', 'hotels')?.rate).toBe(3)
    expect(rateOf(data, 'amex_business_gold', 'utilities')?.rate).toBe(4)
    expect(rateOf(data, 'amex_delta_gold', 'online_groceries')?.notes).not.toMatch(/cap/)
    expect(rateOf(data, 'chase_aeroplan', 'travel')?.rate).toBe(3)
    expect(rateOf(data, 'chase_aeroplan', 'hotels')?.rate).toBe(3)
    expect(rateOf(data, 'chase_southwest_priority', 'dining')?.cap).toBe(8000)
    expect(rateOf(data, 'chase_british_airways', 'flights')?.notes).toMatch(/other airlines 1x/)
    expect(rateOf(data, 'citi_aadvantage_executive', 'hotels')?.rate).toBe(12)
    expect(rateOf(data, 'citi_custom_cash', 'flights')?.cap).toBe(500)
    expect(rateOf(data, 'citi_custom_cash', 'hotels')?.rate).toBe(5)
    expect(rateOf(data, 'capital_one_venture_x_business', 'travel')?.rate).toBe(10)
    expect(rateOf(data, 'wells_fargo_autograph', 'ev_charging')?.rate).toBe(3)
    expect(rateOf(data, 'bofa_customized_cash', 'utilities')?.cap).toBe(2500)
    expect(rateOf(data, 'usbank_altitude_reserve', 'dining')).toBeUndefined()
    expect(rateOf(data, 'usbank_cash_plus', 'entertainment')?.notes).toMatch(/Movie theaters/)
    expect(rateOf(data, 'barclays_wyndham_rewards_earner_plus', 'hotels')?.notes).toMatch(/Wyndham stays only/)
    expect(rateOf(data, 'fidelity_rewards_visa', 'other')?.notes).toMatch(/Fidelity account/)
  })
})
