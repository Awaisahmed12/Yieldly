-- Migration: Reward-data audit corrections (September 2026)
-- Every change below was verified against 2026 issuer terms; see docs/data-audit-2026-09.md
-- for the finding, confidence and sources behind each row.

-- ── CHASE ─────────────────────────────────────────────────────────────────────

UPDATE cards SET foreign_transaction_fee = 0.00 WHERE slug = 'chase_freedom_flex';

UPDATE cards SET annual_fee = 795.00 WHERE slug = 'chase_sapphire_reserve';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 8.00, 'multiplier', NULL, NULL, 'Via Chase Travel portal (incl. The Edit)'
FROM card_ids c WHERE c.slug = 'chase_sapphire_reserve'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 4.00, 'multiplier', NULL, NULL, 'Booked directly with the airline; 8x through Chase Travel'
FROM card_ids c WHERE c.slug = 'chase_sapphire_reserve'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 4.00, 'multiplier', NULL, NULL, 'Booked directly with the hotel; 8x through Chase Travel'
FROM card_ids c WHERE c.slug = 'chase_sapphire_reserve'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_sapphire_reserve')
  AND category_slug = 'transit';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 8.00, 'multiplier', NULL, NULL, 'Via Chase Travel portal only; rentals booked directly earn 1x'
FROM card_ids c WHERE c.slug = 'chase_sapphire_reserve'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET full_name = 'Prime Visa' WHERE slug = 'chase_amazon_prime_visa';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'cashback', NULL, NULL, 'Via Chase Travel portal (requires Prime)'
FROM card_ids c WHERE c.slug = 'chase_amazon_prime_visa'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET annual_fee = 150.00 WHERE slug = 'chase_united_explorer';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'united', 3.00, 'multiplier', NULL, NULL, 'United purchases'
FROM card_ids c WHERE c.slug = 'chase_united_explorer'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_united_explorer')
  AND category_slug = 'flights';

UPDATE cards SET annual_fee = 695.00 WHERE slug = 'chase_united_club_infinite';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'united', 5.00, 'multiplier', NULL, NULL, 'United purchases'
FROM card_ids c WHERE c.slug = 'chase_united_club_infinite'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 2.00, 'multiplier', NULL, NULL, 'All other travel'
FROM card_ids c WHERE c.slug = 'chase_united_club_infinite'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 2.00, 'multiplier', NULL, NULL, 'All other travel'
FROM card_ids c WHERE c.slug = 'chase_united_club_infinite'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET annual_fee = 350.00 WHERE slug = 'chase_united_quest';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'united', 4.00, 'multiplier', NULL, NULL, 'United purchases'
FROM card_ids c WHERE c.slug = 'chase_united_quest'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, 'Other airlines; United purchases earn 4x'
FROM card_ids c WHERE c.slug = 'chase_united_quest'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 2.00, 'multiplier', NULL, NULL, 'Select streaming services'
FROM card_ids c WHERE c.slug = 'chase_united_quest'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 2.00, 'multiplier', NULL, NULL, 'All other travel'
FROM card_ids c WHERE c.slug = 'chase_united_quest'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'multiplier', NULL, NULL, 'Taxis, trains, tolls & parking (travel category)'
FROM card_ids c WHERE c.slug = 'chase_united_quest'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 2.00, 'multiplier', NULL, NULL, 'All other travel'
FROM card_ids c WHERE c.slug = 'chase_united_quest'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_united_gateway')
  AND category_slug = 'flights';

UPDATE cards SET annual_fee = 150.00 WHERE slug = 'chase_united_business';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_united_business')
  AND category_slug = 'flights';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', 6000.00, 'annual', '3x on first $6,000 combined gas/grocery/dining per year, then 2x'
FROM card_ids c WHERE c.slug = 'chase_marriott_boundless'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 3.00, 'multiplier', 6000.00, 'annual', '3x on first $6,000 combined gas/grocery/dining per year, then 2x'
FROM card_ids c WHERE c.slug = 'chase_marriott_boundless'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 3.00, 'multiplier', 6000.00, 'annual', '3x on first $6,000 combined gas/grocery/dining per year, then 2x'
FROM card_ids c WHERE c.slug = 'chase_marriott_boundless'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'multiplier', NULL, NULL, 'Base rate on all other purchases'
FROM card_ids c WHERE c.slug = 'chase_marriott_boundless'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_marriott_boundless')
  AND category_slug = 'hotels';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_marriott_bold')
  AND category_slug = 'travel';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_marriott_bold')
  AND category_slug = 'hotels';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'multiplier', NULL, NULL, 'Grocery stores'
FROM card_ids c WHERE c.slug = 'chase_marriott_bold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 2.00, 'multiplier', NULL, NULL, 'Select streaming services'
FROM card_ids c WHERE c.slug = 'chase_marriott_bold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'utilities', 2.00, 'multiplier', NULL, NULL, 'Internet, cable and phone services'
FROM card_ids c WHERE c.slug = 'chase_marriott_bold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'multiplier', NULL, NULL, 'Ride-hailing (Uber/Lyft) only; other transit 1x'
FROM card_ids c WHERE c.slug = 'chase_marriott_bold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_hyatt')
  AND category_slug = 'hotels';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'fitness', 2.00, 'multiplier', NULL, NULL, 'Fitness club and gym memberships'
FROM card_ids c WHERE c.slug = 'chase_hyatt'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'multiplier', NULL, NULL, 'Local transit and commuting'
FROM card_ids c WHERE c.slug = 'chase_hyatt'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET annual_fee = 99.00 WHERE slug = 'chase_southwest_plus';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'southwest', 2.00, 'multiplier', NULL, NULL, 'Southwest purchases'
FROM card_ids c WHERE c.slug = 'chase_southwest_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_southwest_plus')
  AND category_slug = 'dining';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_southwest_plus')
  AND category_slug = 'flights';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_southwest_plus')
  AND category_slug = 'hotels';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_southwest_plus')
  AND category_slug = 'transit';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', 5000.00, 'annual', 'First $5,000 combined gas + grocery per year, then 1x'
FROM card_ids c WHERE c.slug = 'chase_southwest_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'multiplier', 5000.00, 'annual', 'First $5,000 combined gas + grocery per year, then 1x'
FROM card_ids c WHERE c.slug = 'chase_southwest_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET annual_fee = 149.00 WHERE slug = 'chase_southwest_premier';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'multiplier', 8000.00, 'annual', 'First $8,000 combined grocery + restaurants per year, then 1x'
FROM card_ids c WHERE c.slug = 'chase_southwest_premier'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'multiplier', 8000.00, 'annual', 'First $8,000 combined grocery + restaurants per year, then 1x'
FROM card_ids c WHERE c.slug = 'chase_southwest_premier'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_southwest_premier')
  AND category_slug = 'flights';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_southwest_premier')
  AND category_slug = 'hotels';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_southwest_premier')
  AND category_slug = 'transit';

UPDATE cards SET annual_fee = 229.00 WHERE slug = 'chase_southwest_priority';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'southwest', 4.00, 'multiplier', NULL, NULL, 'Southwest purchases'
FROM card_ids c WHERE c.slug = 'chase_southwest_priority'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', NULL, NULL, 'Gas stations'
FROM card_ids c WHERE c.slug = 'chase_southwest_priority'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_southwest_priority')
  AND category_slug = 'flights';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_southwest_priority')
  AND category_slug = 'hotels';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_southwest_priority')
  AND category_slug = 'transit';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_ink_business_cash')
  AND category_slug = 'online_shopping';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'cashback', 25000.00, 'annual', 'First $25,000 combined gas + restaurants per year, then 1%'
FROM card_ids c WHERE c.slug = 'chase_ink_business_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'cashback', 25000.00, 'annual', 'First $25,000 combined gas + restaurants per year, then 1%'
FROM card_ids c WHERE c.slug = 'chase_ink_business_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 3.00, 'multiplier', 150000.00, 'annual', 'All travel incl. Chase Travel; $150,000/yr combined cap across bonus categories'
FROM card_ids c WHERE c.slug = 'chase_ink_business_preferred'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_ink_business_preferred')
  AND category_slug = 'dining';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'utilities', 3.00, 'multiplier', 150000.00, 'annual', 'Internet, cable and phone services; $150,000/yr combined cap'
FROM card_ids c WHERE c.slug = 'chase_ink_business_preferred'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 3.00, 'multiplier', 150000.00, 'annual', 'Taxis, trains, tolls & parking (travel category); $150,000/yr combined cap'
FROM card_ids c WHERE c.slug = 'chase_ink_business_preferred'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 3.00, 'multiplier', 150000.00, 'annual', 'Travel category; $150,000/yr combined cap'
FROM card_ids c WHERE c.slug = 'chase_ink_business_preferred'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'multiplier', NULL, NULL, 'Non-IHG hotels (travel); IHG stays earn 10x'
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_premier'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'multiplier', NULL, NULL, 'All travel'
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_premier'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 5.00, 'multiplier', NULL, NULL, 'All travel'
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_premier'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 5.00, 'multiplier', NULL, NULL, 'All travel'
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_premier'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 5.00, 'multiplier', NULL, NULL, 'Taxis, trains, tolls & parking (travel category)'
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_premier'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_ihg_one_rewards_traveler')
  AND category_slug = 'hotels';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'multiplier', NULL, NULL, 'Base rate on all other purchases'
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_traveler'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'utilities', 3.00, 'multiplier', NULL, NULL, 'Monthly bills: utilities, internet, cable, phone'
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_traveler'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 3.00, 'multiplier', NULL, NULL, 'Select streaming services'
FROM card_ids c WHERE c.slug = 'chase_ihg_one_rewards_traveler'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET display_name = 'Air Canada Aeroplan', full_name = 'Chase Air Canada Aeroplan® Credit Card', annual_fee = 195.00 WHERE slug = 'chase_aeroplan';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', NULL, NULL, '3x through Dec 31, 2026; 2x from Jan 1, 2027'
FROM card_ids c WHERE c.slug = 'chase_aeroplan'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 3.00, 'multiplier', NULL, NULL, '3x through Dec 31, 2026; 2x from Jan 1, 2027'
FROM card_ids c WHERE c.slug = 'chase_aeroplan'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', NULL, NULL, 'Gas stations (added Sept 2026)'
FROM card_ids c WHERE c.slug = 'chase_aeroplan'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Air Canada purchases'
FROM card_ids c WHERE c.slug = 'chase_aeroplan'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'British Airways, Aer Lingus, Iberia and LEVEL purchases only; other airlines 1x'
FROM card_ids c WHERE c.slug = 'chase_british_airways'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

-- ── AMERICAN EXPRESS ──────────────────────────────────────────────────────────

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_blue_cash_everyday')
  AND category_slug = 'streaming';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 3.00, 'cashback', 6000.00, 'annual', 'Online orders from US supermarkets (incl. Instacart); shares the supermarket cap. Amazon, Walmart, Target & warehouse clubs excluded ($6,000/yr)'
FROM card_ids c WHERE c.slug = 'amex_blue_cash_everyday'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 6.00, 'cashback', 6000.00, 'annual', 'Online orders from US supermarkets (incl. Instacart); shares the supermarket cap. Amazon, Walmart, Target & warehouse clubs excluded ($6,000/yr)'
FROM card_ids c WHERE c.slug = 'amex_blue_cash_preferred'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET annual_fee = 325.00 WHERE slug = 'amex_gold';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 4.00, 'multiplier', 50000.00, 'annual', 'At restaurants worldwide (incl. US takeout/delivery); 1x after $50,000/yr'
FROM card_ids c WHERE c.slug = 'amex_gold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Booked directly with airlines or through Amex Travel'
FROM card_ids c WHERE c.slug = 'amex_gold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'multiplier', NULL, NULL, 'Prepaid hotels via Amex Travel only (since April 2026)'
FROM card_ids c WHERE c.slug = 'amex_gold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 2.00, 'multiplier', NULL, NULL, 'Prepaid car rentals via Amex Travel only'
FROM card_ids c WHERE c.slug = 'amex_gold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 4.00, 'multiplier', 25000.00, 'annual', 'Online orders from US supermarkets (incl. Instacart); shares the supermarket cap. Amazon, Walmart, Target & warehouse clubs excluded ($25,000/yr)'
FROM card_ids c WHERE c.slug = 'amex_gold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET annual_fee = 895.00 WHERE slug = 'amex_platinum';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 5.00, 'multiplier', 500000.00, 'annual', 'Booked directly with airlines or through Amex Travel; 1x after $500,000/yr'
FROM card_ids c WHERE c.slug = 'amex_platinum'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'multiplier', NULL, NULL, 'Prepaid hotels via Amex Travel only'
FROM card_ids c WHERE c.slug = 'amex_platinum'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_platinum')
  AND category_slug = 'travel';

UPDATE cards SET full_name = 'American Express® Classic Green Card' WHERE slug = 'amex_green';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_delta_blue')
  AND category_slug = 'groceries';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_delta_blue')
  AND category_slug = 'flights';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_delta_gold')
  AND category_slug = 'flights';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 2.00, 'multiplier', NULL, NULL, 'Online orders from US supermarkets (incl. Instacart); shares the supermarket cap. Amazon, Walmart, Target & warehouse clubs excluded'
FROM card_ids c WHERE c.slug = 'amex_delta_gold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'multiplier', NULL, NULL, 'Purchases made directly with hotels'
FROM card_ids c WHERE c.slug = 'amex_delta_platinum'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'multiplier', NULL, NULL, 'At US supermarkets'
FROM card_ids c WHERE c.slug = 'amex_delta_platinum'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 2.00, 'multiplier', NULL, NULL, 'Online orders from US supermarkets (incl. Instacart); shares the supermarket cap. Amazon, Walmart, Target & warehouse clubs excluded'
FROM card_ids c WHERE c.slug = 'amex_delta_platinum'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_delta_platinum')
  AND category_slug = 'flights';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_delta_reserve')
  AND category_slug = 'dining';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_delta_reserve')
  AND category_slug = 'hotels';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_delta_reserve')
  AND category_slug = 'flights';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 3.00, 'multiplier', NULL, NULL, 'Base rate on all other purchases'
FROM card_ids c WHERE c.slug = 'amex_hilton_honors'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_hilton_honors')
  AND category_slug = 'hotels';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 5.00, 'multiplier', NULL, NULL, 'Online orders from US supermarkets (incl. Instacart); shares the supermarket cap. Amazon, Walmart, Target & warehouse clubs excluded'
FROM card_ids c WHERE c.slug = 'amex_hilton_honors'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 3.00, 'multiplier', NULL, NULL, 'Base rate on all other purchases'
FROM card_ids c WHERE c.slug = 'amex_hilton_surpass'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_shopping', 4.00, 'multiplier', NULL, NULL, 'US online retail purchases'
FROM card_ids c WHERE c.slug = 'amex_hilton_surpass'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_hilton_surpass')
  AND category_slug = 'hotels';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 6.00, 'multiplier', NULL, NULL, 'At US restaurants'
FROM card_ids c WHERE c.slug = 'amex_hilton_surpass'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 6.00, 'multiplier', NULL, NULL, 'At US supermarkets'
FROM card_ids c WHERE c.slug = 'amex_hilton_surpass'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 6.00, 'multiplier', NULL, NULL, 'At US gas stations'
FROM card_ids c WHERE c.slug = 'amex_hilton_surpass'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 6.00, 'multiplier', NULL, NULL, 'Online orders from US supermarkets (incl. Instacart); shares the supermarket cap. Amazon, Walmart, Target & warehouse clubs excluded'
FROM card_ids c WHERE c.slug = 'amex_hilton_surpass'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 3.00, 'multiplier', NULL, NULL, 'Base rate on all other purchases'
FROM card_ids c WHERE c.slug = 'amex_hilton_aspire'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_hilton_aspire')
  AND category_slug = 'hotels';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 7.00, 'multiplier', NULL, NULL, 'Booked directly with select car rental companies'
FROM card_ids c WHERE c.slug = 'amex_hilton_aspire'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 7.00, 'multiplier', NULL, NULL, 'Booked directly with airlines or through Amex Travel'
FROM card_ids c WHERE c.slug = 'amex_hilton_aspire'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 7.00, 'multiplier', NULL, NULL, 'At US restaurants'
FROM card_ids c WHERE c.slug = 'amex_hilton_aspire'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 2.00, 'multiplier', NULL, NULL, 'Base rate on all other purchases'
FROM card_ids c WHERE c.slug = 'amex_marriott_brilliant'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_marriott_brilliant')
  AND category_slug = 'hotels';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Booked directly with airlines'
FROM card_ids c WHERE c.slug = 'amex_marriott_brilliant'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', NULL, NULL, 'At restaurants worldwide'
FROM card_ids c WHERE c.slug = 'amex_marriott_brilliant'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_business_gold')
  AND category_slug = 'groceries';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_business_gold')
  AND category_slug = 'online_shopping';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 3.00, 'multiplier', NULL, NULL, 'Flights and prepaid hotels via Amex Travel only'
FROM card_ids c WHERE c.slug = 'amex_business_gold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 4.00, 'multiplier', 150000.00, 'annual', 'US restaurants; 4x in your top 2 categories each month, up to $150,000/yr combined'
FROM card_ids c WHERE c.slug = 'amex_business_gold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 4.00, 'multiplier', 150000.00, 'annual', 'US gas stations; 4x in your top 2 categories each month, up to $150,000/yr combined'
FROM card_ids c WHERE c.slug = 'amex_business_gold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 4.00, 'multiplier', 150000.00, 'annual', 'Transit incl. taxis, rideshare, tolls, parking; 4x in your top 2 categories each month, up to $150,000/yr combined'
FROM card_ids c WHERE c.slug = 'amex_business_gold'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET annual_fee = 895.00 WHERE slug = 'amex_business_platinum';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_business_platinum')
  AND category_slug = 'other';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'multiplier', NULL, NULL, 'Prepaid hotels via Amex Travel only'
FROM card_ids c WHERE c.slug = 'amex_business_platinum'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 2.00, 'multiplier', NULL, NULL, 'Via Amex Travel only'
FROM card_ids c WHERE c.slug = 'amex_everyday'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 2.00, 'multiplier', 6000.00, 'annual', 'Online orders from US supermarkets (incl. Instacart); shares the supermarket cap. Amazon, Walmart, Target & warehouse clubs excluded ($6,000/yr)'
FROM card_ids c WHERE c.slug = 'amex_everyday'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET foreign_transaction_fee = 2.70 WHERE slug = 'amex_everyday_preferred';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 2.00, 'multiplier', NULL, NULL, 'Via Amex Travel only'
FROM card_ids c WHERE c.slug = 'amex_everyday_preferred'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 3.00, 'multiplier', 6000.00, 'annual', 'Online orders from US supermarkets (incl. Instacart); shares the supermarket cap. Amazon, Walmart, Target & warehouse clubs excluded ($6,000/yr)'
FROM card_ids c WHERE c.slug = 'amex_everyday_preferred'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET full_name = 'Cash Magnet® Card' WHERE slug = 'amex_cash_magnet';

UPDATE cards SET foreign_transaction_fee = 2.70 WHERE slug = 'amex_blue_business_plus';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_marriott_bonvoy_business')
  AND category_slug = 'hotels';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 4.00, 'multiplier', NULL, NULL, 'At restaurants worldwide'
FROM card_ids c WHERE c.slug = 'amex_marriott_bonvoy_business'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET annual_fee = 195.00 WHERE slug = 'amex_hilton_honors_business';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 5.00, 'multiplier', 100000.00, 'annual', '5x on first $100,000/yr of non-Hilton purchases; 3x thereafter'
FROM card_ids c WHERE c.slug = 'amex_hilton_honors_business'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_hilton_honors_business')
  AND category_slug = 'dining';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_hilton_honors_business')
  AND category_slug = 'gas';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_hilton_honors_business')
  AND category_slug = 'hotels';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_delta_gold_business')
  AND category_slug = 'gas';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_delta_gold_business')
  AND category_slug = 'flights';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_delta_platinum_business')
  AND category_slug = 'other';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'amex_delta_platinum_business')
  AND category_slug = 'flights';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 1.50, 'multiplier', NULL, NULL, 'Eligible transit purchases'
FROM card_ids c WHERE c.slug = 'amex_delta_platinum_business'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'multiplier', NULL, NULL, 'Purchases made directly with hotels'
FROM card_ids c WHERE c.slug = 'amex_delta_platinum_business'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

-- ── CAPITAL ONE ───────────────────────────────────────────────────────────────

UPDATE cards SET display_name = 'Savor', full_name = 'Capital One Savor Cash Rewards Credit Card' WHERE slug = 'capital_one_savorone';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'capital_one_savorone')
  AND category_slug = 'uber';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'capital_one_savorone')
  AND category_slug = 'uber_eats';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'cashback', NULL, NULL, 'Hotels & vacation rentals via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_savorone'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 5.00, 'cashback', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_savorone'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'cashback', NULL, NULL, 'Hotels, vacation rentals & rental cars via Capital One Travel portal (flights 1%)'
FROM card_ids c WHERE c.slug = 'capital_one_savorone'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'entertainment', 3.00, 'cashback', NULL, NULL, '3% on entertainment; 8% on Capital One Entertainment purchases'
FROM card_ids c WHERE c.slug = 'capital_one_savorone'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET display_name = 'Savor (legacy $95)', full_name = 'Capital One Savor Cash Rewards Credit Card (legacy, closed to new applicants)' WHERE slug = 'capital_one_savor';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 10.00, 'multiplier', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 10.00, 'multiplier', NULL, NULL, 'Hotels & rental cars via Capital One Travel portal (flights & vacation rentals 5x)'
FROM card_ids c WHERE c.slug = 'capital_one_venture_x'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'cashback', NULL, NULL, 'Hotels & vacation rentals via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_quicksilver'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 5.00, 'cashback', NULL, NULL, 'Via Capital One Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_quicksilver'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'cashback', NULL, NULL, 'Hotels, vacation rentals & rental cars via Capital One Travel portal (flights 1.5%)'
FROM card_ids c WHERE c.slug = 'capital_one_quicksilver'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'cashback', NULL, NULL, 'Via Capital One Business Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_spark_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 5.00, 'cashback', NULL, NULL, 'Via Capital One Business Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_spark_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'cashback', NULL, NULL, 'Hotels & rental cars via Capital One Business Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_spark_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET display_name = 'Venture Business', full_name = 'Capital One Venture Business (formerly Spark Miles)' WHERE slug = 'capital_one_spark_miles';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'multiplier', NULL, NULL, 'Hotels, vacation rentals & rental cars via Capital One Business Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_spark_miles'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET display_name = 'VentureOne Business', full_name = 'Capital One VentureOne Business (formerly Spark Miles Select)' WHERE slug = 'capital_one_spark_miles_select';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'multiplier', NULL, NULL, 'Hotels & rental cars via Capital One Business Travel portal'
FROM card_ids c WHERE c.slug = 'capital_one_spark_miles_select'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'multiplier', NULL, NULL, 'Hotels & rental cars via Capital One Travel portal (flights 1.25x)'
FROM card_ids c WHERE c.slug = 'capital_one_venture_one'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

-- ── CITI ──────────────────────────────────────────────────────────────────────

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 5.00, 'cashback', 500.00, 'monthly', '5% on top eligible spend category each billing cycle (up to $500/mo)'
FROM card_ids c WHERE c.slug = 'citi_custom_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'cashback', NULL, NULL, 'Hotels, car rentals & attractions via Citi Travel portal'
FROM card_ids c WHERE c.slug = 'citi_double_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 5.00, 'cashback', NULL, NULL, 'Via Citi Travel portal'
FROM card_ids c WHERE c.slug = 'citi_double_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'cashback', NULL, NULL, 'Via Citi Travel portal'
FROM card_ids c WHERE c.slug = 'citi_double_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET cpp_low = 1.00, cpp_default = 1.50, cpp_high = 1.80 WHERE slug = 'citi_strata_premier';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 10.00, 'multiplier', NULL, NULL, 'Hotels, car rentals & attractions via Citi Travel portal (air 3x)'
FROM card_ids c WHERE c.slug = 'citi_strata_premier'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 10.00, 'multiplier', NULL, NULL, 'Via Citi Travel portal; 1x booked direct'
FROM card_ids c WHERE c.slug = 'citi_strata_premier'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'multiplier', NULL, NULL, 'Hotels booked direct; 10x when booked through Citi Travel'
FROM card_ids c WHERE c.slug = 'citi_strata_premier'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Air travel, any airline'
FROM card_ids c WHERE c.slug = 'citi_strata_premier'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ev_charging', 3.00, 'multiplier', NULL, NULL, 'EV charging stations'
FROM card_ids c WHERE c.slug = 'citi_strata_premier'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 3.00, 'multiplier', NULL, NULL, 'Supermarkets (excl. warehouse clubs, superstores, meal kits)'
FROM card_ids c WHERE c.slug = 'citi_strata_premier'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 4.00, 'cashback', 7000.00, 'annual', '5% at Costco gas stations, 4% at other gas stations & EV charging; combined $7,000/yr cap, then 1%'
FROM card_ids c WHERE c.slug = 'citi_costco'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ev_charging', 4.00, 'cashback', 7000.00, 'annual', 'Shares the $7,000/yr gas cap, then 1%'
FROM card_ids c WHERE c.slug = 'citi_costco'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'citi_costco')
  AND category_slug = 'entertainment';

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'citi_costco')
  AND category_slug = 'streaming';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 3.00, 'cashback', NULL, NULL, 'Eligible travel incl. Costco Travel, airlines, hotels, car rentals, cruises'
FROM card_ids c WHERE c.slug = 'citi_costco'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'cashback', NULL, NULL, 'Eligible travel'
FROM card_ids c WHERE c.slug = 'citi_costco'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'cashback', NULL, NULL, 'Eligible travel'
FROM card_ids c WHERE c.slug = 'citi_costco'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 3.00, 'cashback', NULL, NULL, 'Eligible travel'
FROM card_ids c WHERE c.slug = 'citi_costco'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'citi_aadvantage_platinum_select')
  AND category_slug = 'hotels';

UPDATE cards SET full_name = 'Citi® / AAdvantage® Executive World Legend™ Mastercard®', annual_fee = 695.00 WHERE slug = 'citi_aadvantage_executive';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 10.00, 'multiplier', NULL, NULL, 'Via aadvantagehotels.com only; 1x booked direct'
FROM card_ids c WHERE c.slug = 'citi_aadvantage_executive'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 10.00, 'multiplier', NULL, NULL, 'Via the AAdvantage car rental portal only; 1x booked direct'
FROM card_ids c WHERE c.slug = 'citi_aadvantage_executive'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 2.00, 'multiplier', NULL, NULL, 'Grocery stores incl. grocery delivery services (excl. wholesale clubs, superstores)'
FROM card_ids c WHERE c.slug = 'citi_aadvantage_mileup'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'multiplier', NULL, NULL, 'Grocery stores incl. delivery services; excl. wholesale clubs & discount superstores'
FROM card_ids c WHERE c.slug = 'citi_aadvantage_mileup'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

-- ── WELLS FARGO ───────────────────────────────────────────────────────────────

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'wells_fargo_autograph')
  AND category_slug = 'entertainment';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'utilities', 3.00, 'multiplier', NULL, NULL, 'Phone plans only (cell and landline); home utilities earn 1x'
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'All travel incl. airlines booked direct'
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'multiplier', NULL, NULL, 'All travel incl. hotels booked direct'
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 3.00, 'multiplier', NULL, NULL, 'All travel incl. car rentals'
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', NULL, NULL, 'Restaurants'
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph_journey'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 3.00, 'multiplier', NULL, NULL, 'Other travel'
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph_journey'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 5.00, 'multiplier', NULL, NULL, 'Booked directly with the hotel'
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph_journey'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 4.00, 'multiplier', NULL, NULL, 'Booked directly with the airline'
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph_journey'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 3.00, 'multiplier', NULL, NULL, 'Other travel'
FROM card_ids c WHERE c.slug = 'wells_fargo_autograph_journey'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 4.00, 'cashback', NULL, NULL, 'Public transit (buses, trains, subways); rideshare not listed as eligible'
FROM card_ids c WHERE c.slug = 'wells_fargo_attune'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'entertainment', 4.00, 'cashback', NULL, NULL, 'Live shows, sporting events, movie theaters, amusement parks, florists, pet supplies & grooming'
FROM card_ids c WHERE c.slug = 'wells_fargo_attune'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

-- ── BANK OF AMERICA ───────────────────────────────────────────────────────────

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 3.00, 'cashback', 2500.00, 'quarterly', 'If gas & EV charging is your 3% choice category (default); $2,500/quarter combined cap across the 3% choice category and 2% grocery/wholesale, then 1%'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ev_charging', 3.00, 'cashback', 2500.00, 'quarterly', 'If gas & EV charging is your 3% choice category (default); $2,500/quarter combined cap across the 3% choice category and 2% grocery/wholesale, then 1%'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'cashback', 2500.00, 'quarterly', 'If dining is your 3% choice category; $2,500/quarter combined cap across the 3% choice category and 2% grocery/wholesale, then 1%'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_shopping', 3.00, 'cashback', 2500.00, 'quarterly', 'If online shopping is your 3% choice category; $2,500/quarter combined cap across the 3% choice category and 2% grocery/wholesale, then 1%'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 3.00, 'cashback', 2500.00, 'quarterly', 'If online shopping is your 3% choice category (includes streaming, cable, internet, phone); $2,500/quarter combined cap across the 3% choice category and 2% grocery/wholesale, then 1%'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 3.00, 'cashback', 2500.00, 'quarterly', 'If travel is your 3% choice category; $2,500/quarter combined cap across the 3% choice category and 2% grocery/wholesale, then 1%'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'cashback', 2500.00, 'quarterly', 'If travel is your 3% choice category; $2,500/quarter combined cap across the 3% choice category and 2% grocery/wholesale, then 1%'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'cashback', 2500.00, 'quarterly', 'If travel is your 3% choice category; $2,500/quarter combined cap across the 3% choice category and 2% grocery/wholesale, then 1%'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 3.00, 'cashback', 2500.00, 'quarterly', 'If travel is your 3% choice category; $2,500/quarter combined cap across the 3% choice category and 2% grocery/wholesale, then 1%'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'pharmacy', 3.00, 'cashback', 2500.00, 'quarterly', 'If drug stores & pharmacies is your 3% choice category; $2,500/quarter combined cap across the 3% choice category and 2% grocery/wholesale, then 1%'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 2.00, 'cashback', 2500.00, 'quarterly', 'Grocery delivery services (Instacart, Shipt) code as grocery stores; $2,500/quarter combined cap across the 3% choice category and 2% grocery/wholesale, then 1%'
FROM card_ids c WHERE c.slug = 'bofa_customized_cash'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'cashback', NULL, NULL, 'All travel'
FROM card_ids c WHERE c.slug = 'bofa_premium_rewards'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'cashback', NULL, NULL, 'All travel'
FROM card_ids c WHERE c.slug = 'bofa_premium_rewards'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 2.00, 'cashback', NULL, NULL, 'All travel'
FROM card_ids c WHERE c.slug = 'bofa_premium_rewards'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET display_name = 'Atmos Rewards Ascent Visa', full_name = 'Atmos™ Rewards Ascent Visa Signature® Credit Card (formerly Alaska Airlines Visa)', annual_fee = 95.00 WHERE slug = 'bofa_alaska_airlines';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Alaska Airlines and Hawaiian Airlines purchases only; other airlines 1x'
FROM card_ids c WHERE c.slug = 'bofa_alaska_airlines'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', NULL, NULL, 'Gas stations and EV charging'
FROM card_ids c WHERE c.slug = 'bofa_alaska_airlines'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ev_charging', 2.00, 'multiplier', NULL, NULL, 'EV charging stations'
FROM card_ids c WHERE c.slug = 'bofa_alaska_airlines'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'streaming', 2.00, 'multiplier', NULL, NULL, 'Streaming services and cable'
FROM card_ids c WHERE c.slug = 'bofa_alaska_airlines'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'multiplier', NULL, NULL, 'Local transit incl. ride-hailing, trains, tolls, ferries'
FROM card_ids c WHERE c.slug = 'bofa_alaska_airlines'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET display_name = 'Atmos Rewards Visa Business', full_name = 'Atmos™ Rewards Visa Signature® Business Card (formerly Alaska Airlines Business Visa)', annual_fee = 70.00 WHERE slug = 'bofa_alaska_airlines_business';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Alaska Airlines and Hawaiian Airlines purchases only; other airlines 1x'
FROM card_ids c WHERE c.slug = 'bofa_alaska_airlines_business'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'multiplier', NULL, NULL, 'Gas stations and EV charging'
FROM card_ids c WHERE c.slug = 'bofa_alaska_airlines_business'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ev_charging', 2.00, 'multiplier', NULL, NULL, 'EV charging stations'
FROM card_ids c WHERE c.slug = 'bofa_alaska_airlines_business'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'multiplier', NULL, NULL, 'Local transit including rideshare'
FROM card_ids c WHERE c.slug = 'bofa_alaska_airlines_business'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

-- ── US BANK ───────────────────────────────────────────────────────────────────

UPDATE cards SET cpp_low = 1.00, cpp_default = 1.00, cpp_high = 1.00 WHERE slug = 'usbank_altitude_reserve';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'multiplier', NULL, NULL, 'Flights 5x and prepaid hotels/cars 10x via U.S. Bank Travel Center portal; other travel and mobile-wallet purchases 3x'
FROM card_ids c WHERE c.slug = 'usbank_altitude_reserve'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 3.00, 'multiplier', NULL, NULL, 'Booked direct; 5x through the U.S. Bank Travel Center'
FROM card_ids c WHERE c.slug = 'usbank_altitude_reserve'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'multiplier', NULL, NULL, 'Booked direct; 10x prepaid through the U.S. Bank Travel Center'
FROM card_ids c WHERE c.slug = 'usbank_altitude_reserve'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 3.00, 'multiplier', NULL, NULL, 'Booked direct; 10x prepaid through the U.S. Bank Travel Center'
FROM card_ids c WHERE c.slug = 'usbank_altitude_reserve'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 3.00, 'multiplier', 5000.00, 'monthly', '3x only when paid with a mobile wallet (capped at $5,000 per billing cycle since Dec 2025)'
FROM card_ids c WHERE c.slug = 'usbank_altitude_reserve'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 4.00, 'multiplier', 2000.00, 'quarterly', '4x on first $2,000/quarter at restaurants (incl. takeout & delivery), then 1x'
FROM card_ids c WHERE c.slug = 'usbank_altitude_go'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ev_charging', 2.00, 'multiplier', NULL, NULL, 'EV charging stations'
FROM card_ids c WHERE c.slug = 'usbank_altitude_go'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 2.00, 'multiplier', NULL, NULL, 'Grocery delivery included'
FROM card_ids c WHERE c.slug = 'usbank_altitude_go'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'multiplier', NULL, NULL, 'Grocery stores (excl. discount stores/supercenters and wholesale clubs)'
FROM card_ids c WHERE c.slug = 'usbank_altitude_go'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 5.00, 'cashback', 2000.00, 'quarterly', 'Ground transportation (Uber, Lyft, transit) is a 5% choice category (up to $2,000/quarter combined across both 5% picks)'
FROM card_ids c WHERE c.slug = 'usbank_cash_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 2.00, 'cashback', NULL, NULL, 'If restaurants is your 2% everyday category (fast food is a separate 5% choice)'
FROM card_ids c WHERE c.slug = 'usbank_cash_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 2.00, 'cashback', NULL, NULL, 'If gas & EV charging is your 2% everyday category'
FROM card_ids c WHERE c.slug = 'usbank_cash_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ev_charging', 2.00, 'cashback', NULL, NULL, 'If gas & EV charging is your 2% everyday category'
FROM card_ids c WHERE c.slug = 'usbank_cash_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 2.00, 'cashback', NULL, NULL, 'Grocery delivery included when grocery stores is your 2% everyday category'
FROM card_ids c WHERE c.slug = 'usbank_cash_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 2.00, 'cashback', NULL, NULL, 'If grocery stores is your 2% everyday category (includes grocery delivery)'
FROM card_ids c WHERE c.slug = 'usbank_cash_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'utilities', 5.00, 'cashback', 2000.00, 'quarterly', 'Home utilities, cell phone providers, and TV/internet are each separate 5% choices (up to $2,000/quarter combined)'
FROM card_ids c WHERE c.slug = 'usbank_cash_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

-- ── BILT, BARCLAYS, DISCOVER, SYNCHRONY, PAYPAL, ROBINHOOD, APPLE, AMAZON ─────

-- Wells Fargo Bilt Mastercard retired Feb 6 2026; replaced by the Cardless-issued Bilt Card 2.0 line-up
UPDATE cards SET is_active = false WHERE slug = 'bilt_mastercard';

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee, foreign_transaction_fee)
SELECT b.id, 'bilt_blue', 'Bilt Blue', 'Bilt Blue Card', false, 'Bilt', 1.25, 1.50, 2.20, 0.00, 0.00
FROM bank_ids b WHERE b.slug = 'bilt'
ON CONFLICT (slug) DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'rent', 1.25, 'multiplier', NULL, NULL, 'Fee-free rent/mortgage through Bilt; 0.5x–1.25x depending on your everyday spend ratio (min 250 pts/mo)'
FROM card_ids c WHERE c.slug = 'bilt_blue'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 3.00, 'multiplier', NULL, NULL, 'Via Bilt Travel portal only; hotels booked direct earn 1x'
FROM card_ids c WHERE c.slug = 'bilt_blue'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 2.00, 'multiplier', NULL, NULL, 'Via Bilt Travel portal only; flights booked direct earn 1x'
FROM card_ids c WHERE c.slug = 'bilt_blue'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 3.00, 'multiplier', NULL, NULL, 'Lyft rides only (linked Lyft account); other transit 1x'
FROM card_ids c WHERE c.slug = 'bilt_blue'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

-- Closed Oct 2025; accounts converted to Citi / AAdvantage Platinum Select on Apr 24 2026
UPDATE cards SET is_active = false WHERE slug = 'barclays_aadvantage_aviator_red';

-- Program ended Mar 24 2026; accounts converted to Synchrony Premier World Mastercard (flat 2%)
UPDATE cards SET is_active = false WHERE slug = 'ebay_mastercard';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 1.50, 'cashback', NULL, NULL, '1.5% everywhere; 3% when you pay with PayPal (online or in-store PayPal checkout)'
FROM card_ids c WHERE c.slug = 'paypal_cashback'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'sams_club', 3.00, 'cashback', NULL, NULL, 'Plus members: 3% from the card (+2% Plus membership Sam''s Cash = 5% total); Club members 1%'
FROM card_ids c WHERE c.slug = 'synchrony_sams_club'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 5.00, 'cashback', 6000.00, 'annual', 'Any gas station incl. Sam''s Club fuel; first $6,000/yr combined with EV charging, then 1%'
FROM card_ids c WHERE c.slug = 'synchrony_sams_club'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ev_charging', 5.00, 'cashback', 6000.00, 'annual', 'Shares the $6,000/yr gas cap, then 1%'
FROM card_ids c WHERE c.slug = 'synchrony_sams_club'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

UPDATE cards SET annual_fee = 95.00, foreign_transaction_fee = 0.00, cpp_low = 0.60, cpp_default = 0.70, cpp_high = 1.00 WHERE slug = 'barclays_wyndham_rewards_earner_plus';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 4.00, 'multiplier', NULL, NULL, 'Restaurants'
FROM card_ids c WHERE c.slug = 'barclays_wyndham_rewards_earner_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 4.00, 'multiplier', NULL, NULL, 'Grocery stores, excl. Walmart & Target'
FROM card_ids c WHERE c.slug = 'barclays_wyndham_rewards_earner_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 4.00, 'multiplier', NULL, NULL, 'Gas is part of the 4x travel category (6x for pre-June-2026 cardholders)'
FROM card_ids c WHERE c.slug = 'barclays_wyndham_rewards_earner_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 4.00, 'multiplier', NULL, NULL, 'Travel: airfare, car rentals, rideshare, tolls, trains, gas, EV charging'
FROM card_ids c WHERE c.slug = 'barclays_wyndham_rewards_earner_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'flights', 4.00, 'multiplier', NULL, NULL, 'Airfare, any airline'
FROM card_ids c WHERE c.slug = 'barclays_wyndham_rewards_earner_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 4.00, 'multiplier', NULL, NULL, 'Car rentals'
FROM card_ids c WHERE c.slug = 'barclays_wyndham_rewards_earner_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 4.00, 'multiplier', NULL, NULL, 'Rideshare, tolls, trains'
FROM card_ids c WHERE c.slug = 'barclays_wyndham_rewards_earner_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ev_charging', 4.00, 'multiplier', NULL, NULL, 'EV charging'
FROM card_ids c WHERE c.slug = 'barclays_wyndham_rewards_earner_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 6.00, 'multiplier', NULL, NULL, 'Wyndham hotels only; other hotels 1x'
FROM card_ids c WHERE c.slug = 'barclays_wyndham_rewards_earner_plus'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'travel', 5.00, 'cashback', NULL, NULL, 'Travel booked through the Robinhood travel portal'
FROM card_ids c WHERE c.slug = 'robinhood_gold_card'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'other', 3.00, 'cashback', NULL, NULL, 'Flat 3% on all purchases; requires Robinhood Gold ($5/mo). Full 3% when redeemed to a Robinhood brokerage account'
FROM card_ids c WHERE c.slug = 'robinhood_gold_card'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'apple' FROM card_ids c WHERE c.slug = 'apple_card'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'uber', 3.00, 'cashback', NULL, NULL, 'Uber with Apple Pay'
FROM card_ids c WHERE c.slug = 'apple_card'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'uber' FROM card_ids c WHERE c.slug = 'apple_card'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'uber_eats', 3.00, 'cashback', NULL, NULL, 'Uber Eats with Apple Pay'
FROM card_ids c WHERE c.slug = 'apple_card'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'uber_eats' FROM card_ids c WHERE c.slug = 'apple_card'
ON CONFLICT DO NOTHING;

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'apple_card')
  AND category_slug = 'dining';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'amazon', 5.00, 'cashback', NULL, NULL, 'Amazon.com purchases; requires an eligible Prime membership'
FROM card_ids c WHERE c.slug = 'amazon_store_card'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'whole_foods', 5.00, 'cashback', NULL, NULL, 'Whole Foods Market (Prime members)'
FROM card_ids c WHERE c.slug = 'amazon_store_card'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'whole_foods' FROM card_ids c WHERE c.slug = 'amazon_store_card'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'groceries', 5.00, 'cashback', 1500.00, 'quarterly', 'Rotating 5% category — verify current quarter at Discover.com'
FROM card_ids c WHERE c.slug = 'discover_it_student'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 5.00, 'cashback', 1500.00, 'quarterly', 'Rotating 5% category — verify current quarter at Discover.com'
FROM card_ids c WHERE c.slug = 'discover_it_student'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'dining', 5.00, 'cashback', 1500.00, 'quarterly', 'Common rotating 5% category — verify current quarter'
FROM card_ids c WHERE c.slug = 'discover_it_student'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_shopping', 5.00, 'cashback', 1500.00, 'quarterly', 'Common rotating 5% category — verify current quarter'
FROM card_ids c WHERE c.slug = 'discover_it_student'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;
