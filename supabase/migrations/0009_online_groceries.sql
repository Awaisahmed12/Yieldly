-- Migration: Online Groceries category + Chase Sapphire Preferred corrections
--
-- 1. Chase Sapphire Preferred earns 3x on ONLINE grocery orders only (excluding
--    Walmart, Target and wholesale clubs); in-store supermarkets earn 1x. The seed
--    stored an unconditional 3x `groceries` row, so CSP wrongly won the Groceries tile.
--    `groceries` now means in-store; the new `online_groceries` category covers
--    delivery/pickup/online supermarket orders (Instacart, Amazon Fresh, store apps).
-- 2. Apply the June 15 2026 Sapphire Preferred refresh: 3x gas & EV charging,
--    3x vacation rentals (Airbnb/Vrbo); other travel (transit, car rental) is 2x,
--    with 5x reserved for bookings through Chase Travel.

-- ── CATEGORY ───────────────────────────────────────────────────────────────

INSERT INTO categories (slug, display_name, icon_name, is_brand, parent_slug, sort_order)
VALUES ('online_groceries', 'Online Groceries', 'ShoppingBasket', false, null, 19)
ON CONFLICT (slug) DO NOTHING;

-- ── CHASE SAPPHIRE PREFERRED ───────────────────────────────────────────────

DELETE FROM reward_rates
WHERE card_id = (SELECT id FROM cards WHERE slug = 'chase_sapphire_preferred')
  AND category_slug = 'groceries';

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'online_groceries', 3.00, 'multiplier', NULL, NULL, 'Online grocery orders (delivery, pickup, store apps); excludes Walmart, Target & wholesale clubs. In-store groceries earn 1x'
FROM card_ids c WHERE c.slug = 'chase_sapphire_preferred'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'gas', 3.00, 'multiplier', NULL, NULL, 'Gas stations (added June 2026)'
FROM card_ids c WHERE c.slug = 'chase_sapphire_preferred'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'ev_charging', 3.00, 'multiplier', NULL, NULL, 'EV charging (added June 2026)'
FROM card_ids c WHERE c.slug = 'chase_sapphire_preferred'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

-- Transit is "other travel" at 2x (the seed had 5x, which only applies through Chase Travel)
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'transit', 2.00, 'multiplier', NULL, NULL, 'Transit, taxis & rideshare count as other travel'
FROM card_ids c WHERE c.slug = 'chase_sapphire_preferred'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'car_rental', 2.00, 'multiplier', NULL, NULL, 'Booked direct; 5x when booked through Chase Travel'
FROM card_ids c WHERE c.slug = 'chase_sapphire_preferred'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO reward_rates (card_id, category_slug, rate, rate_type, cap_amount, cap_period, notes)
SELECT c.id, 'hotels', 2.00, 'multiplier', NULL, NULL, 'Hotels booked direct; 3x at Airbnb, Vrbo & other vacation rentals'
FROM card_ids c WHERE c.slug = 'chase_sapphire_preferred'
ON CONFLICT (card_id, category_slug) DO UPDATE
  SET rate = EXCLUDED.rate, rate_type = EXCLUDED.rate_type, cap_amount = EXCLUDED.cap_amount, cap_period = EXCLUDED.cap_period, notes = EXCLUDED.notes;
