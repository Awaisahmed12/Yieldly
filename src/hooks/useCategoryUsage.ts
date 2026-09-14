import { useState, useCallback } from 'react'
import type { CategoryUsage } from '../lib/categories'

const KEY = 'yieldly_category_taps'
const LEGACY_KEY = 'yieldly_recent'

function readUsage(): CategoryUsage {
  try {
    const raw = localStorage.getItem(KEY)
    if (raw) return JSON.parse(raw) as CategoryUsage
    // One-time migration from the old "recents" list: give each a small head start,
    // most recent first, so the previous order survives.
    const legacy = localStorage.getItem(LEGACY_KEY)
    if (legacy) {
      const slugs = JSON.parse(legacy) as string[]
      const seeded: CategoryUsage = {}
      slugs.forEach((slug, i) => { seeded[slug] = { count: slugs.length - i, last: Date.now() } })
      localStorage.setItem(KEY, JSON.stringify(seeded))
      localStorage.removeItem(LEGACY_KEY)
      return seeded
    }
  } catch { /* ignore */ }
  return {}
}

/**
 * Tracks how often (and how recently) each category is tapped so the home grid
 * can promote a user's favourites. `usage` is a snapshot from page load: tiles
 * keep their order for the session and new taps take effect on the next visit,
 * so nothing jumps under the user's finger.
 */
export function useCategoryUsage() {
  const [usage] = useState<CategoryUsage>(readUsage)

  const recordTap = useCallback((slug: string) => {
    try {
      const current = JSON.parse(localStorage.getItem(KEY) ?? '{}') as CategoryUsage
      const prev = current[slug]
      current[slug] = { count: (prev?.count ?? 0) + 1, last: Date.now() }
      localStorage.setItem(KEY, JSON.stringify(current))
    } catch { /* ignore */ }
  }, [])

  return { usage, recordTap }
}
