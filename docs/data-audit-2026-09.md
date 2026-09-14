# Reward-data audit — September 2026

Full review of every seeded card (92 US cards across 17 issuers) against current
issuer terms, triggered by the Chase Sapphire Preferred grocery bug (the seed
gave CSP an unconditional 3x `groceries` row; the 3x is online-only). The audit
was split across five parallel research agents (Chase / Amex / Capital One + Citi /
Wells Fargo + BofA + US Bank / everything else), each working from a per-bank dump
produced by `node scripts/dump-seed.mjs <outDir>`. Findings were consolidated into:

- `supabase/migrations/0010_data_audit_fixes.sql` — the corrections for a live DB
- the seed files, edited in place so a fresh database gets the same end state
- `tests/seed-data.test.ts` — one assertion per confirmed correction, plus a
  test that the seed files and the migrations agree

Sourcing: the sandbox blocks page fetches to issuer and points sites, so agents
worked from search snippets and required two agreeing 2026 sources (or the
issuer's own wording quoted in a snippet) for any change. Items that could not
be confirmed to that standard are listed under **Not changed / follow-ups**.

## Modeling conventions applied

- **Only bonus rows are stored.** A card with no row for a category earns 1x/1%.
  A base rate above 1x lives on the `other` row.
- **`groceries` = in-store supermarkets. `online_groceries` (new) = online
  grocery orders, delivery and pickup.** Cards whose supermarket bonus explicitly
  covers online orders (Amex "in-store and online at U.S. supermarkets", US Bank
  "grocery delivery", Citi MileUp "grocery delivery services") got a matching row.
- **`travel` = the issuer's travel portal or general travel; `flights`/`hotels`/
  `car_rental` = booked direct.** When only the portal earns the bonus and the
  card has no direct-booking bonus at all (Capital One, Citi Double Cash, CSR car
  rentals), the portal rate is stored on the tile with a "via … portal" note so
  the tiebreaker flags the restriction. Notes on direct-booking rates never use
  "via"/"portal" (those words trigger the portal-restriction tiebreaker).
- **Co-brand airline/hotel bonuses stay on the brand tile.** Generic `flights`
  rows on Delta/United/Southwest/BA cards and generic `hotels` rows on Hilton/
  Marriott/Hyatt/IHG cards were removed where the card earns 1x (or only its base
  rate) on other airlines/hotels. The brand tile (`delta`, `united`, `hilton`, …)
  already carries the co-brand rate.
- **Closed-to-new-applicants cards stay active** (Citi Custom Cash, Amex
  EveryDay/EveryDay Preferred/Cash Magnet/Green, Wells Fargo Attune, US Bank
  Altitude Reserve, legacy $95 Savor): the app hides inactive cards from
  everyone, including people who still hold them. Only products nobody can hold
  any more were deactivated (Bilt Mastercard, Barclays Aviator Red, eBay Mastercard).
- **Caps** are stored as amount + period and spelled out in `notes`; shared caps
  (e.g. Cobalt eats & drinks, BofA Customized Cash) say so in the note.

## Corrections by issuer

### Chase
| card | change |
|---|---|
| Freedom Flex | FTF 3% → 0% (Chase drops the fee Sept 20 2026) |
| Sapphire Preferred (migration 0009) | in-store groceries 3x → none; `online_groceries` 3x; +3x gas & EV charging (June 15 2026 refresh); transit 5x portal → 2x other travel; car rental note fixed; hotel note mentions 3x vacation rentals |
| Sapphire Reserve | $550 → $795; travel 3x → 8x Chase Travel; flights/hotels 3x → 4x direct; transit 3x → none (other travel is 1x); car rental 3x → 8x portal-only |
| Prime Visa | full name; +5% Chase Travel |
| United Explorer / Club Infinite / Quest / Business | fees $150 / $695 / $350 / $150; United multiplier 3x / 5x / 4x (April 2026); generic `flights` removed on Explorer, Gateway, Business; Quest +2x streaming/travel/transit/car rental; Club Infinite +2x travel/car rental |
| Marriott Boundless | dining/gas/groceries 2x → 3x with $6,000/yr shared cap; +`other` 2x; generic hotels removed |
| Marriott Bold | 2x travel & hotels removed (July 2024); +2x groceries, streaming, utilities, rideshare |
| Hyatt | generic hotels removed; +2x fitness, transit |
| Southwest Plus / Premier / Priority | fees $99 / $149 / $229; Plus 3x → 2x Southwest, Priority 3x → 4x; partner-hotel/transit 2x removed (ended Dec 31 2025); Plus +2x gas & grocery ($5k cap); Premier dining/grocery $8k cap; Priority +2x gas; generic flights removed |
| Ink Business Cash | 5% online shopping removed (it is office supply + telecom); dining/gas $25k cap |
| Ink Business Preferred | travel 5x portal → 3x all travel ($150k cap); dining removed; +3x utilities, transit, car rental |
| IHG Premier / Traveler | Premier hotels 10x → 5x (10x is IHG only) +5x travel/flights/car rental/transit; Traveler generic hotels removed, +`other` 2x, +3x utilities & streaming |
| Air Canada Aeroplan | renamed, $95 → $195 (Sept 10 2026 refresh); +2x gas; dining/grocery 3x noted as dropping to 2x on Jan 1 2027; flights note corrected to Air Canada purchases |
| British Airways | flights note: BA/Aer Lingus/Iberia/LEVEL only |

### American Express
| card | change |
|---|---|
| Blue Cash Everyday | 3% streaming removed (BCE has none); +3% online groceries ($6k shared cap) |
| Blue Cash Preferred | +6% online groceries ($6k shared cap) |
| Gold | $250 → $325; dining 4x now capped $50k/yr; +5x prepaid hotels via Amex Travel (April 2026), +2x prepaid car rentals; +4x online groceries; flight note no longer implies a portal |
| Platinum | $695 → $895; flights capped $500k/yr; spurious 2x "other travel" removed |
| Green | full name "Classic Green Card" (Aug 2026) |
| Delta Blue / Gold / Platinum / Reserve | generic `flights` rows removed (Delta-only bonus lives on the `delta` tile); Blue's non-existent 2x groceries removed; Platinum hotels 2x → 3x direct, +2x supermarkets & online groceries; Reserve's non-existent dining/hotels removed |
| Hilton Honors / Surpass / Aspire | +`other` 3x base; generic hotels removed; Surpass +4x US online retail & 6x online groceries; Aspire +7x car rentals |
| Marriott Brilliant / Bonvoy Business | +`other` 2x (Brilliant); generic hotels removed |
| Business Gold | 4x groceries & online shopping removed (not 4x categories); travel 4x → 3x flights/prepaid hotels via Amex Travel |
| Business Platinum | $695 → $895; 1.5x `other` removed (base is 1x; the bonus is $5k+ purchases only) |
| EveryDay / EveryDay Preferred | +2x Amex Travel; +online groceries; Preferred FTF 0 → 2.7% |
| Cash Magnet / Blue Business Plus | Cash Magnet full name fixed; Blue Business Plus FTF 0 → 2.7% |
| Hilton Honors Business | $95 → $195 (2024 refresh); 6x dining/gas/12x hotels removed; `other` 3x → 5x on first $100k |
| Delta Gold Business / Platinum Business | Gold Business 2x gas removed; Platinum Business 1.5x `other` removed, +1.5x transit, +3x hotels direct |

### Capital One
| card | change |
|---|---|
| SavorOne → Savor | renamed (Oct 2024); 10% Uber/Uber Eats promo rows removed (ended Nov 2024); +5% hotels/car rentals/travel via Capital One Travel; entertainment note |
| Savor (legacy $95) | display name marks it legacy; kept active for existing holders |
| Venture X | hotels 5x → 10x via portal |
| Quicksilver / Spark Cash Plus / Spark Miles / Spark Miles Select / VentureOne | +5% portal hotels/car rentals/travel rows; Spark Miles → "Venture Business", Spark Miles Select → "VentureOne Business" (April 2026 rebrand) |

### Citi
| card | change |
|---|---|
| Custom Cash | +transit as a 5% eligible category |
| Double Cash | +5% hotels/car rentals/attractions via Citi Travel |
| Strata Premier | +10x Citi Travel portal & car rentals; +3x EV charging; hotel/flight/grocery notes; cpp 1.30 → 1.50 default |
| Costco Anywhere | 3% entertainment & streaming removed (never existed); gas note (5% Costco gas / 4% elsewhere); +4% EV charging (shared $7k cap); +3% flights/hotels/car rentals (eligible travel) |
| AAdvantage Platinum Select | 2x hotels removed |
| AAdvantage Executive | "World Legend" refresh, $595 → $695 (Aug 2026); +10x AA hotel/car portals |
| AAdvantage MileUp | +2x online groceries (delivery services included per Citi) |

### Wells Fargo, Bank of America, US Bank
| card | change |
|---|---|
| Autograph | 3x entertainment removed; +3x flights/hotels/car rentals (all travel); utilities note = phone plans only |
| Autograph Journey | +3x restaurants (was missing entirely); +3x car rentals; rows typed as points |
| Attune | transit/entertainment notes |
| Customized Cash | $2,500/quarter shared cap applied to every choice-category row; +3% EV charging, pharmacy, streaming, flights/hotels/car rentals (if chosen); +2% grocery delivery |
| Premium Rewards | +2x flights/hotels/car rentals |
| Alaska → Atmos Rewards Ascent / Business | renamed (Aug 2025), $75 → $95 / $70; +2x EV charging, streaming, transit (Ascent) and gas/EV/transit (Business); flights note = Alaska + Hawaiian only |
| Altitude Reserve | cpp 1.5 → 1.0 (Dec 2025 devaluation); travel note corrected (mobile wallet is 3x, not 5x); +3x flights/hotels/car rentals direct; dining 3x now capped $5k/cycle |
| Altitude Go | dining 4x capped $2,000/quarter (April 2025); +2x EV charging & grocery delivery |
| Cash+ | transit 2% → 5% choice category; +2% dining/gas/EV/grocery delivery everyday-category rows |

### Other issuers
| card | change |
|---|---|
| Bilt Mastercard | **deactivated** (retired Feb 6 2026); **Bilt Blue** added ($0, no FTF, rent up to 1.25x, 3x hotels / 2x flights via Bilt Travel, 3x Lyft) |
| Barclays AAdvantage Aviator Red | **deactivated** (converted to Citi AAdvantage Platinum Select, April 2026) |
| eBay Mastercard | **deactivated** (program ended March 2026) |
| PayPal Cashback | `other` 2% → 1.5% (3% only through PayPal checkout) |
| Sam's Club Mastercard | Sam's Club 5% → 3% (the other 2% is the Plus membership, earned with any tender); +5% EV charging sharing the $6k gas cap |
| Wyndham Earner Plus | $75 → $95, FTF 3% → 0% (June 2026 refresh); dining 2x → 4x; +4x groceries, travel, flights, car rentals, transit, EV; hotels note = Wyndham only; cpp 0.60 → 0.70 |
| Robinhood Gold | +5% travel through the Robinhood portal |
| Apple Card | `apple` tile unlock was missing; +3% Uber / Uber Eats with unlocks; redundant 2% dining row removed |
| Amazon Store Card | +5% Amazon (row was missing; the tile ranked it at 1%); +5% Whole Foods with unlock |
| Discover it Student | rotating 5% rows mirrored from Discover it Cash Back (same calendar and $1,500 cap) |

## Verified correct (no change)
Chase Freedom Unlimited; Freedom Flex rates; Ink Business Unlimited; United Gateway
(other than the generic flights row); Amex Blue Cash Preferred core; Amex Green
rates; all Delta/Hilton/Marriott brand tiles and unlocks; Capital One Venture,
Venture X Business, VentureOne; Citi Double Cash core; Wells Fargo Active Cash,
Signify; BofA Travel Rewards; US Bank Altitude Go core; Discover it Miles and Cash
Back; JetBlue Plus / JetBlue; Fidelity Rewards Visa; Sam's Club gas/dining;
all point valuations except TYP, Wyndham and Altitude Reserve (changed above).

## Not changed / follow-ups
- **Chase Air Canada Aeroplan general travel 3x** (travel/hotels/car rental/transit):
  only one write-up states it; verify against Chase's Sept 10 2026 terms.
- **Robinhood Gold FTF**: one source says new accounts from July 1 2026 pay 3%;
  kept at 0% (existing holders) pending a second source.
- **Bilt Blue rates** come from a single aggregated snippet; Obsidian ($95) and
  Palladium ($495) were not added because sources disagree on their multipliers.
- **Bilt Cash** (4% "cash" on everyday spend) is not cash and is not modeled.
- **Wells Fargo Rewards** has no program code; Autograph/Journey are stored as
  cashback at 1¢ although points transfer to partners (TPG 1.75¢).
- **No brand tile exists** for Alaska/Hawaiian (Atmos), Wyndham, American
  Airlines or Air Canada, so those co-brand bonuses sit on `flights`/`hotels`
  with airline-only notes.
- **Missing cards worth adding**: Citi Strata Elite ($595, 12x Citi Travel),
  Atmos Rewards Summit ($395), Synchrony Premier World Mastercard (eBay
  replacement, flat 2%), Bilt Obsidian/Palladium.
- **Card-specific transit definitions** (IHG Premier, United Quest) rest on
  Chase's standard travel MCC list.
- Caps are still display-only: ranking ignores `cap_amount` (pre-existing).
- Stale counts in `CLAUDE.md`/`architecture.md` were updated.

## Applying
Run migrations 0008, 0009 and 0010 in order against Supabase. All three are
idempotent (`ON CONFLICT … DO NOTHING/DO UPDATE`, targeted `DELETE`s). A fresh
database seeded from `supabase/seed/*.sql` plus the migrations ends in the same
state; `npm test` checks that the two stay in sync.
