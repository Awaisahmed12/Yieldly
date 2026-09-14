/**
 * Minimal parser for the hand-written SQL seed + migrations.
 * Turns the card / reward_rate / card_unlock INSERT statements into plain
 * records so data facts can be asserted in tests without a database.
 */
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'

export interface SeedCard {
  slug: string
  bank: string
  displayName: string
  fullName: string
  isBusiness: boolean
  currency: string
  cpp: [number, number, number]
  annualFee: number
  ftf: number
}

export interface SeedRate {
  cardSlug: string
  category: string
  rate: number
  type: 'multiplier' | 'cashback'
  cap: number | null
  period: 'monthly' | 'quarterly' | 'annual' | null
  notes: string | null
}

export interface SeedData {
  cards: Record<string, SeedCard>
  rates: SeedRate[]
  unlocks: { cardSlug: string; category: string }[]
  categories: string[]
  banks: string[]
  inactive: string[]
}

const ROOT = resolve(__dirname, '..')

const SEED_FILES = [
  'supabase/seed/01_banks.sql',
  'supabase/seed/02_categories.sql',
  'supabase/seed/03_cards.sql',
  'supabase/seed/04_reward_rates.sql',
  'supabase/seed/05_card_unlocks.sql',
]

const unq = (s: string) => s.replace(/''/g, "'")

export function loadSeed(files: string[] = SEED_FILES, extraFiles: string[] = []): SeedData {
  const sql = [...files, ...extraFiles].map(f => readFileSync(resolve(ROOT, f), 'utf8')).join('\n')

  const banks = [...sql.matchAll(/^\s*\('([a-z_]+)',\s*'(?:[^']|'')*',\s*'#[0-9A-Fa-f]{6}',\s*\d+\)/gm)].map(m => m[1])
  const categories = [...sql.matchAll(/\('([a-z_]+)',\s*'(?:[^']|'')*',\s*'[A-Za-z]+',\s*(?:true|false),\s*(?:NULL|null|'[a-z_]+'),\s*\d+\)/g)].map(m => m[1])

  const cards: Record<string, SeedCard> = {}
  const cardRe = /SELECT b\.id, '([a-z0-9_]+)', '((?:[^']|'')*)', '((?:[^']|'')*)',\s*(true|false), '([A-Za-z0-9]+)', ([\d.]+), ([\d.]+), ([\d.]+), ([\d.]+)(?:, ([\d.]+))?\s*FROM bank_ids b WHERE b\.slug = '([a-z_]+)'/g
  for (const m of sql.matchAll(cardRe)) {
    cards[m[1]] = {
      slug: m[1], bank: m[11], displayName: unq(m[2]), fullName: unq(m[3]), isBusiness: m[4] === 'true',
      currency: m[5], cpp: [Number(m[6]), Number(m[7]), Number(m[8])], annualFee: Number(m[9]), ftf: m[10] != null ? Number(m[10]) : 0,
    }
  }
  for (const m of sql.matchAll(/UPDATE cards SET foreign_transaction_fee = ([\d.]+) WHERE slug IN \(([\s\S]*?)\);/g)) {
    for (const s of m[2].matchAll(/'([a-z0-9_]+)'/g)) if (cards[s[1]]) cards[s[1]].ftf = Number(m[1])
  }
  for (const m of sql.matchAll(/UPDATE cards SET annual_fee = ([\d.]+) WHERE slug = '([a-z0-9_]+)'/g)) {
    if (cards[m[2]]) cards[m[2]].annualFee = Number(m[1])
  }

  // Later statements override earlier ones for the same (card, category), the
  // way ON CONFLICT ... DO UPDATE would; migrations mirrored into the seed are
  // therefore harmless.
  const rateMap = new Map<string, SeedRate>()
  const rateRe = /SELECT c\.id, '([a-z_]+)', ([\d.]+), '(multiplier|cashback)', (NULL|[\d.]+), (NULL|'[a-z]+'), (NULL|'(?:[^']|'')*')\s*FROM card_ids c WHERE c\.slug = '([a-z0-9_]+)'/g
  for (const m of sql.matchAll(rateRe)) {
    rateMap.set(`${m[7]}:${m[1]}`, {
      cardSlug: m[7], category: m[1], rate: Number(m[2]), type: m[3] as SeedRate['type'],
      cap: m[4] === 'NULL' ? null : Number(m[4]),
      period: m[5] === 'NULL' ? null : (m[5].replace(/'/g, '') as SeedRate['period']),
      notes: m[6] === 'NULL' ? null : unq(m[6].slice(1, -1)),
    })
  }
  // Rows removed by later migrations
  for (const m of sql.matchAll(/DELETE FROM reward_rates\s+WHERE card_id = \(SELECT id FROM cards WHERE slug = '([a-z0-9_]+)'\)\s+AND category_slug = '([a-z_]+)'/g)) {
    rateMap.delete(`${m[1]}:${m[2]}`)
  }
  const rates = [...rateMap.values()]

  const unlockKeys = new Set(
    [...sql.matchAll(/SELECT c\.id, '([a-z_]+)'\s+FROM card_ids c WHERE c\.slug = '([a-z0-9_]+)'\s*ON CONFLICT DO NOTHING/g)]
      .map(m => `${m[2]}:${m[1]}`)
  )
  const unlocks = [...unlockKeys].map(k => { const [cardSlug, category] = k.split(':'); return { cardSlug, category } })

  const inactive = [...sql.matchAll(/UPDATE cards SET is_active = false WHERE slug IN \(([\s\S]*?)\)/g)]
    .flatMap(m => [...m[1].matchAll(/'([a-z0-9_]+)'/g)].map(s => s[1]))

  return { cards, rates, unlocks, categories, banks, inactive }
}

export function rateOf(data: SeedData, cardSlug: string, category: string): SeedRate | undefined {
  return data.rates.find(r => r.cardSlug === cardSlug && r.category === category)
}
