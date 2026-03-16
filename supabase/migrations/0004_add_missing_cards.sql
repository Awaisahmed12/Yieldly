-- Migration: Add Fidelity bank + card, and Wells Fargo Signify Business Cash

-- ── FIDELITY BANK ──────────────────────────────────────────────────────────

INSERT INTO banks (slug, display_name, brand_color, sort_order) VALUES
  ('fidelity', 'Fidelity', '#006B3E', 18)
ON CONFLICT (slug) DO NOTHING;

-- Fidelity® Rewards Visa Signature® Card — 2% cash back on all purchases
WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee, foreign_transaction_fee)
SELECT b.id, 'fidelity_rewards_visa', 'Rewards Visa', 'Fidelity® Rewards Visa Signature® Card',
  false, 'CB', 1.00, 1.00, 1.00, 0.00, 0.00
FROM bank_ids b WHERE b.slug = 'fidelity'
ON CONFLICT (slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'cashback', NULL, NULL, '2% cash back on all purchases'
FROM card_ids c WHERE c.slug = 'fidelity_rewards_visa'
ON CONFLICT (card_id, category_slug) DO NOTHING;

-- ── WELLS FARGO SIGNIFY BUSINESS CASH ─────────────────────────────────────

-- Wells Fargo Signify Business Cash℠ — 2% cash back on all purchases, 3% FTF
WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee, foreign_transaction_fee)
SELECT b.id, 'wells_fargo_signify_business_cash', 'Signify Business Cash', 'Wells Fargo Signify Business Cash℠ Card',
  true, 'CB', 1.00, 1.00, 1.00, 0.00, 3.00
FROM bank_ids b WHERE b.slug = 'wells_fargo'
ON CONFLICT (slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'cashback', NULL, NULL, '2% cash back on all purchases'
FROM card_ids c WHERE c.slug = 'wells_fargo_signify_business_cash'
ON CONFLICT (card_id, category_slug) DO NOTHING;
