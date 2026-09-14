-- Migration: Reward-data audit, second verification pass (September 2026)
-- Every change below was verified against 2026 issuer terms; see docs/data-audit-2026-09.md
-- for the finding, confidence and sources behind each row.

-- ── AMERICAN EXPRESS ──────────────────────────────────────────────────────────

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 3.00, 'multiplier', NULL, NULL, 'All travel incl. airfare, hotels, car rentals, cruises, tours, vacation rentals, third-party sites and Amex Travel'
FROM card_ids c WHERE c.slug = 'amex_green'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Airfare booked anywhere (airline direct, OTA or Amex Travel)'
FROM card_ids c WHERE c.slug = 'amex_green'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'multiplier', NULL, NULL, 'Hotels booked direct or through any travel site'
FROM card_ids c WHERE c.slug = 'amex_green'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 3.00, 'multiplier', NULL, NULL, 'Car rentals booked direct or through any travel site'
FROM card_ids c WHERE c.slug = 'amex_green'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'utilities', 4.00, 'multiplier', 150000.00, 'annual', 'Wireless phone service from US providers only; 4x in your top 2 categories each month, up to $150,000/yr combined'
FROM card_ids c WHERE c.slug = 'amex_business_gold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'utilities', 4.00, 'multiplier', NULL, NULL, 'Wireless phone service purchased directly from US providers only'
FROM card_ids c WHERE c.slug = 'amex_marriott_bonvoy_business'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 2.00, 'multiplier', NULL, NULL, 'Online orders from US supermarkets (incl. Instacart); Amazon, Walmart, Target & warehouse clubs excluded'
FROM card_ids c WHERE c.slug = 'amex_delta_gold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 2.00, 'multiplier', NULL, NULL, 'Online orders from US supermarkets (incl. Instacart); Amazon, Walmart, Target & warehouse clubs excluded'
FROM card_ids c WHERE c.slug = 'amex_delta_platinum'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 5.00, 'multiplier', NULL, NULL, 'Online orders from US supermarkets (incl. Instacart); Amazon, Walmart, Target & warehouse clubs excluded'
FROM card_ids c WHERE c.slug = 'amex_hilton_honors'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 6.00, 'multiplier', NULL, NULL, 'Online orders from US supermarkets (incl. Instacart); Amazon, Walmart, Target & warehouse clubs excluded'
FROM card_ids c WHERE c.slug = 'amex_hilton_surpass'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

-- ── CHASE ─────────────────────────────────────────────────────────────────────

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 3.00, 'multiplier', NULL, NULL, 'All travel (Sept 2026 refresh)'
FROM card_ids c WHERE c.slug = 'chase_aeroplan'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'multiplier', NULL, NULL, 'All travel (Sept 2026 refresh)'
FROM card_ids c WHERE c.slug = 'chase_aeroplan'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 3.00, 'multiplier', NULL, NULL, 'All travel (Sept 2026 refresh)'
FROM card_ids c WHERE c.slug = 'chase_aeroplan'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 3.00, 'multiplier', NULL, NULL, 'Taxis, rideshare, trains, tolls & parking (travel category)'
FROM card_ids c WHERE c.slug = 'chase_aeroplan'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'All airlines (3x travel); Air Canada purchases earn up to 5x total with the automatic Aeroplan 25K status'
FROM card_ids c WHERE c.slug = 'chase_aeroplan'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', 8000.00, 'annual', 'First $8,000 combined gas + restaurants per year, then 1x'
FROM card_ids c WHERE c.slug = 'chase_southwest_priority'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', 8000.00, 'annual', 'First $8,000 combined gas + restaurants per year, then 1x'
FROM card_ids c WHERE c.slug = 'chase_southwest_priority'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'utilities', 5.00, 'cashback', 25000.00, 'annual', 'Internet, cable & phone services; $25,000/yr cap shared with office supply stores, then 1%'
FROM card_ids c WHERE c.slug = 'chase_ink_business_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET full_name = 'United Club℠ Card' WHERE slug = 'chase_united_club_infinite';

-- ── CAPITAL ONE AND CITI ──────────────────────────────────────────────────────

UPDATE cards SET foreign_transaction_fee = 0.00 WHERE slug = 'citi_costco';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 12.00, 'multiplier', NULL, NULL, 'Via aa.com AAdvantage Hotels only; 1x booked direct'
FROM card_ids c WHERE c.slug = 'citi_aadvantage_executive'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 12.00, 'multiplier', NULL, NULL, 'Via aa.com AAdvantage Cars only; 1x booked direct'
FROM card_ids c WHERE c.slug = 'citi_aadvantage_executive'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 5.00, 'cashback', 500.00, 'monthly', 'Select travel (airlines, hotels, cruise lines, travel agencies); 5% on top eligible spend category each billing cycle (up to $500/mo)'
FROM card_ids c WHERE c.slug = 'citi_custom_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'cashback', 500.00, 'monthly', 'Select travel (airlines, hotels, cruise lines, travel agencies); 5% on top eligible spend category each billing cycle (up to $500/mo)'
FROM card_ids c WHERE c.slug = 'citi_custom_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 5.00, 'cashback', 500.00, 'monthly', 'Select transit incl. car rentals, taxis, tolls & parking; 5% on top eligible spend category each billing cycle (up to $500/mo)'
FROM card_ids c WHERE c.slug = 'citi_custom_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 10.00, 'multiplier', NULL, NULL, 'Hotels & rental cars via Capital One Business Travel portal (flights & vacation rentals 5x)'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x_business'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 10.00, 'multiplier', NULL, NULL, 'Via Capital One Business Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x_business'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 10.00, 'multiplier', NULL, NULL, 'Via Capital One Business Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x_business'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 5.00, 'multiplier', NULL, NULL, 'Via Capital One Business Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x_business'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'multiplier', NULL, NULL, 'Hotels, vacation rentals & rental cars via Capital One Business Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_spark_miles_select'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

-- ── WELLS FARGO, BANK OF AMERICA, US BANK ─────────────────────────────────────

UPDATE cards SET foreign_transaction_fee = 3.00 WHERE slug = 'usbank_altitude_go';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ev_charging', 3.00, 'multiplier', NULL, NULL, 'Gas stations incl. EV charging stations'
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'utilities', 3.00, 'cashback', 2500.00, 'quarterly', 'If online shopping is your 3% choice category: cable, internet & phone bills paid online (electric/gas/water earn 1%); $2,500/quarter combined cap, then 1%'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'usbank_altitude_reserve')
  AND category_slug = 'dining';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'entertainment', 5.00, 'cashback', 2000.00, 'quarterly', 'Movie theaters is a 5% choice category (up to $2,000/quarter combined across both 5% picks); live events are not eligible'
FROM card_ids c WHERE c.slug = 'usbank_cash_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

-- ── BILT, BARCLAYS, SYNCHRONY, ROBINHOOD, APPLE, FIDELITY ─────────────────────

UPDATE cards SET foreign_transaction_fee = 3.00 WHERE slug = 'robinhood_gold_card';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 3.00, 'cashback', NULL, NULL, 'Flat 3% on all purchases; requires Robinhood Gold ($5/mo or $50/yr). Full 3% only when redeemed into a Robinhood brokerage account. 3% foreign fee on accounts opened from July 2026'
FROM card_ids c WHERE c.slug = 'robinhood_gold_card'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 4.00, 'multiplier', NULL, NULL, 'Travel: airfare, car rentals, rideshare, tolls, trains, gas, EV charging. Hotels are not included (Wyndham stays 6x, other hotels 1x)'
FROM card_ids c WHERE c.slug = 'barclays_wyndham_rewards_earner_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 6.00, 'multiplier', NULL, NULL, 'Wyndham stays only (incl. Wyndham Travel bundles); other hotels 1x'
FROM card_ids c WHERE c.slug = 'barclays_wyndham_rewards_earner_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'rent', 1.25, 'multiplier', NULL, NULL, 'Fee-free rent/mortgage paid through Bilt (ACH, not charged to the card). 1.25x needs everyday card spend of at least your housing payment, 1x at 75%, less below; min 250 pts/mo'
FROM card_ids c WHERE c.slug = 'bilt_blue'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'sams_club', 3.00, 'cashback', NULL, NULL, 'Plus members: 3% from the card in-club and on SamsClub.com (+2% Plus-membership Sam''s Cash on in-club purchases only = 5% in-club); Club members 1%'
FROM card_ids c WHERE c.slug = 'synchrony_sams_club'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'apple', 3.00, 'cashback', NULL, NULL, 'Apple purchases (Apple Store, apple.com, App Store, Apple services) — 3% with Apple Card in any form'
FROM card_ids c WHERE c.slug = 'apple_card'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'cashback', NULL, NULL, '2% cash back on all purchases when deposited into an eligible Fidelity account; other redemptions are worth less'
FROM card_ids c WHERE c.slug = 'fidelity_rewards_visa'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;
