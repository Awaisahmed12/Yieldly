import { useMemo } from 'react'
import { useUserStore } from '../store/userStore'
import { useRewardData } from './useRewardData'
import {
  getUnlockedCategorySlugs,
  filterRelevantCategories,
} from '../lib/categories'
import type { CategoryRow } from '../types/reward'

export interface CategoryWithMeta extends CategoryRow {
  isRelevant: boolean
}

export function useCategories(): { categories: CategoryRow[]; loading: boolean } {
  const { userCardIds } = useUserStore()
  const { categories, rates, unlocks, loading } = useRewardData()

  const visibleCategories = useMemo(() => {
    if (!userCardIds.length) return []

    const unlockedSlugs = getUnlockedCategorySlugs(userCardIds, unlocks)
    const relevantSlugs = filterRelevantCategories(unlockedSlugs, userCardIds, rates)

    return categories.filter(c => relevantSlugs.includes(c.slug))
  }, [userCardIds, categories, rates, unlocks])

  return { categories: visibleCategories, loading }
}
