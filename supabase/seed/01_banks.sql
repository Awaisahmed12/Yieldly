-- Seed: Banks
-- Idempotent: ON CONFLICT (slug) DO NOTHING

INSERT INTO banks (slug, display_name, brand_color, sort_order) VALUES
  ('chase',        'Chase',           '#117ACA', 1),
  ('amex',         'American Express','#016FD0', 2),
  ('citi',         'Citi',            '#003B70', 3),
  ('capital_one',  'Capital One',     '#D03027', 4),
  ('discover',     'Discover',        '#F76F20', 5),
  ('apple',        'Apple',           '#555555', 6),
  ('amazon',       'Amazon',          '#FF9900', 7),
  ('wells_fargo',  'Wells Fargo',     '#CD3129', 8),
  ('bofa',         'Bank of America', '#E31837', 9),
  ('usbank',       'US Bank',         '#003087', 10),
  ('robinhood',    'Robinhood',       '#00C805', 11),
  ('cash_app',     'Cash App',        '#00D632', 12),
  ('synchrony',    'Synchrony',       '#0071CE', 13)
ON CONFLICT (slug) DO NOTHING;
