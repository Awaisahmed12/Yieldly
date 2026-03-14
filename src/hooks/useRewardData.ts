import { useState, useEffect } from 'react'
import { supabase } from '../lib/supabase'
import type { CardRow, CategoryRow, RewardRateRow, CardUnlockRow, BankRow } from '../types/reward'

interface RewardData {
  cards: CardRow[]
  categories: CategoryRow[]
  rates: RewardRateRow[]
  unlocks: CardUnlockRow[]
  banks: BankRow[]
  loading: boolean
  error: string | null
}

// Module-level cache (persists for app lifetime)
let cache: Omit<RewardData, 'loading' | 'error'> | null = null
let fetchPromise: Promise<void> | null = null

async function fetchAll() {
  const [cardsRes, categoriesRes, ratesRes, unlocksRes, banksRes] = await Promise.all([
    supabase.from('cards').select('*').eq('is_active', true),
    supabase.from('categories').select('*').order('sort_order'),
    supabase.from('reward_rates').select('*'),
    supabase.from('card_unlocks').select('*'),
    supabase.from('banks').select('*').order('sort_order'),
  ])

  if (cardsRes.error) throw cardsRes.error
  if (categoriesRes.error) throw categoriesRes.error
  if (ratesRes.error) throw ratesRes.error
  if (unlocksRes.error) throw unlocksRes.error
  if (banksRes.error) throw banksRes.error

  cache = {
    cards: cardsRes.data as CardRow[],
    categories: categoriesRes.data as CategoryRow[],
    rates: ratesRes.data as RewardRateRow[],
    unlocks: unlocksRes.data as CardUnlockRow[],
    banks: banksRes.data as BankRow[],
  }
}

export function useRewardData(): RewardData {
  const [state, setState] = useState<RewardData>({
    cards: cache?.cards ?? [],
    categories: cache?.categories ?? [],
    rates: cache?.rates ?? [],
    unlocks: cache?.unlocks ?? [],
    banks: cache?.banks ?? [],
    loading: cache === null,
    error: null,
  })

  useEffect(() => {
    if (cache !== null) return  // already loaded

    if (!fetchPromise) {
      fetchPromise = fetchAll().catch(err => {
        setState(s => ({ ...s, loading: false, error: (err as Error).message }))
        fetchPromise = null
      })
    }

    fetchPromise.then(() => {
      if (cache) {
        setState({ ...cache, loading: false, error: null })
      }
    })
  }, [])

  return state
}
