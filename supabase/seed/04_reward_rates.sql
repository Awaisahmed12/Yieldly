-- Seed: Reward Rates
-- Only rows where rate > 1x / 1%. The app defaults to 1x/1% for any missing category.
-- Idempotent: ON CONFLICT (card_id, category_slug) DO NOTHING
-- Pattern: CTE looks up card UUID by slug, then inserts the rate row.

-- ── CHASE FREEDOM UNLIMITED ───────────────────────────────────────────────
-- 3% dining, 3% pharmacy, 5% travel (Chase Travel), 1.5% everything else

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_freedom_unlimited'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'pharmacy', 3.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_freedom_unlimited'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'cashback', NULL, NULL, 'Via Chase Travel portal'
FROM card_ids c WHERE c.slug = 'chase_freedom_unlimited'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 1.50, 'cashback', NULL, NULL, 'Base rate on all other purchases'
FROM card_ids c WHERE c.slug = 'chase_freedom_unlimited'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE FREEDOM FLEX ────────────────────────────────────────────────────
-- 3% dining, 3% pharmacy, 5% travel (Chase Travel), 5% rotating (groceries/gas shown)

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_freedom_flex'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'pharmacy', 3.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_freedom_flex'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'cashback', NULL, NULL, 'Via Chase Travel portal'
FROM card_ids c WHERE c.slug = 'chase_freedom_flex'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 5.00, 'cashback', 1500.00, 'quarterly', 'Rotating 5% category — verify current quarter'
FROM card_ids c WHERE c.slug = 'chase_freedom_flex'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 5.00, 'cashback', 1500.00, 'quarterly', 'Rotating 5% category — verify current quarter'
FROM card_ids c WHERE c.slug = 'chase_freedom_flex'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE SAPPHIRE PREFERRED ──────────────────────────────────────────────
-- 3x dining, 3x groceries, 5x travel portal, 2x flights/hotels, 3x streaming, 5x transit portal

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_sapphire_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_sapphire_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'multiplier', NULL, NULL, 'Via Chase Travel portal'
FROM card_ids c WHERE c.slug = 'chase_sapphire_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_sapphire_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_sapphire_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_sapphire_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 5.00, 'multiplier', NULL, NULL, 'Via Chase Travel portal'
FROM card_ids c WHERE c.slug = 'chase_sapphire_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE SAPPHIRE RESERVE ────────────────────────────────────────────────
-- 3x dining, 3x travel, 3x flights, 3x hotels, 3x transit

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_sapphire_reserve'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_sapphire_reserve'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_sapphire_reserve'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_sapphire_reserve'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_sapphire_reserve'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE AMAZON PRIME VISA ───────────────────────────────────────────────
-- 5% Amazon/Whole Foods, 2% dining/gas/transit

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'amazon', 5.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_amazon_prime_visa'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'whole_foods', 5.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_amazon_prime_visa'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_amazon_prime_visa'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_amazon_prime_visa'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_amazon_prime_visa'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE UNITED EXPLORER ─────────────────────────────────────────────────
-- 2x United, 2x flights, 2x dining, 2x hotels

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'united', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_explorer'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_explorer'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_explorer'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_explorer'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE UNITED CLUB INFINITE ────────────────────────────────────────────
-- 4x United, 2x flights, 2x dining, 2x hotels, 2x transit

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'united', 4.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_club_infinite'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_club_infinite'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_club_infinite'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_club_infinite'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_club_infinite'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE MARRIOTT BOUNDLESS ──────────────────────────────────────────────
-- 6x Marriott, 2x hotels/dining/gas/groceries

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'marriott', 6.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_marriott_boundless'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_marriott_boundless'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_marriott_boundless'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_marriott_boundless'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_marriott_boundless'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE SOUTHWEST PLUS ──────────────────────────────────────────────────
-- 3x Southwest, 2x flights/hotels/dining/transit

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'southwest', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE SOUTHWEST PREMIER ───────────────────────────────────────────────
-- Same structure as Southwest Plus

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'southwest', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE SOUTHWEST PRIORITY ──────────────────────────────────────────────
-- Same structure as Southwest Plus/Premier

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'southwest', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_priority'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_priority'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_priority'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_priority'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_southwest_priority'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE INK BUSINESS CASH ───────────────────────────────────────────────
-- 5% office supply/online, 2% dining/gas

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_shopping', 5.00, 'cashback', 25000.00, 'annual', 'At office supply stores and on internet, cable, phone services'
FROM card_ids c WHERE c.slug = 'chase_ink_business_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_ink_business_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_ink_business_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE INK BUSINESS UNLIMITED ─────────────────────────────────────────
-- 1.5% flat on everything

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 1.50, 'cashback', NULL, NULL, 'Flat 1.5% on all purchases'
FROM card_ids c WHERE c.slug = 'chase_ink_business_unlimited'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE WORLD OF HYATT ──────────────────────────────────────────────────
-- 4x Hyatt, 2x hotels/dining/flights

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hyatt', 4.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_hyatt'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_hyatt'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_hyatt'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_hyatt'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX BLUE CASH EVERYDAY ───────────────────────────────────────────────
-- 3% groceries, 3% online shopping, 3% gas, 3% streaming

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 3.00, 'cashback', 6000.00, 'annual', 'At US supermarkets; 1% after $6,000/yr'
FROM card_ids c WHERE c.slug = 'amex_blue_cash_everyday'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_shopping', 3.00, 'cashback', 6000.00, 'annual', 'US online retailers; 1% after $6,000/yr'
FROM card_ids c WHERE c.slug = 'amex_blue_cash_everyday'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 3.00, 'cashback', 6000.00, 'annual', 'At US gas stations; 1% after $6,000/yr'
FROM card_ids c WHERE c.slug = 'amex_blue_cash_everyday'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 3.00, 'cashback', NULL, NULL, 'Select US streaming subscriptions'
FROM card_ids c WHERE c.slug = 'amex_blue_cash_everyday'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX BLUE CASH PREFERRED ──────────────────────────────────────────────
-- 6% groceries (cap $6k/yr), 6% streaming, 3% transit, 3% gas

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 6.00, 'cashback', 6000.00, 'annual', 'At US supermarkets; 1% after $6,000/yr'
FROM card_ids c WHERE c.slug = 'amex_blue_cash_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 6.00, 'cashback', NULL, NULL, 'Select US streaming subscriptions'
FROM card_ids c WHERE c.slug = 'amex_blue_cash_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 3.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_blue_cash_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 3.00, 'cashback', NULL, NULL, 'At US gas stations'
FROM card_ids c WHERE c.slug = 'amex_blue_cash_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX GOLD ─────────────────────────────────────────────────────────────
-- 4x dining, 4x groceries (cap $25k/yr), 3x flights

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 4.00, 'multiplier', NULL, NULL, 'At restaurants worldwide'
FROM card_ids c WHERE c.slug = 'amex_gold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 4.00, 'multiplier', 25000.00, 'annual', 'At US supermarkets; 1x after $25,000/yr'
FROM card_ids c WHERE c.slug = 'amex_gold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Booked directly with airlines or via Amex Travel'
FROM card_ids c WHERE c.slug = 'amex_gold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX PLATINUM ─────────────────────────────────────────────────────────
-- 5x flights (direct/Amex Travel), 5x hotels (Amex Travel), 2x other travel

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 5.00, 'multiplier', NULL, NULL, 'Booked directly with airlines or via Amex Travel'
FROM card_ids c WHERE c.slug = 'amex_platinum'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'multiplier', NULL, NULL, 'Via Amex Travel'
FROM card_ids c WHERE c.slug = 'amex_platinum'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 2.00, 'multiplier', NULL, NULL, 'On other travel purchases'
FROM card_ids c WHERE c.slug = 'amex_platinum'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX GREEN ────────────────────────────────────────────────────────────
-- 3x travel, 3x transit, 3x dining

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_green'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_green'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_green'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX DELTA BLUE ───────────────────────────────────────────────────────
-- 2x Delta, 2x flights, 2x dining, 2x groceries

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'delta', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_blue'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_blue'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_blue'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'multiplier', NULL, NULL, 'At US supermarkets'
FROM card_ids c WHERE c.slug = 'amex_delta_blue'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX DELTA GOLD ───────────────────────────────────────────────────────
-- 2x Delta, 2x flights, 2x dining, 2x groceries

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'delta', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_gold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_gold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_gold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'multiplier', NULL, NULL, 'At US supermarkets'
FROM card_ids c WHERE c.slug = 'amex_delta_gold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX DELTA PLATINUM ───────────────────────────────────────────────────
-- 3x Delta, 3x flights (direct), 2x dining, 2x hotels

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'delta', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_platinum'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Directly with Delta'
FROM card_ids c WHERE c.slug = 'amex_delta_platinum'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_platinum'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_platinum'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX DELTA RESERVE ────────────────────────────────────────────────────
-- 3x Delta, 3x flights (direct), 2x dining, 2x hotels

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'delta', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_reserve'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Directly with Delta'
FROM card_ids c WHERE c.slug = 'amex_delta_reserve'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_reserve'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_reserve'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX HILTON HONORS ────────────────────────────────────────────────────
-- 7x Hilton, 5x hotels/dining/groceries/gas

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hilton', 7.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_hilton_honors'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_hilton_honors'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 5.00, 'multiplier', NULL, NULL, 'At US restaurants'
FROM card_ids c WHERE c.slug = 'amex_hilton_honors'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 5.00, 'multiplier', NULL, NULL, 'At US supermarkets'
FROM card_ids c WHERE c.slug = 'amex_hilton_honors'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 5.00, 'multiplier', NULL, NULL, 'At US gas stations'
FROM card_ids c WHERE c.slug = 'amex_hilton_honors'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX HILTON SURPASS ───────────────────────────────────────────────────
-- 12x Hilton, 6x hotels/dining/groceries/gas

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hilton', 12.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_hilton_surpass'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 6.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_hilton_surpass'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 6.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_hilton_surpass'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 6.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_hilton_surpass'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 6.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_hilton_surpass'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX HILTON ASPIRE ────────────────────────────────────────────────────
-- 14x Hilton, 7x hotels/flights (direct)/dining

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hilton', 14.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_hilton_aspire'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 7.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_hilton_aspire'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 7.00, 'multiplier', NULL, NULL, 'Directly with airlines'
FROM card_ids c WHERE c.slug = 'amex_hilton_aspire'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 7.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_hilton_aspire'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX MARRIOTT BRILLIANT ───────────────────────────────────────────────
-- 6x Marriott, 3x hotels/dining, 2x flights

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'marriott', 6.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_marriott_brilliant'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_marriott_brilliant'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_marriott_brilliant'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_marriott_brilliant'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX BUSINESS GOLD ────────────────────────────────────────────────────
-- 4x on highest-spend category each billing cycle (6 eligible categories)
-- Cap: 150,000 points per year on 4x earnings

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 4.00, 'multiplier', 150000.00, 'annual', 'Automatic 4x on top 2 eligible spend categories each billing cycle'
FROM card_ids c WHERE c.slug = 'amex_business_gold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 4.00, 'multiplier', 150000.00, 'annual', 'Automatic 4x on top 2 eligible spend categories each billing cycle'
FROM card_ids c WHERE c.slug = 'amex_business_gold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 4.00, 'multiplier', 150000.00, 'annual', 'Automatic 4x on top 2 eligible spend categories each billing cycle'
FROM card_ids c WHERE c.slug = 'amex_business_gold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_shopping', 4.00, 'multiplier', 150000.00, 'annual', 'Automatic 4x on top 2 eligible spend categories each billing cycle'
FROM card_ids c WHERE c.slug = 'amex_business_gold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 4.00, 'multiplier', 150000.00, 'annual', 'Automatic 4x on top 2 eligible spend categories each billing cycle'
FROM card_ids c WHERE c.slug = 'amex_business_gold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 4.00, 'multiplier', 150000.00, 'annual', 'Automatic 4x on top 2 eligible spend categories each billing cycle'
FROM card_ids c WHERE c.slug = 'amex_business_gold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX BUSINESS PLATINUM ────────────────────────────────────────────────
-- 5x flights/hotels (Amex Travel), 1.5x on purchases $5k+

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 5.00, 'multiplier', NULL, NULL, 'Via Amex Travel'
FROM card_ids c WHERE c.slug = 'amex_business_platinum'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'multiplier', NULL, NULL, 'Via Amex Travel'
FROM card_ids c WHERE c.slug = 'amex_business_platinum'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 1.50, 'multiplier', NULL, NULL, 'On eligible purchases of $5,000 or more'
FROM card_ids c WHERE c.slug = 'amex_business_platinum'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CITI DOUBLE CASH ──────────────────────────────────────────────────────
-- 2% on everything (1% when you buy + 1% when you pay)

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'cashback', NULL, NULL, '1% when you buy + 1% when you pay'
FROM card_ids c WHERE c.slug = 'citi_double_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CITI CUSTOM CASH ──────────────────────────────────────────────────────
-- 5% on top eligible spend category each billing cycle (up to $500/mo), 1% on all else

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 5.00, 'cashback', 500.00, 'monthly', '5% on top eligible spend category each billing cycle (up to $500/mo)'
FROM card_ids c WHERE c.slug = 'citi_custom_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 5.00, 'cashback', 500.00, 'monthly', '5% on top eligible spend category each billing cycle (up to $500/mo)'
FROM card_ids c WHERE c.slug = 'citi_custom_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 5.00, 'cashback', 500.00, 'monthly', '5% on top eligible spend category each billing cycle (up to $500/mo)'
FROM card_ids c WHERE c.slug = 'citi_custom_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'cashback', 500.00, 'monthly', '5% on top eligible spend category each billing cycle (up to $500/mo)'
FROM card_ids c WHERE c.slug = 'citi_custom_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 5.00, 'cashback', 500.00, 'monthly', '5% on top eligible spend category each billing cycle (up to $500/mo)'
FROM card_ids c WHERE c.slug = 'citi_custom_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'pharmacy', 5.00, 'cashback', 500.00, 'monthly', '5% on top eligible spend category each billing cycle (up to $500/mo)'
FROM card_ids c WHERE c.slug = 'citi_custom_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'entertainment', 5.00, 'cashback', 500.00, 'monthly', '5% on top eligible spend category each billing cycle (up to $500/mo)'
FROM card_ids c WHERE c.slug = 'citi_custom_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CITI STRATA PREMIER ───────────────────────────────────────────────────
-- 3x dining/groceries/gas/flights/hotels

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'citi_strata_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'citi_strata_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'citi_strata_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'citi_strata_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'citi_strata_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CITI COSTCO ANYWHERE VISA ─────────────────────────────────────────────
-- 4% gas (cap $7k/yr), 3% dining/travel, 2% Costco, 3% streaming/entertainment

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 4.00, 'cashback', 7000.00, 'annual', '4% on first $7,000 in gas per calendar year, 1% after'
FROM card_ids c WHERE c.slug = 'citi_costco'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'citi_costco'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 3.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'citi_costco'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'costco', 2.00, 'cashback', NULL, NULL, 'All Costco and Costco.com purchases'
FROM card_ids c WHERE c.slug = 'citi_costco'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'entertainment', 3.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'citi_costco'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 3.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'citi_costco'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CAPITAL ONE VENTURE X ─────────────────────────────────────────────────
-- 10x travel portal, 5x hotels/flights portal, 2x everything else

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 10.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'multiplier', NULL, NULL, 'On all other purchases'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CAPITAL ONE VENTURE ───────────────────────────────────────────────────
-- 5x travel portal (hotels/rental cars), 2x everything else

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'multiplier', NULL, NULL, 'On all other purchases'
FROM card_ids c WHERE c.slug = 'capital_one_venture'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CAPITAL ONE VENTUREONE ────────────────────────────────────────────────
-- 5x travel portal (hotels/rental cars), 1.25x everything else

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_one'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_one'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 1.25, 'multiplier', NULL, NULL, 'On all other purchases'
FROM card_ids c WHERE c.slug = 'capital_one_venture_one'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CAPITAL ONE QUICKSILVER ───────────────────────────────────────────────
-- 1.5% flat on everything

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 1.50, 'cashback', NULL, NULL, 'Flat 1.5% on all purchases'
FROM card_ids c WHERE c.slug = 'capital_one_quicksilver'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CAPITAL ONE SAVORONE ──────────────────────────────────────────────────
-- 3% dining/entertainment/streaming/groceries, 10% Uber/Uber Eats

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'capital_one_savorone'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'entertainment', 3.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'capital_one_savorone'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 3.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'capital_one_savorone'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 3.00, 'cashback', NULL, NULL, 'Excluding superstores like Walmart and Target'
FROM card_ids c WHERE c.slug = 'capital_one_savorone'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'uber', 10.00, 'cashback', NULL, NULL, 'Uber & Uber Eats — verify current offer'
FROM card_ids c WHERE c.slug = 'capital_one_savorone'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'uber_eats', 10.00, 'cashback', NULL, NULL, 'Uber & Uber Eats — verify current offer'
FROM card_ids c WHERE c.slug = 'capital_one_savorone'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CAPITAL ONE SAVOR ─────────────────────────────────────────────────────
-- 4% dining/entertainment/streaming, 3% groceries

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 4.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'capital_one_savor'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'entertainment', 4.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'capital_one_savor'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 4.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'capital_one_savor'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 3.00, 'cashback', NULL, NULL, 'Excluding superstores like Walmart and Target'
FROM card_ids c WHERE c.slug = 'capital_one_savor'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CAPITAL ONE SPARK CASH PLUS ───────────────────────────────────────────
-- 2% flat on everything

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'cashback', NULL, NULL, 'Flat 2% on all purchases'
FROM card_ids c WHERE c.slug = 'capital_one_spark_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── DISCOVER IT CASH BACK ─────────────────────────────────────────────────
-- 5% rotating categories (cap $1,500/quarter), 1% on all else

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 5.00, 'cashback', 1500.00, 'quarterly', 'Rotating 5% category — verify current quarter at Discover.com'
FROM card_ids c WHERE c.slug = 'discover_it_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 5.00, 'cashback', 1500.00, 'quarterly', 'Rotating 5% category — verify current quarter at Discover.com'
FROM card_ids c WHERE c.slug = 'discover_it_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 5.00, 'cashback', 1500.00, 'quarterly', 'Common rotating 5% category — verify current quarter'
FROM card_ids c WHERE c.slug = 'discover_it_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_shopping', 5.00, 'cashback', 1500.00, 'quarterly', 'Common rotating 5% category — verify current quarter'
FROM card_ids c WHERE c.slug = 'discover_it_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'amazon', 5.00, 'cashback', 1500.00, 'quarterly', 'Common rotating 5% category — verify current quarter'
FROM card_ids c WHERE c.slug = 'discover_it_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── DISCOVER IT MILES ─────────────────────────────────────────────────────
-- 1.5x miles on everything (equivalent to 1.5% cashback)

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 1.50, 'cashback', NULL, NULL, '1.5x miles on all purchases'
FROM card_ids c WHERE c.slug = 'discover_it_miles'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── APPLE CARD ────────────────────────────────────────────────────────────
-- 3% Apple, 2% Apple Pay everywhere, 1% otherwise

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'apple', 3.00, 'cashback', NULL, NULL, 'Apple purchases — Apple Pay at Apple stores, apple.com, App Store'
FROM card_ids c WHERE c.slug = 'apple_card'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'cashback', NULL, NULL, 'When using Apple Pay'
FROM card_ids c WHERE c.slug = 'apple_card'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'cashback', NULL, NULL, '2% with Apple Pay; 1% without Apple Pay'
FROM card_ids c WHERE c.slug = 'apple_card'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── WELLS FARGO ACTIVE CASH ───────────────────────────────────────────────
-- 2% flat on everything

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'cashback', NULL, NULL, 'Flat 2% on all purchases'
FROM card_ids c WHERE c.slug = 'wells_fargo_active_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── WELLS FARGO AUTOGRAPH ─────────────────────────────────────────────────
-- 3x dining/travel/gas/transit/streaming/entertainment

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'entertainment', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── WELLS FARGO ATTUNE ────────────────────────────────────────────────────
-- 4% streaming, 4% transit (EV charging), 4% entertainment

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 4.00, 'cashback', NULL, NULL, 'Eligible streaming and digital subscriptions'
FROM card_ids c WHERE c.slug = 'wells_fargo_attune'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 4.00, 'cashback', NULL, NULL, 'Including EV charging stations'
FROM card_ids c WHERE c.slug = 'wells_fargo_attune'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'entertainment', 4.00, 'cashback', NULL, NULL, 'Select entertainment purchases'
FROM card_ids c WHERE c.slug = 'wells_fargo_attune'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── BANK OF AMERICA CUSTOMIZED CASH ──────────────────────────────────────
-- 3% chosen category (default: gas), 2% groceries/wholesale clubs (cap $2,500/quarter combined), 1% all else

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 3.00, 'cashback', NULL, NULL, 'User selects preferred 3% category; gas is default'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'cashback', NULL, NULL, 'If dining selected as preferred 3% category'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_shopping', 3.00, 'cashback', NULL, NULL, 'If online shopping selected as preferred 3% category'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 3.00, 'cashback', NULL, NULL, 'If travel selected as preferred 3% category'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'cashback', 2500.00, 'quarterly', 'Combined limit with wholesale clubs per quarter'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'wholesale_clubs', 2.00, 'cashback', 2500.00, 'quarterly', 'Combined limit with groceries per quarter'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── BANK OF AMERICA PREMIUM REWARDS ──────────────────────────────────────
-- 2% travel/dining, 1.5% on everything else

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 2.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'bofa_premium_rewards'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'bofa_premium_rewards'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 1.50, 'cashback', NULL, NULL, 'On all other purchases'
FROM card_ids c WHERE c.slug = 'bofa_premium_rewards'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── BANK OF AMERICA TRAVEL REWARDS ────────────────────────────────────────
-- 1.5x points on everything (1.5% travel redemption value)

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 1.50, 'cashback', NULL, NULL, '1.5x points on all purchases; redeemable for travel at 1cpp'
FROM card_ids c WHERE c.slug = 'bofa_travel_rewards'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── BANK OF AMERICA ALASKA AIRLINES VISA ─────────────────────────────────
-- 3x Alaska flights, 2x gas/EV charging, 1x all else

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Alaska Airlines purchases'
FROM card_ids c WHERE c.slug = 'bofa_alaska_airlines'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', NULL, NULL, 'At US gas stations and EV charging'
FROM card_ids c WHERE c.slug = 'bofa_alaska_airlines'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── US BANK ALTITUDE RESERVE ──────────────────────────────────────────────
-- 5x travel (mobile wallet), 3x dining (mobile wallet), 3x transit

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'multiplier', NULL, NULL, 'Mobile wallet travel purchases (Apple Pay, Google Pay, Samsung Pay)'
FROM card_ids c WHERE c.slug = 'usbank_altitude_reserve'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', NULL, NULL, 'Mobile wallet dining purchases'
FROM card_ids c WHERE c.slug = 'usbank_altitude_reserve'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'usbank_altitude_reserve'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── US BANK ALTITUDE GO ───────────────────────────────────────────────────
-- 4x dining, 2x streaming/groceries/gas

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 4.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'usbank_altitude_go'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'usbank_altitude_go'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'usbank_altitude_go'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'usbank_altitude_go'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── US BANK CASH+ ─────────────────────────────────────────────────────────
-- 5% on two chosen categories, 2% on one everyday category, 1% on all else

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 5.00, 'cashback', 2000.00, 'quarterly', 'User chooses 2 categories at 5% (up to $2,000/quarter combined); streaming is a common choice'
FROM card_ids c WHERE c.slug = 'usbank_cash_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'entertainment', 5.00, 'cashback', 2000.00, 'quarterly', 'User chooses 2 categories at 5% (up to $2,000/quarter combined)'
FROM card_ids c WHERE c.slug = 'usbank_cash_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'cashback', NULL, NULL, 'User chooses one everyday category at 2%'
FROM card_ids c WHERE c.slug = 'usbank_cash_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'cashback', NULL, NULL, 'User chooses one everyday category at 2%'
FROM card_ids c WHERE c.slug = 'usbank_cash_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── ROBINHOOD GOLD CARD ───────────────────────────────────────────────────
-- 3% on everything (requires Robinhood Gold subscription)

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 3.00, 'cashback', NULL, NULL, 'Flat 3% on all purchases; requires Robinhood Gold membership ($5/mo)'
FROM card_ids c WHERE c.slug = 'robinhood_gold_card'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── PAYPAL CASHBACK MASTERCARD ────────────────────────────────────────────
-- 2% flat on everything (via Synchrony)

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'cashback', NULL, NULL, 'Flat 2% on all purchases'
FROM card_ids c WHERE c.slug = 'paypal_cashback'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── SAM'S CLUB MASTERCARD ─────────────────────────────────────────────────
-- 5% Sam's Club (Plus members), 5% gas (cap $6k/yr), 3% dining

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'sams_club', 5.00, 'cashback', NULL, NULL, 'Sam''s Club and Sams.com (Plus members)'
FROM card_ids c WHERE c.slug = 'synchrony_sams_club'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 5.00, 'cashback', 6000.00, 'annual', 'At any gas station; then 1%'
FROM card_ids c WHERE c.slug = 'synchrony_sams_club'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'cashback', NULL, NULL, 'Dining and takeout'
FROM card_ids c WHERE c.slug = 'synchrony_sams_club'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── EBAY MASTERCARD ───────────────────────────────────────────────────────
-- 5% eBay, 1.5% on everything else

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ebay', 5.00, 'cashback', NULL, NULL, 'eBay purchases'
FROM card_ids c WHERE c.slug = 'ebay_mastercard'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 1.50, 'cashback', NULL, NULL, 'On all other purchases'
FROM card_ids c WHERE c.slug = 'ebay_mastercard'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CAR RENTAL RATES ──────────────────────────────────────────────────────
-- Capital One Venture X: 10x miles on car rentals via Capital One Travel
-- Capital One Venture: 5x miles on car rentals via Capital One Travel
-- Capital One VentureOne: 5x miles on car rentals via Capital One Travel

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 10.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_one'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 3.00, 'multiplier', NULL, NULL, 'Via Chase Travel portal'
FROM card_ids c WHERE c.slug = 'chase_sapphire_reserve'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 2.00, 'multiplier', NULL, NULL, 'Via Chase Travel portal'
FROM card_ids c WHERE c.slug = 'chase_sapphire_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── BARCLAYS JETBLUE PLUS ─────────────────────────────────────────────────
-- 6x JetBlue flights, 2x dining and groceries, 1x elsewhere

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'jetblue', 6.00, 'multiplier', NULL, NULL, 'Purchases with JetBlue'
FROM card_ids c WHERE c.slug = 'barclays_jetblue_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 6.00, 'multiplier', NULL, NULL, 'Directly with JetBlue'
FROM card_ids c WHERE c.slug = 'barclays_jetblue_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'barclays_jetblue_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'barclays_jetblue_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── BARCLAYS JETBLUE CARD ─────────────────────────────────────────────────
-- 3x JetBlue flights, 2x dining and groceries, 1x elsewhere

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'jetblue', 3.00, 'multiplier', NULL, NULL, 'Purchases with JetBlue'
FROM card_ids c WHERE c.slug = 'barclays_jetblue'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Directly with JetBlue'
FROM card_ids c WHERE c.slug = 'barclays_jetblue'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'barclays_jetblue'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'barclays_jetblue'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── BARCLAYS AADVANTAGE AVIATOR RED ───────────────────────────────────────
-- 2x American Airlines purchases, 1x elsewhere

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, 'Directly with American Airlines'
FROM card_ids c WHERE c.slug = 'barclays_aadvantage_aviator_red'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── BARCLAYS WYNDHAM REWARDS EARNER PLUS ──────────────────────────────────
-- 6x Wyndham hotels, 4x gas, 2x dining, 1x everywhere

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 6.00, 'multiplier', NULL, NULL, 'At Wyndham hotels'
FROM card_ids c WHERE c.slug = 'barclays_wyndham_rewards_earner_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 4.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'barclays_wyndham_rewards_earner_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'barclays_wyndham_rewards_earner_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE INK BUSINESS PREFERRED ──────────────────────────────────────────
-- 3x travel, dining, shipping, advertising, phone (combined $150k cap), 5x travel portal

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'multiplier', NULL, NULL, 'Via Chase Travel portal'
FROM card_ids c WHERE c.slug = 'chase_ink_business_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', 150000.00, 'annual', 'Direct bookings; $150k combined cap across bonus categories'
FROM card_ids c WHERE c.slug = 'chase_ink_business_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'multiplier', 150000.00, 'annual', 'Direct bookings; $150k combined cap across bonus categories'
FROM card_ids c WHERE c.slug = 'chase_ink_business_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', 150000.00, 'annual', '$150k combined cap across bonus categories'
FROM card_ids c WHERE c.slug = 'chase_ink_business_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE UNITED QUEST ────────────────────────────────────────────────────
-- 3x United, 2x dining/hotels, 1x elsewhere

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'united', 3.00, 'multiplier', NULL, NULL, 'United flights and purchases'
FROM card_ids c WHERE c.slug = 'chase_united_quest'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Directly with United'
FROM card_ids c WHERE c.slug = 'chase_united_quest'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_quest'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_quest'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE UNITED GATEWAY ──────────────────────────────────────────────────
-- 2x United, 2x gas stations, 2x local transit

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'united', 2.00, 'multiplier', NULL, NULL, 'United flights and purchases'
FROM card_ids c WHERE c.slug = 'chase_united_gateway'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, 'Directly with United'
FROM card_ids c WHERE c.slug = 'chase_united_gateway'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_gateway'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_gateway'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE UNITED BUSINESS ─────────────────────────────────────────────────
-- 2x United, 2x dining/gas/transit, 1x elsewhere

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'united', 2.00, 'multiplier', NULL, NULL, 'United flights and purchases'
FROM card_ids c WHERE c.slug = 'chase_united_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, 'Directly with United'
FROM card_ids c WHERE c.slug = 'chase_united_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_united_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE IHG ONE REWARDS PREMIER ─────────────────────────────────────────
-- 10x IHG, 5x dining/gas, 3x all other

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ihg', 10.00, 'multiplier', NULL, NULL, 'At IHG Hotels & Resorts'
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 10.00, 'multiplier', NULL, NULL, 'At IHG Hotels & Resorts'
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 5.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 5.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 3.00, 'multiplier', NULL, NULL, 'On all other purchases'
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_premier'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE IHG ONE REWARDS TRAVELER ────────────────────────────────────────
-- 5x IHG, 3x dining/gas

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ihg', 5.00, 'multiplier', NULL, NULL, 'At IHG Hotels & Resorts'
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_traveler'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'multiplier', NULL, NULL, 'At IHG Hotels & Resorts'
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_traveler'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_traveler'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_traveler'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE MARRIOTT BONVOY BOLD ────────────────────────────────────────────
-- 3x Marriott, 2x travel, 1x elsewhere

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'marriott', 3.00, 'multiplier', NULL, NULL, 'At Marriott Bonvoy hotels'
FROM card_ids c WHERE c.slug = 'chase_marriott_bold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'multiplier', NULL, NULL, 'At Marriott Bonvoy hotels'
FROM card_ids c WHERE c.slug = 'chase_marriott_bold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_marriott_bold'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE AEROPLAN ────────────────────────────────────────────────────────
-- 3x Air Canada/flights, 3x dining, 3x groceries

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Air Canada and Star Alliance flights'
FROM card_ids c WHERE c.slug = 'chase_aeroplan'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_aeroplan'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_aeroplan'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CHASE BRITISH AIRWAYS VISA ────────────────────────────────────────────
-- 3x British Airways/partner flights, 2x hotels, 1x elsewhere

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'British Airways, Iberia, Aer Lingus, Finnair'
FROM card_ids c WHERE c.slug = 'chase_british_airways'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'chase_british_airways'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX EVERYDAY ─────────────────────────────────────────────────────────
-- 2x US supermarkets (up to $6k/year), 1x everywhere

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'multiplier', 6000.00, 'annual', 'At US supermarkets; then 1x'
FROM card_ids c WHERE c.slug = 'amex_everyday'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX EVERYDAY PREFERRED ───────────────────────────────────────────────
-- 3x US supermarkets (up to $6k/year), 2x US gas stations

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 3.00, 'multiplier', 6000.00, 'annual', 'At US supermarkets; then 1x'
FROM card_ids c WHERE c.slug = 'amex_everyday_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', NULL, NULL, 'At US gas stations'
FROM card_ids c WHERE c.slug = 'amex_everyday_preferred'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX CASH MAGNET ──────────────────────────────────────────────────────
-- 1.5% on everything

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 1.50, 'cashback', NULL, NULL, 'On all purchases'
FROM card_ids c WHERE c.slug = 'amex_cash_magnet'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX BLUE BUSINESS CASH ───────────────────────────────────────────────
-- 2% on all purchases (up to $50k/year), then 1%

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'cashback', 50000.00, 'annual', 'On all purchases up to $50k/year; then 1%'
FROM card_ids c WHERE c.slug = 'amex_blue_business_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX BLUE BUSINESS PLUS ───────────────────────────────────────────────
-- 2x MR on all purchases (up to $50k/year), then 1x

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'multiplier', 50000.00, 'annual', 'On all purchases up to $50k/year; then 1x'
FROM card_ids c WHERE c.slug = 'amex_blue_business_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX MARRIOTT BONVOY BUSINESS ─────────────────────────────────────────
-- 6x Marriott, 4x dining/gas, 2x everything

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'marriott', 6.00, 'multiplier', NULL, NULL, 'At Marriott Bonvoy hotels'
FROM card_ids c WHERE c.slug = 'amex_marriott_bonvoy_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 6.00, 'multiplier', NULL, NULL, 'At Marriott Bonvoy hotels'
FROM card_ids c WHERE c.slug = 'amex_marriott_bonvoy_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 4.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_marriott_bonvoy_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 4.00, 'multiplier', NULL, NULL, 'At US gas stations'
FROM card_ids c WHERE c.slug = 'amex_marriott_bonvoy_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'multiplier', NULL, NULL, 'On all other purchases'
FROM card_ids c WHERE c.slug = 'amex_marriott_bonvoy_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX HILTON HONORS BUSINESS ───────────────────────────────────────────
-- 12x Hilton, 6x dining/gas/phone, 3x everything

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hilton', 12.00, 'multiplier', NULL, NULL, 'At Hilton hotels'
FROM card_ids c WHERE c.slug = 'amex_hilton_honors_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 12.00, 'multiplier', NULL, NULL, 'At Hilton hotels'
FROM card_ids c WHERE c.slug = 'amex_hilton_honors_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 6.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_hilton_honors_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 6.00, 'multiplier', NULL, NULL, 'At US gas stations'
FROM card_ids c WHERE c.slug = 'amex_hilton_honors_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 3.00, 'multiplier', NULL, NULL, 'On all other purchases'
FROM card_ids c WHERE c.slug = 'amex_hilton_honors_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX DELTA GOLD BUSINESS ──────────────────────────────────────────────
-- 2x Delta, 2x dining, 2x gas, 1x elsewhere

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'delta', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_gold_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, 'Directly with Delta'
FROM card_ids c WHERE c.slug = 'amex_delta_gold_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_gold_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', NULL, NULL, 'At US gas stations'
FROM card_ids c WHERE c.slug = 'amex_delta_gold_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── AMEX DELTA PLATINUM BUSINESS ──────────────────────────────────────────
-- 3x Delta, 1.5x all other

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'delta', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'amex_delta_platinum_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Directly with Delta'
FROM card_ids c WHERE c.slug = 'amex_delta_platinum_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 1.50, 'multiplier', NULL, NULL, 'On all other purchases'
FROM card_ids c WHERE c.slug = 'amex_delta_platinum_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CITI AADVANTAGE PLATINUM SELECT ───────────────────────────────────────
-- 2x AA flights, 2x dining, 2x hotels, 2x gas

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, 'American Airlines purchases'
FROM card_ids c WHERE c.slug = 'citi_aadvantage_platinum_select'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'citi_aadvantage_platinum_select'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'citi_aadvantage_platinum_select'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', NULL, NULL, 'At gas stations'
FROM card_ids c WHERE c.slug = 'citi_aadvantage_platinum_select'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CITI AADVANTAGE EXECUTIVE ─────────────────────────────────────────────
-- 4x AA flights, 1x everywhere (value is the Admirals Club lounge access)

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 4.00, 'multiplier', NULL, NULL, 'American Airlines purchases'
FROM card_ids c WHERE c.slug = 'citi_aadvantage_executive'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CITI AADVANTAGE MILEUP ────────────────────────────────────────────────
-- 2x AA flights, 2x groceries

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, 'American Airlines purchases'
FROM card_ids c WHERE c.slug = 'citi_aadvantage_mileup'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'citi_aadvantage_mileup'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CAPITAL ONE VENTURE X BUSINESS ────────────────────────────────────────
-- 10x hotels/car rentals via C1 Travel, 5x flights via C1 Travel, 2x everywhere

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 10.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 10.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'multiplier', NULL, NULL, 'On all other purchases'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CAPITAL ONE SPARK MILES ───────────────────────────────────────────────
-- 5x hotels/car rentals via C1 Travel, 2x everywhere

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_spark_miles'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_spark_miles'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'multiplier', NULL, NULL, 'On all other purchases'
FROM card_ids c WHERE c.slug = 'capital_one_spark_miles'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── CAPITAL ONE SPARK MILES SELECT ────────────────────────────────────────
-- 5x hotels/car rentals via C1 Travel, 1.5x everywhere

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_spark_miles_select'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_spark_miles_select'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 1.50, 'multiplier', NULL, NULL, 'On all other purchases'
FROM card_ids c WHERE c.slug = 'capital_one_spark_miles_select'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── WELLS FARGO AUTOGRAPH JOURNEY ─────────────────────────────────────────
-- 5x hotels, 4x airlines, 3x other travel, 1x everything

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph_journey'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 4.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph_journey'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 3.00, 'cashback', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph_journey'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── BANK OF AMERICA ALASKA AIRLINES BUSINESS ──────────────────────────────
-- 3x Alaska Airlines, 1x everything

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Alaska Airlines purchases'
FROM card_ids c WHERE c.slug = 'bofa_alaska_airlines_business'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── BILT MASTERCARD ───────────────────────────────────────────────────────
-- 3x dining, 2x travel, 1x rent (up to 100k pts/year), 1x everything

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'bilt_mastercard'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'bilt_mastercard'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'bilt_mastercard'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, NULL
FROM card_ids c WHERE c.slug = 'bilt_mastercard'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'rent', 1.00, 'multiplier', NULL, NULL, 'Via Bilt app on rent day (1st of month); no fee to pay rent'
FROM card_ids c WHERE c.slug = 'bilt_mastercard'
ON CONFLICT (card_id, category_slug) DO NOTHING;
