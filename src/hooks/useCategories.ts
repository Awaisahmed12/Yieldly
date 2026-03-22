import { useMemo } from 'react'
import { useUserStore } from '../store/userStore'
import { useRewardData } from './useRewardData'
import {
  getUnlockedCategorySlugs,
  filterRelevantCategories,
} from '../lib/categories'
import { rankCardsForCategory } from '../lib/rewards'
import type { CategoryRow } from '../types/reward'

export interface CategoryWithLock extends CategoryRow {
  locked: boolean
}

export function useCategories(): { categories: CategoryWithLock[]; loading: boolean } {
  const { userCardIds, userCards, prefs } = useUserStore()
  const { categories, rates, unlocks, loading } = useRewardData()
  const cppMode = prefs?.cpp_mode ?? 'default'

  const visibleCategories = useMemo(() => {
    if (!userCardIds.length) return []

    const unlockedSlugs = getUnlockedCategorySlugs(userCardIds, unlocks)
    const relevantSlugs = filterRelevantCategories(unlockedSlugs, userCardIds, rates)

    type Enriched = CategoryWithLock & { _cpd: number }

    const enriched: Enriched[] = categories
      .filter(c => relevantSlugs.includes(c.slug))
      .map(c => {
        const locked = false

        let _cpd = 0

        if (!locked && userCards.length > 0 && c.slug !== 'other') {
          const ranked = rankCardsForCategory(userCards, c.slug, rates, cppMode)
          const best = ranked[0]
          if (best) _cpd = best.effectiveCpd
        }

        return { ...c, locked, _cpd }
      })

    // Sort by best CPD descending; other always last
    enriched.sort((a, b) => {
      if (a.slug === 'other') return 1
      if (b.slug === 'other') return -1
      return b._cpd - a._cpd
    })

    return enriched.map(({ _cpd: _ignored, ...rest }): CategoryWithLock => rest)
  }, [userCardIds, userCards, categories, rates, unlocks, cppMode])

  return { categories: visibleCategories, loading }
}
