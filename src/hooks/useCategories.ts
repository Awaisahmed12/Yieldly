import { useMemo } from 'react'
import { useUserStore } from '../store/userStore'
import { useRewardData } from './useRewardData'
import {
  getUnlockedCategorySlugs,
  filterRelevantCategories,
  GUEST_CATEGORY_SLUGS,
} from '../lib/categories'
import type { CategoryRow } from '../types/reward'

export interface CategoryWithLock extends CategoryRow {
  locked: boolean
}

export function useCategories(): { categories: CategoryWithLock[]; loading: boolean } {
  const { userCardIds, isGuest } = useUserStore()
  const { categories, rates, unlocks, loading } = useRewardData()

  const visibleCategories = useMemo(() => {
    if (!userCardIds.length) return []

    const unlockedSlugs = getUnlockedCategorySlugs(userCardIds, unlocks)
    const relevantSlugs = filterRelevantCategories(unlockedSlugs, userCardIds, rates)

    return categories
      .filter(c => relevantSlugs.includes(c.slug))
      .map(c => ({
        ...c,
        locked: isGuest && !GUEST_CATEGORY_SLUGS.includes(c.slug),
      }))
  }, [userCardIds, categories, rates, unlocks, isGuest])

  return { categories: visibleCategories, loading }
}
