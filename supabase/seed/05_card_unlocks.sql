-- Seed: Card Unlocks
-- Maps cards to brand categories they "unlock" for display in the UI.
-- Idempotent: ON CONFLICT DO NOTHING (PK is card_id + category_slug)

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'amazon'      FROM card_ids c WHERE c.slug = 'chase_amazon_prime_visa'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'whole_foods' FROM card_ids c WHERE c.slug = 'chase_amazon_prime_visa'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'amazon'      FROM card_ids c WHERE c.slug = 'amazon_store_card'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'costco'      FROM card_ids c WHERE c.slug = 'citi_costco'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'sams_club'   FROM card_ids c WHERE c.slug = 'synchrony_sams_club'
ON CONFLICT DO NOTHING;

-- United cards
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'united'      FROM card_ids c WHERE c.slug = 'chase_united_explorer'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'united'      FROM card_ids c WHERE c.slug = 'chase_united_club_infinite'
ON CONFLICT DO NOTHING;

-- Delta cards
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'delta'       FROM card_ids c WHERE c.slug = 'amex_delta_blue'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'delta'       FROM card_ids c WHERE c.slug = 'amex_delta_gold'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'delta'       FROM card_ids c WHERE c.slug = 'amex_delta_platinum'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'delta'       FROM card_ids c WHERE c.slug = 'amex_delta_reserve'
ON CONFLICT DO NOTHING;

-- Southwest cards
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'southwest'   FROM card_ids c WHERE c.slug = 'chase_southwest_plus'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'southwest'   FROM card_ids c WHERE c.slug = 'chase_southwest_premier'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'southwest'   FROM card_ids c WHERE c.slug = 'chase_southwest_priority'
ON CONFLICT DO NOTHING;

-- Hilton cards
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'hilton'      FROM card_ids c WHERE c.slug = 'amex_hilton_honors'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'hilton'      FROM card_ids c WHERE c.slug = 'amex_hilton_surpass'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'hilton'      FROM card_ids c WHERE c.slug = 'amex_hilton_aspire'
ON CONFLICT DO NOTHING;

-- Marriott cards
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'marriott'    FROM card_ids c WHERE c.slug = 'chase_marriott_boundless'
ON CONFLICT DO NOTHING;

WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'marriott'    FROM card_ids c WHERE c.slug = 'amex_marriott_brilliant'
ON CONFLICT DO NOTHING;

-- Hyatt card
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'hyatt'       FROM card_ids c WHERE c.slug = 'chase_hyatt'
ON CONFLICT DO NOTHING;

-- eBay card
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'ebay'        FROM card_ids c WHERE c.slug = 'ebay_mastercard'
ON CONFLICT DO NOTHING;

-- Discover it Cash Back unlocks Amazon (frequent rotating category)
WITH card_ids AS (SELECT slug, id FROM cards)
INSERT INTO card_unlocks (card_id, category_slug)
SELECT c.id, 'amazon'      FROM card_ids c WHERE c.slug = 'discover_it_cash'
ON CONFLICT DO NOTHING;
