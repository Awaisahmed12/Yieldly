-- Seed: Categories
-- Standard categories first (no parent), then brand categories.
-- Idempotent: ON CONFLICT (slug) DO NOTHING

-- Standard categories
INSERT INTO categories (slug, display_name, icon_name, is_brand, parent_slug, sort_order) VALUES
  ('groceries',       'Groceries',       'ShoppingCart',       false, NULL, 1),
  ('dining',          'Dining',          'UtensilsCrossed',    false, NULL, 2),
  ('gas',             'Gas',             'Fuel',               false, NULL, 3),
  ('travel',          'Travel',          'Plane',              false, NULL, 4),
  ('flights',         'Flights',         'PlaneTakeoff',       false, NULL, 5),
  ('hotels',          'Hotels',          'Hotel',              false, NULL, 6),
  ('streaming',       'Streaming',       'Tv',                 false, NULL, 7),
  ('pharmacy',        'Pharmacy / Drugstore', 'Pill',          false, NULL, 8),
  ('entertainment',   'Entertainment',   'Clapperboard',       false, NULL, 9),
  ('transit',         'Transit',         'Train',              false, NULL, 10),
  ('online_shopping', 'Online Shopping', 'ShoppingBag',        false, NULL, 11),
  ('rent',            'Rent',            'Home',               false, NULL, 12),
  ('wholesale_clubs', 'Wholesale Clubs', 'Warehouse',          false, NULL, 13),
  ('car_rental',      'Car Rental',      'Car',                false, NULL, 14),
  ('beauty',          'Beauty',          'Scissors',           false, NULL, 15),
  ('other',           'Other',           'Tag',                false, NULL, 99)
ON CONFLICT (slug) DO NOTHING;

-- Brand categories (depend on parent standard categories above)
INSERT INTO categories (slug, display_name, icon_name, is_brand, parent_slug, sort_order) VALUES
  ('apple',       'Apple',         'Apple',            true, 'online_shopping',  19),
  ('amazon',      'Amazon',        'Package',          true, 'online_shopping',  20),
  ('whole_foods', 'Whole Foods',   'Leaf',             true, 'groceries',        21),
  ('costco',      'Costco',        'Warehouse',        true, 'wholesale_clubs',  22),
  ('sams_club',   'Sam''s Club',   'Warehouse',        true, 'wholesale_clubs',  23),
  ('united',      'United',        'PlaneTakeoff',     true, 'flights',          23),
  ('delta',       'Delta',         'PlaneTakeoff',     true, 'flights',          24),
  ('southwest',   'Southwest',     'PlaneTakeoff',     true, 'flights',          25),
  ('jetblue',     'JetBlue',       'PlaneTakeoff',     true, 'flights',          26),
  ('hilton',      'Hilton',        'Hotel',            true, 'hotels',           27),
  ('marriott',    'Marriott',      'Hotel',            true, 'hotels',           28),
  ('hyatt',       'Hyatt',         'Hotel',            true, 'hotels',           29),
  ('ihg',         'IHG Hotels',    'Hotel',            true, 'hotels',           30),
  ('uber',        'Uber',          'Car',              true, 'transit',          31),
  ('uber_eats',   'Uber Eats',     'UtensilsCrossed',  true, 'dining',           32),
  ('ebay',        'eBay',          'Tag',              true, 'online_shopping',  33)
ON CONFLICT (slug) DO NOTHING;
