-- Migration: Add beauty category
INSERT INTO categories (slug, display_name, icon_name, is_brand, parent_slug, sort_order)
VALUES ('beauty', 'Beauty', 'Scissors', false, null, 15)
ON CONFLICT (slug) DO NOTHING;
