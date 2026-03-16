-- Migration: Add foreign_transaction_fee to cards and add foreign_spending category

-- 1. Add column
ALTER TABLE cards
  ADD COLUMN IF NOT EXISTS foreign_transaction_fee decimal(5,2) NOT NULL DEFAULT 0;

-- 2. Set 0% FTF for all travel/premium/Capital One/Discover cards
UPDATE cards SET foreign_transaction_fee = 0 WHERE slug IN (
  -- Chase travel
  'chase_sapphire_preferred', 'chase_sapphire_reserve', 'chase_amazon_prime_visa',
  'chase_united_explorer', 'chase_united_club_infinite', 'chase_united_quest',
  'chase_united_gateway', 'chase_united_business',
  'chase_marriott_boundless', 'chase_marriott_bold',
  'chase_southwest_plus', 'chase_southwest_premier', 'chase_southwest_priority',
  'chase_hyatt', 'chase_ink_business_preferred',
  'chase_ihg_one_rewards_premier', 'chase_ihg_one_rewards_traveler',
  'chase_aeroplan', 'chase_british_airways',
  -- Amex travel/premium
  'amex_gold', 'amex_platinum', 'amex_green',
  'amex_delta_blue', 'amex_delta_gold', 'amex_delta_platinum', 'amex_delta_reserve',
  'amex_hilton_honors', 'amex_hilton_surpass', 'amex_hilton_aspire',
  'amex_marriott_brilliant', 'amex_business_gold', 'amex_business_platinum',
  'amex_blue_business_plus', 'amex_marriott_bonvoy_business',
  'amex_hilton_honors_business', 'amex_delta_gold_business', 'amex_delta_platinum_business',
  'amex_everyday_preferred',
  -- Citi travel
  'citi_strata_premier', 'citi_aadvantage_platinum_select', 'citi_aadvantage_executive',
  -- Capital One (all 0% FTF)
  'capital_one_venture_x', 'capital_one_venture', 'capital_one_quicksilver',
  'capital_one_savorone', 'capital_one_savor', 'capital_one_spark_cash',
  'capital_one_venture_one', 'capital_one_venture_x_business',
  'capital_one_spark_miles', 'capital_one_spark_miles_select',
  -- Discover (all 0% FTF)
  'discover_it_cash', 'discover_it_miles', 'discover_it_student',
  -- Others with 0% FTF
  'apple_card', 'amazon_store_card',
  'wells_fargo_autograph', 'wells_fargo_autograph_journey',
  'bofa_premium_rewards', 'bofa_travel_rewards',
  'bofa_alaska_airlines', 'bofa_alaska_airlines_business',
  'usbank_altitude_reserve', 'usbank_altitude_go',
  'robinhood_gold_card',
  'synchrony_sams_club', 'ebay_mastercard',
  'barclays_jetblue_plus', 'barclays_jetblue', 'barclays_aadvantage_aviator_red',
  'bilt_mastercard'
);

-- 3. Set 3% FTF for standard cashback/non-travel cards
UPDATE cards SET foreign_transaction_fee = 3 WHERE slug IN (
  'chase_freedom_unlimited', 'chase_freedom_flex',
  'chase_ink_business_cash', 'chase_ink_business_unlimited',
  'citi_double_cash', 'citi_custom_cash', 'citi_costco', 'citi_aadvantage_mileup',
  'wells_fargo_active_cash', 'wells_fargo_attune',
  'usbank_cash_plus',
  'bofa_customized_cash',
  'barclays_wyndham_rewards_earner_plus',
  'paypal_cashback'
);

-- 4. Set 2.7% FTF for Amex non-travel cashback cards
UPDATE cards SET foreign_transaction_fee = 2.7 WHERE slug IN (
  'amex_blue_cash_everyday', 'amex_blue_cash_preferred',
  'amex_everyday', 'amex_cash_magnet', 'amex_blue_business_cash'
);

-- 5. Add foreign_spending category
INSERT INTO categories (slug, display_name, icon_name, is_brand, parent_slug, sort_order)
VALUES ('foreign_spending', 'Foreign Spending', 'Globe', false, null, 98)
ON CONFLICT (slug) DO NOTHING;

-- 6. Add car_rental category (if not already present)
INSERT INTO categories (slug, display_name, icon_name, is_brand, parent_slug, sort_order)
VALUES ('car_rental', 'Car Rental', 'Car', false, null, 14)
ON CONFLICT (slug) DO UPDATE SET display_name = EXCLUDED.display_name;

-- Rename pharmacy display name
UPDATE categories SET display_name = 'Pharmacy / Drugstore' WHERE slug = 'pharmacy';
