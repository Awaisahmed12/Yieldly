type BankRow = {
  id: string
  slug: string
  display_name: string
  brand_color: string
  sort_order: number
  created_at: string
}

type CardRow = {
  id: string
  bank_id: string
  slug: string
  display_name: string
  full_name: string
  is_business: boolean
  reward_currency: string
  cpp_low: number | null
  cpp_default: number | null
  cpp_high: number | null
  annual_fee: number
  foreign_transaction_fee: number
  is_active: boolean
  created_at: string
}

type CategoryRow = {
  id: string
  slug: string
  display_name: string
  icon_name: string
  is_brand: boolean
  parent_slug: string | null
  sort_order: number
  created_at: string
}

type RewardRateRow = {
  id: string
  card_id: string
  category_slug: string
  rate: number
  rate_type: 'multiplier' | 'cashback'
  cap_amount: number | null
  cap_period: string | null
  notes: string | null
  effective_from: string | null
  effective_until: string | null
  created_at: string
}

type CardUnlockRow = {
  card_id: string
  category_slug: string
}

type UserCardRow = {
  id: string
  user_id: string
  card_id: string
  added_at: string
}

type UserPreferencesRow = {
  user_id: string
  onboarding_complete: boolean
  cpp_mode: 'conservative' | 'default' | 'optimistic'
  updated_at: string
}

type UserPreferencesInsert = {
  user_id: string
  onboarding_complete?: boolean
  cpp_mode?: 'conservative' | 'default' | 'optimistic'
  updated_at?: string
}

type UserPreferencesUpdate = {
  user_id?: string
  onboarding_complete?: boolean
  cpp_mode?: 'conservative' | 'default' | 'optimistic'
  updated_at?: string
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type AnyRecord = Record<string, any>

export type Database = {
  __InternalSupabase: {
    PostgrestVersion: '12'
  }
  public: {
    Tables: {
      banks: {
        Row: BankRow
        Insert: Omit<BankRow, 'id' | 'created_at'>
        Update: Partial<Omit<BankRow, 'id' | 'created_at'>>
        Relationships: []
      }
      cards: {
        Row: CardRow
        Insert: AnyRecord
        Update: AnyRecord
        Relationships: []
      }
      categories: {
        Row: CategoryRow
        Insert: AnyRecord
        Update: AnyRecord
        Relationships: []
      }
      reward_rates: {
        Row: RewardRateRow
        Insert: AnyRecord
        Update: AnyRecord
        Relationships: []
      }
      card_unlocks: {
        Row: CardUnlockRow
        Insert: AnyRecord
        Update: AnyRecord
        Relationships: []
      }
      user_cards: {
        Row: UserCardRow
        Insert: AnyRecord
        Update: AnyRecord
        Relationships: []
      }
      user_preferences: {
        Row: UserPreferencesRow
        Insert: UserPreferencesInsert
        Update: UserPreferencesUpdate
        Relationships: []
      }
    }
    Views: Record<string, never>
    Functions: Record<string, never>
    Enums: Record<string, never>
  }
}

// Convenience type exports
export type { CardRow, UserCardRow, UserPreferencesRow }
