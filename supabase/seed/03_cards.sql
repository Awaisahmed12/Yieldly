-- Seed: Cards
-- Uses CTEs to look up bank IDs by slug.
-- Idempotent: ON CONFLICT (slug) DO NOTHING
--
-- CPP reference by reward_currency:
--   CB      (Cash Back)             : 1.00 / 1.00 / 1.00
--   UR      (Chase Ultimate Rewards): 1.00 / 1.50 / 2.00
--   MR      (Amex Membership Rewards): 1.00 / 1.40 / 2.00
--   TYP     (Citi ThankYou Points)  : 1.00 / 1.30 / 1.70
--   C1      (Capital One Miles)     : 1.00 / 1.50 / 1.85
--   SW      (Southwest Rapid Rewards): 1.30 / 1.50 / 1.80
--   UA      (United MileagePlus)    : 1.10 / 1.35 / 1.80
--   DL      (Delta SkyMiles)        : 1.00 / 1.20 / 1.60
--   HH      (Hilton Honors)         : 0.40 / 0.55 / 0.70
--   Bonvoy  (Marriott Bonvoy)       : 0.60 / 0.80 / 1.10
--   Hyatt   (World of Hyatt)        : 1.20 / 1.70 / 2.20
--   Alaska  (Alaska Airlines Miles) : 1.00 / 1.40 / 1.80

-- ── CHASE ──────────────────────────────────────────────────────────────────

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'chase_freedom_unlimited', 'Freedom Unlimited', 'Chase Freedom Unlimited®', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'chase'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'chase_freedom_flex', 'Freedom Flex', 'Chase Freedom Flex℠', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'chase'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'chase_sapphire_preferred', 'Sapphire Preferred', 'Chase Sapphire Preferred® Card', false, 'UR', 1.00, 1.50, 2.00, 95.00
FROM bank_ids b WHERE b.slug = 'chase'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'chase_sapphire_reserve', 'Sapphire Reserve', 'Chase Sapphire Reserve®', false, 'UR', 1.00, 1.50, 2.00, 550.00
FROM bank_ids b WHERE b.slug = 'chase'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'chase_amazon_prime_visa', 'Amazon Prime Visa', 'Amazon Prime Rewards Visa Signature', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'chase'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'chase_united_explorer', 'United Explorer', 'United℠ Explorer Card', false, 'UA', 1.10, 1.35, 1.80, 95.00
FROM bank_ids b WHERE b.slug = 'chase'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'chase_united_club_infinite', 'United Club Infinite', 'United Club℠ Infinite Card', false, 'UA', 1.10, 1.35, 1.80, 525.00
FROM bank_ids b WHERE b.slug = 'chase'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'chase_marriott_boundless', 'Marriott Bonvoy Boundless', 'Marriott Bonvoy Boundless® Credit Card', false, 'Bonvoy', 0.60, 0.80, 1.10, 95.00
FROM bank_ids b WHERE b.slug = 'chase'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'chase_southwest_plus', 'Southwest Plus', 'Southwest Rapid Rewards® Plus Credit Card', false, 'SW', 1.30, 1.50, 1.80, 69.00
FROM bank_ids b WHERE b.slug = 'chase'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'chase_southwest_premier', 'Southwest Premier', 'Southwest Rapid Rewards® Premier Credit Card', false, 'SW', 1.30, 1.50, 1.80, 99.00
FROM bank_ids b WHERE b.slug = 'chase'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'chase_southwest_priority', 'Southwest Priority', 'Southwest Rapid Rewards® Priority Credit Card', false, 'SW', 1.30, 1.50, 1.80, 149.00
FROM bank_ids b WHERE b.slug = 'chase'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'chase_ink_business_cash', 'Ink Business Cash', 'Ink Business Cash® Credit Card', true, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'chase'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'chase_ink_business_unlimited', 'Ink Business Unlimited', 'Ink Business Unlimited® Credit Card', true, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'chase'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'chase_hyatt', 'World of Hyatt', 'World of Hyatt Credit Card', false, 'Hyatt', 1.20, 1.70, 2.20, 95.00
FROM bank_ids b WHERE b.slug = 'chase'
ON CONFLICT (slug) DO NOTHING;

-- ── AMERICAN EXPRESS ───────────────────────────────────────────────────────

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_blue_cash_everyday', 'Blue Cash Everyday', 'Blue Cash Everyday® Card', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_blue_cash_preferred', 'Blue Cash Preferred', 'Blue Cash Preferred® Card', false, 'CB', 1.00, 1.00, 1.00, 95.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_gold', 'Gold Card', 'American Express® Gold Card', false, 'MR', 1.00, 1.40, 2.00, 250.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_platinum', 'Platinum Card', 'The Platinum Card®', false, 'MR', 1.00, 1.40, 2.00, 695.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_green', 'Green Card', 'American Express® Green Card', false, 'MR', 1.00, 1.40, 2.00, 150.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_delta_blue', 'Delta Blue', 'Delta SkyMiles® Blue American Express Card', false, 'DL', 1.00, 1.20, 1.60, 0.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_delta_gold', 'Delta Gold', 'Delta SkyMiles® Gold American Express Card', false, 'DL', 1.00, 1.20, 1.60, 150.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_delta_platinum', 'Delta Platinum', 'Delta SkyMiles® Platinum American Express Card', false, 'DL', 1.00, 1.20, 1.60, 350.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_delta_reserve', 'Delta Reserve', 'Delta SkyMiles® Reserve American Express Card', false, 'DL', 1.00, 1.20, 1.60, 650.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_hilton_honors', 'Hilton Honors', 'Hilton Honors American Express Card', false, 'HH', 0.40, 0.55, 0.70, 0.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_hilton_surpass', 'Hilton Surpass', 'Hilton Honors American Express Surpass® Card', false, 'HH', 0.40, 0.55, 0.70, 150.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_hilton_aspire', 'Hilton Aspire', 'Hilton Honors American Express Aspire Card', false, 'HH', 0.40, 0.55, 0.70, 550.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_marriott_brilliant', 'Marriott Brilliant', 'Marriott Bonvoy Brilliant™ American Express® Card', false, 'Bonvoy', 0.60, 0.80, 1.10, 650.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_business_gold', 'Business Gold', 'American Express® Business Gold Card', true, 'MR', 1.00, 1.40, 2.00, 375.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amex_business_platinum', 'Business Platinum', 'The Business Platinum Card®', true, 'MR', 1.00, 1.40, 2.00, 695.00
FROM bank_ids b WHERE b.slug = 'amex'
ON CONFLICT (slug) DO NOTHING;

-- ── CITI ───────────────────────────────────────────────────────────────────

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'citi_double_cash', 'Double Cash', 'Citi Double Cash® Card', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'citi'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'citi_custom_cash', 'Custom Cash', 'Citi Custom Cash® Card', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'citi'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'citi_strata_premier', 'Strata Premier', 'Citi Strata Premier℠ Card', false, 'TYP', 1.00, 1.30, 1.70, 95.00
FROM bank_ids b WHERE b.slug = 'citi'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'citi_costco', 'Costco Anywhere Visa', 'Costco Anywhere Visa® Card by Citi', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'citi'
ON CONFLICT (slug) DO NOTHING;

-- ── CAPITAL ONE ────────────────────────────────────────────────────────────

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'capital_one_venture_x', 'Venture X', 'Capital One Venture X Rewards Credit Card', false, 'C1', 1.00, 1.50, 1.85, 395.00
FROM bank_ids b WHERE b.slug = 'capital_one'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'capital_one_venture', 'Venture', 'Capital One Venture Rewards Credit Card', false, 'C1', 1.00, 1.50, 1.85, 95.00
FROM bank_ids b WHERE b.slug = 'capital_one'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'capital_one_quicksilver', 'Quicksilver', 'Capital One Quicksilver Cash Rewards Credit Card', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'capital_one'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'capital_one_savorone', 'SavorOne', 'Capital One SavorOne Cash Rewards Credit Card', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'capital_one'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'capital_one_savor', 'Savor', 'Capital One Savor Cash Rewards Credit Card', false, 'CB', 1.00, 1.00, 1.00, 95.00
FROM bank_ids b WHERE b.slug = 'capital_one'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'capital_one_spark_cash', 'Spark Cash Plus', 'Capital One Spark Cash Plus', true, 'CB', 1.00, 1.00, 1.00, 150.00
FROM bank_ids b WHERE b.slug = 'capital_one'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'capital_one_venture_one', 'VentureOne', 'Capital One VentureOne Rewards Credit Card', false, 'C1', 1.00, 1.50, 1.85, 0.00
FROM bank_ids b WHERE b.slug = 'capital_one'
ON CONFLICT (slug) DO NOTHING;

-- ── DISCOVER ───────────────────────────────────────────────────────────────

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'discover_it_cash', 'Discover it Cash Back', 'Discover it® Cash Back', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'discover'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'discover_it_miles', 'Discover it Miles', 'Discover it® Miles', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'discover'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'discover_it_student', 'Discover it Student', 'Discover it® Student Cash Back', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'discover'
ON CONFLICT (slug) DO NOTHING;

-- ── APPLE ──────────────────────────────────────────────────────────────────

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'apple_card', 'Apple Card', 'Apple Card', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'apple'
ON CONFLICT (slug) DO NOTHING;

-- ── AMAZON ─────────────────────────────────────────────────────────────────

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'amazon_store_card', 'Amazon Store Card', 'Amazon Store Card', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'amazon'
ON CONFLICT (slug) DO NOTHING;

-- ── WELLS FARGO ────────────────────────────────────────────────────────────

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'wells_fargo_active_cash', 'Active Cash', 'Wells Fargo Active Cash® Card', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'wells_fargo'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'wells_fargo_autograph', 'Autograph', 'Wells Fargo Autograph℠ Card', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'wells_fargo'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'wells_fargo_attune', 'Attune', 'Wells Fargo Attune℠ Card', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'wells_fargo'
ON CONFLICT (slug) DO NOTHING;

-- ── BANK OF AMERICA ────────────────────────────────────────────────────────

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'bofa_customized_cash', 'Customized Cash Rewards', 'Bank of America® Customized Cash Rewards', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'bofa'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'bofa_premium_rewards', 'Premium Rewards', 'Bank of America® Premium Rewards®', false, 'CB', 1.00, 1.00, 1.00, 95.00
FROM bank_ids b WHERE b.slug = 'bofa'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'bofa_travel_rewards', 'Travel Rewards', 'Bank of America® Travel Rewards', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'bofa'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'bofa_alaska_airlines', 'Alaska Airlines Visa', 'Alaska Airlines Visa® Signature Card', false, 'Alaska', 1.00, 1.40, 1.80, 75.00
FROM bank_ids b WHERE b.slug = 'bofa'
ON CONFLICT (slug) DO NOTHING;

-- ── US BANK ────────────────────────────────────────────────────────────────

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'usbank_altitude_reserve', 'Altitude Reserve', 'U.S. Bank Altitude® Reserve Visa Infinite® Card', false, 'Points', 1.50, 1.50, 1.50, 400.00
FROM bank_ids b WHERE b.slug = 'usbank'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'usbank_altitude_go', 'Altitude Go', 'U.S. Bank Altitude® Go Visa Signature® Card', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'usbank'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'usbank_cash_plus', 'Cash+', 'U.S. Bank Cash+® Visa Signature® Card', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'usbank'
ON CONFLICT (slug) DO NOTHING;

-- ── ROBINHOOD ──────────────────────────────────────────────────────────────

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'robinhood_gold_card', 'Gold Card', 'Robinhood Gold Card', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'robinhood'
ON CONFLICT (slug) DO NOTHING;

-- ── SYNCHRONY ──────────────────────────────────────────────────────────────

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'paypal_cashback', 'PayPal Cashback', 'PayPal Cashback Mastercard®', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'synchrony'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'synchrony_sams_club', 'Sam''s Club Mastercard', 'Sam''s Club® Mastercard®', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'synchrony'
ON CONFLICT (slug) DO NOTHING;

WITH bank_ids AS (SELECT slug, id FROM banks)
INSERT INTO cards (bank_id, slug, display_name, full_name, is_business, reward_currency, cpp_low, cpp_default, cpp_high, annual_fee)
SELECT b.id, 'ebay_mastercard', 'eBay Mastercard', 'eBay Mastercard®', false, 'CB', 1.00, 1.00, 1.00, 0.00
FROM bank_ids b WHERE b.slug = 'synchrony'
ON CONFLICT (slug) DO NOTHING;
