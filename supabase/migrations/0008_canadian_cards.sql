-- Migration: Add first Canadian cards — American Express Cobalt and TD Aeroplan Visa Infinite
-- Rates verified September 2026 (Amex Canada / TD product pages via press and review coverage).
-- Both cards charge 2.5% on non-CAD purchases. Bonus multipliers apply to purchases in Canada.

-- ── TD BANK ────────────────────────────────────────────────────────────────

INSERT INTO banks (slug, display_name, brand_color, sort_order) VALUES
  ('td', 'TD', '#54B848', 19)
ON CONFLICT (slug) DO NOTHING;

-- ── AMERICAN EXPRESS COBALT (CANADA) ───────────────────────────────────────
-- $15.99/month ($191.88/yr). Membership Rewards (Canada): ~1.0¢ statement credit,
-- ~1.5¢ typical economy/Aeroplan transfer, ~2.2¢ premium-cabin transfers.

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee, foreign_transaction_fee)
SELECT b.id, 'amex_cobalt', 'Cobalt Card', 'American Express Cobalt® Card (Canada)',
  false, 'MR', 1.00, 1.50, 2.20, 191.88, 2.50
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

-- 5x eats & drinks (restaurants, grocery, food delivery) — combined $2,500/month cap, then 1x
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 5.00, 'multiplier', 2500.00, 'monthly', 'Restaurants, cafés, bars & food delivery in Canada; shares $2,500/mo cap with groceries, then 1x'
FROM card_ids c WHERE c.slug = 'amex_cobalt'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 5.00, 'multiplier', 2500.00, 'monthly', 'Stand-alone grocery stores in Canada (not Walmart/Costco); shares $2,500/mo cap with dining, then 1x'
FROM card_ids c WHERE c.slug = 'amex_cobalt'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'uber_eats', 5.00, 'multiplier', 2500.00, 'monthly', 'Food delivery in Canada; counts toward the $2,500/mo eats & drinks cap'
FROM card_ids c WHERE c.slug = 'amex_cobalt'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- 3x streaming
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 3.00, 'multiplier', NULL, NULL, 'Eligible streaming subscriptions in Canada (Netflix, Spotify, Disney+, Crave, etc.)'
FROM card_ids c WHERE c.slug = 'amex_cobalt'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- 2x gas, transit & ride share, travel
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', NULL, NULL, 'Stand-alone gas stations in Canada'
FROM card_ids c WHERE c.slug = 'amex_cobalt'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'multiplier', NULL, NULL, 'Public transit, taxi & ride share in Canada'
FROM card_ids c WHERE c.slug = 'amex_cobalt'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'uber', 2.00, 'multiplier', NULL, NULL, 'Ride share in Canada'
FROM card_ids c WHERE c.slug = 'amex_cobalt'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 2.00, 'multiplier', NULL, NULL, 'Air, water, rail & road transport, lodging and tour operators'
FROM card_ids c WHERE c.slug = 'amex_cobalt'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, 'Air, water, rail & road transport, lodging and tour operators'
FROM card_ids c WHERE c.slug = 'amex_cobalt'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, 'Air, water, rail & road transport, lodging and tour operators'
FROM card_ids c WHERE c.slug = 'amex_cobalt'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- Brand tiles: Uber Eats (5x food delivery) and Uber (2x ride share)
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'uber_eats'   FROM card_ids c WHERE c.slug = 'amex_cobalt'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'uber'        FROM card_ids c WHERE c.slug = 'amex_cobalt'
ON CONFLICT DO NOTHING;

-- ── TD AEROPLAN VISA INFINITE ──────────────────────────────────────────────
-- $139/yr. 1.5x gas, EV charging, groceries and purchases made directly with Air Canada; 1x elsewhere.
-- (Not the Visa Infinite Privilege, which is $599 with 2x Air Canada / 1.25x base.)

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee, foreign_transaction_fee)
SELECT b.id, 'td_aeroplan_visa_infinite', 'Aeroplan Visa Infinite', 'TD® Aeroplan® Visa Infinite* Card',
  false, 'Aeroplan', 1.20, 1.50, 2.00, 139.00, 2.50
FROM bank_ids b WHERE b.slug = 'td'
ON CONFLICT (slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 1.50, 'multiplier', NULL, NULL, 'Gas stations'
FROM card_ids c WHERE c.slug = 'td_aeroplan_visa_infinite'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ev_charging', 1.50, 'multiplier', NULL, NULL, 'Electric vehicle charging'
FROM card_ids c WHERE c.slug = 'td_aeroplan_visa_infinite'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 1.50, 'multiplier', NULL, NULL, 'Grocery stores'
FROM card_ids c WHERE c.slug = 'td_aeroplan_visa_infinite'
ON CONFLICT (card_id, category_slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 1.50, 'multiplier', NULL, NULL, 'Purchases made directly with Air Canada, incl. Air Canada Vacations'
FROM card_ids c WHERE c.slug = 'td_aeroplan_visa_infinite'
ON CONFLICT (card_id, category_slug) DO NOTHING;
