// Dumps the seeded card catalogue (cards + reward_rates + card_unlocks + FTF) as
// markdown, one file per bank group, for data-audit review.
// Usage: node scripts/dump-seed.mjs <outDir>
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

const root = resolve(new URL('..', import.meta.url).pathname)
const read = p => readFileSync(resolve(root, p), 'utf8')

const sql = [
  'supabase/seed/03_cards.sql', 'supabase/seed/04_reward_rates.sql', 'supabase/seed/05_card_unlocks.sql',
  'supabase/migrations/0003_foreign_transaction_fee.sql', 'supabase/migrations/0004_add_missing_cards.sql',
  'supabase/migrations/0007_new_category_rates.sql',
  'supabase/migrations/0008_canadian_cards.sql', 'supabase/migrations/0009_online_groceries.sql',
  'supabase/migrations/0010_data_audit_fixes.sql',
].map(read).join('\n')

const cards = {}
const cardRe = /SELECT b\.id, '([a-z0-9_]+)', '((?:[^']|'')*)', '((?:[^']|'')*)',\s*(true|false), '([A-Za-z0-9]+)', ([\d.]+), ([\d.]+), ([\d.]+), ([\d.]+)(?:, ([\d.]+))?\s*FROM bank_ids b WHERE b\.slug = '([a-z_]+)'/g
for (const m of sql.matchAll(cardRe)) {
  const [, slug, display, full, biz, cur, lo, def, hi, fee, ftf, bank] = m
  cards[slug] = { slug, bank, display, full, biz, cur, cpp: `${lo}/${def}/${hi}`, fee, ftf: ftf ?? null, rates: [], unlocks: [] }
}
// FTF updates from migration 0003
for (const m of sql.matchAll(/UPDATE cards SET foreign_transaction_fee = ([\d.]+) WHERE slug IN \(([\s\S]*?)\);/g)) {
  for (const s of m[2].matchAll(/'([a-z0-9_]+)'/g)) if (cards[s[1]]) cards[s[1]].ftf = m[1]
}
// Later single-card updates (audit migrations) override the 0003 lists
for (const m of sql.matchAll(/UPDATE cards SET ([^;]+?) WHERE slug = '([a-z0-9_]+)';/g)) {
  const c = cards[m[2]]; if (!c) continue
  for (const kv of m[1].matchAll(/(\w+) = ('(?:[^']|'')*'|[\w.]+)/g)) {
    const val = kv[2].startsWith("'") ? kv[2].slice(1, -1).replace(/''/g, "'") : kv[2]
    if (kv[1] === 'foreign_transaction_fee') c.ftf = val
    else if (kv[1] === 'annual_fee') c.fee = val
    else if (kv[1] === 'display_name') c.display = val
    else if (kv[1] === 'full_name') c.full = val
    else if (kv[1] === 'is_active' && val === 'false') c.inactive = true
  }
}
for (const c of Object.values(cards)) if (c.ftf == null) c.ftf = '0 (default)'

const rateRe = /SELECT c\.id, '([a-z_]+)', ([\d.]+), '(multiplier|cashback)', (NULL|[\d.]+), (NULL|'[a-z]+'), (NULL|'(?:[^']|'')*')\s*FROM card_ids c WHERE c\.slug = '([a-z0-9_]+)'/g
for (const m of sql.matchAll(rateRe)) {
  const [, cat, rate, type, cap, period, notes, slug] = m
  cards[slug]?.rates.push({ cat, rate, type, cap, period: period.replace(/'/g, ''), notes: notes === 'NULL' ? '' : notes.slice(1, -1).replace(/''/g, "'") })
}
for (const m of sql.matchAll(/SELECT c\.id, '([a-z_]+)'\s+FROM card_ids c WHERE c\.slug = '([a-z0-9_]+)'\s*ON CONFLICT DO NOTHING/g)) {
  cards[m[2]]?.unlocks.push(m[1])
}

const groups = {
  G1_chase: ['chase'],
  G2_amex: ['amex'],
  G3_capone_citi: ['capital_one', 'citi'],
  G4_wf_bofa_usbank: ['wells_fargo', 'bofa', 'usbank'],
  G5_others: ['barclays', 'discover', 'fidelity', 'synchrony', 'robinhood', 'paypal', 'ebay', 'bilt', 'apple', 'amazon', 'cash_app', 'costco', 'sams_club'],
}
const outDir = process.argv[2] ?? 'seed-dump'
mkdirSync(outDir, { recursive: true })
let total = 0
for (const [g, banks] of Object.entries(groups)) {
  const list = Object.values(cards).filter(c => banks.includes(c.bank))
  total += list.length
  let md = `# ${g} — ${list.length} cards\n\nColumns: bank | slug | display_name | full_name | business | reward_currency | cpp low/default/high | annual_fee | foreign_transaction_fee\n\n`
  for (const c of list) {
    md += `## ${c.slug}${c.inactive ? ' (INACTIVE)' : ''}\n${c.bank} | ${c.display} | ${c.full} | business=${c.biz} | ${c.cur} | cpp ${c.cpp} | fee $${c.fee} | FTF ${c.ftf}%\n\n`
    md += `| category | rate | type | cap | period | notes |\n|---|---|---|---|---|---|\n`
    for (const r of c.rates) md += `| ${r.cat} | ${r.rate} | ${r.type} | ${r.cap} | ${r.period} | ${r.notes} |\n`
    if (!c.rates.length) md += `| (none — all categories default to 1x/1%) | | | | | |\n`
    md += `\nunlocks: ${c.unlocks.join(', ') || '(none)'}\n\n`
  }
  writeFileSync(resolve(outDir, `${g}.md`), md)
  console.log(g, list.length)
}
console.log('total cards', total, '/ parsed', Object.keys(cards).length)
