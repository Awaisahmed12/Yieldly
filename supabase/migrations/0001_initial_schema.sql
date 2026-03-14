-- Banks
CREATE TABLE IF NOT EXISTS banks (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug         text UNIQUE NOT NULL,
  display_name text NOT NULL,
  brand_color  text NOT NULL DEFAULT '#000000',
  sort_order   smallint NOT NULL DEFAULT 0,
  created_at   timestamptz DEFAULT now()
);

-- Cards
CREATE TABLE IF NOT EXISTS cards (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  bank_id          uuid NOT NULL REFERENCES banks(id),
  slug             text UNIQUE NOT NULL,
  display_name     text NOT NULL,
  full_name        text NOT NULL,
  is_business      boolean NOT NULL DEFAULT false,
  reward_currency  text NOT NULL,
  cpp_low          numeric(6,4),
  cpp_default      numeric(6,4),
  cpp_high         numeric(6,4),
  annual_fee       numeric(7,2) NOT NULL DEFAULT 0,
  is_active        boolean NOT NULL DEFAULT true,
  created_at       timestamptz DEFAULT now()
);

-- Categories
CREATE TABLE IF NOT EXISTS categories (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug         text UNIQUE NOT NULL,
  display_name text NOT NULL,
  icon_name    text NOT NULL,
  is_brand     boolean NOT NULL DEFAULT false,
  parent_slug  text REFERENCES categories(slug),
  sort_order   smallint NOT NULL DEFAULT 0,
  created_at   timestamptz DEFAULT now()
);

-- Reward rates
CREATE TABLE IF NOT EXISTS reward_rates (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  card_id         uuid NOT NULL REFERENCES cards(id),
  category_slug   text NOT NULL REFERENCES categories(slug),
  rate            numeric(5,2) NOT NULL,
  rate_type       text NOT NULL CHECK (rate_type IN ('multiplier', 'cashback')),
  cap_amount      numeric(10,2),
  cap_period      text CHECK (cap_period IN ('monthly', 'quarterly', 'annual')),
  notes           text,
  effective_from  date,
  effective_until date,
  created_at      timestamptz DEFAULT now(),
  UNIQUE (card_id, category_slug)
);

-- Card → category unlocks
CREATE TABLE IF NOT EXISTS card_unlocks (
  card_id        uuid NOT NULL REFERENCES cards(id),
  category_slug  text NOT NULL REFERENCES categories(slug),
  PRIMARY KEY (card_id, category_slug)
);

-- User's cards
CREATE TABLE IF NOT EXISTS user_cards (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  card_id    uuid NOT NULL REFERENCES cards(id),
  added_at   timestamptz DEFAULT now(),
  UNIQUE (user_id, card_id)
);

-- User preferences
CREATE TABLE IF NOT EXISTS user_preferences (
  user_id             uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  onboarding_complete boolean NOT NULL DEFAULT false,
  cpp_mode            text NOT NULL DEFAULT 'default'
                        CHECK (cpp_mode IN ('conservative', 'default', 'optimistic')),
  updated_at          timestamptz DEFAULT now()
);

-- RLS
ALTER TABLE banks            ENABLE ROW LEVEL SECURITY;
ALTER TABLE cards            ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories       ENABLE ROW LEVEL SECURITY;
ALTER TABLE reward_rates     ENABLE ROW LEVEL SECURITY;
ALTER TABLE card_unlocks     ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_cards       ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_read_banks"        ON banks        FOR SELECT USING (true);
CREATE POLICY "public_read_cards"        ON cards        FOR SELECT USING (true);
CREATE POLICY "public_read_categories"   ON categories   FOR SELECT USING (true);
CREATE POLICY "public_read_rates"        ON reward_rates FOR SELECT USING (true);
CREATE POLICY "public_read_unlocks"      ON card_unlocks FOR SELECT USING (true);

CREATE POLICY "user_cards_select" ON user_cards FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "user_cards_insert" ON user_cards FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "user_cards_delete" ON user_cards FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "user_prefs_all" ON user_preferences FOR ALL
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
