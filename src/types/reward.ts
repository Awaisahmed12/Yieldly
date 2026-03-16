import type { Database } from './supabase'

export type CardRow = Database['public']['Tables']['cards']['Row']
export type CategoryRow = Database['public']['Tables']['categories']['Row']
export type RewardRateRow = Database['public']['Tables']['reward_rates']['Row']
export type CardUnlockRow = Database['public']['Tables']['card_unlocks']['Row']
export type UserCardRow = Database['public']['Tables']['user_cards']['Row']
export type UserPrefsRow = Database['public']['Tables']['user_preferences']['Row']
export type BankRow = Database['public']['Tables']['banks']['Row']

export type CppMode = 'conservative' | 'default' | 'optimistic'

export interface RankedResult {
  card: CardRow
  rawRate: number            // e.g. 3.0 (the stored rate)
  rateType: 'multiplier' | 'cashback'
  rewardCurrency: string     // 'UR', 'CB', etc.
  effectiveCpd: number       // normalized cents-per-dollar (used for sorting)
  estimatedPct: number       // display percentage (e.g. 4.5 for "~4.5%")
  notes: string | null
  hasCap: boolean
  isTie: boolean
  rank: number
  ftfApplied: number         // foreign transaction fee deducted (0 for normal categories)
}

export interface TiebreakerFactor {
  type: 'annual_fee' | 'no_cap' | 'cashback_simplicity' | 'portal_restriction'
  explanation: string
  favoredCardSlug: string | null
}

export interface TieInfo {
  tiedResults: RankedResult[]
  factors: TiebreakerFactor[]
}

export interface SubpromptOption {
  slug: string
  label: string
}
