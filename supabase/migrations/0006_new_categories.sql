-- Migration: Add utilities, fitness, and EV charging categories

INSERT INTO categories (slug, display_name, icon_name, is_brand, parent_slug, sort_order)
VALUES
  ('utilities',    'Utilities',    'Zap',            false, null, 16),
  ('fitness',      'Fitness',      'Dumbbell',       false, null, 17),
  ('ev_charging',  'EV Charging',  'BatteryCharging', false, null, 18)
ON CONFLICT (slug) DO NOTHING;
