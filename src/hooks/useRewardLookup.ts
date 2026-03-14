import { useMemo } from 'react'
import { useUserStore } from '../store/userStore'
import { useRewardData } from './useRewardData'
import { rankCardsForCategory } from '../lib/rewards'
import { detectTie } from '../lib/tiebreaker'
import { getSubpromptOptions } from '../lib/categories'
import type { RankedResult, TieInfo, SubpromptOption } from '../types/reward'

interface RewardLookupResult {
  ranked: RankedResult[]
  winner: RankedResult | null
  tie: TieInfo | null
  subpromptOptions: SubpromptOption[] | null
  loading: boolean
}

export function useRewardLookup(categorySlug: string | null): RewardLookupResult {
  const { userCards, userCardIds, prefs } = useUserStore()
  const { rates, unlocks, categories, loading } = useRewardData()
  const cppMode = prefs?.cpp_mode ?? 'default'

  const result = useMemo(() => {
    if (!categorySlug || !userCards.length || loading) {
      return { ranked: [], winner: null, tie: null, subpromptOptions: null }
    }

    const subpromptOptions = getSubpromptOptions(
      categorySlug, userCardIds, unlocks, categories
    )

    const ranked = rankCardsForCategory(userCards, categorySlug, rates, cppMode)
    const winner = ranked[0] ?? null
    const tie = detectTie(ranked)

    return { ranked, winner, tie, subpromptOptions }
  }, [categorySlug, userCards, userCardIds, rates, unlocks, categories, cppMode, loading])

  return { ...result, loading }
}
