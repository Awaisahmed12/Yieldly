-- Migration: Add reward rates for beauty, utilities, fitness, and ev_charging categories

-- ── BEAUTY ──────────────────────────────────────────────────────────────────
-- Wells Fargo Attune: 4% on personal care (hair salons, spas, nail salons)
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'beauty', 4.00, 'cashback', NULL, NULL, 'Personal care including hair salons, spas, and nail salons'
FROM card_ids c WHERE c.slug = 'wells_fargo_attune'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── UTILITIES ────────────────────────────────────────────────────────────────
-- US Bank Cash+: 5% on home utilities (chooseable 5% category, up to $2,000/quarter combined)
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'utilities', 5.00, 'cashback', 2000.00, 'quarterly', 'Choose home utilities as one of two 5% categories (up to $2,000/quarter combined)'
FROM card_ids c WHERE c.slug = 'usbank_cash_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- Chase Ink Business Cash: 5% on internet, cable, and phone services (up to $25,000/year)
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'utilities', 5.00, 'cashback', 25000.00, 'annual', 'Internet, cable, and phone services'
FROM card_ids c WHERE c.slug = 'chase_ink_business_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- Wells Fargo Autograph: 3x on phone plans
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'utilities', 3.00, 'multiplier', NULL, NULL, 'Phone plans'
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── FITNESS ──────────────────────────────────────────────────────────────────
-- Wells Fargo Attune: 4% on gym memberships and fitness clubs
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'fitness', 4.00, 'cashback', NULL, NULL, 'Gym memberships and fitness clubs'
FROM card_ids c WHERE c.slug = 'wells_fargo_attune'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- US Bank Cash+: 5% on gyms/fitness clubs (chooseable 5% category, up to $2,000/quarter combined)
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'fitness', 5.00, 'cashback', 2000.00, 'quarterly', 'Choose gyms/fitness clubs as one of two 5% categories (up to $2,000/quarter combined)'
FROM card_ids c WHERE c.slug = 'usbank_cash_plus'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- Citi Custom Cash: 5% on fitness clubs (top spend category, up to $500/month)
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'fitness', 5.00, 'cashback', 500.00, 'monthly', '5% on top eligible spend category each billing cycle (up to $500/mo)'
FROM card_ids c WHERE c.slug = 'citi_custom_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── EV CHARGING ──────────────────────────────────────────────────────────────
-- Wells Fargo Attune: 4% on EV charging stations
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ev_charging', 4.00, 'cashback', NULL, NULL, 'EV charging stations'
FROM card_ids c WHERE c.slug = 'wells_fargo_attune'
ON CONFLICT (card_id, category_slug) DO NOTHING;
