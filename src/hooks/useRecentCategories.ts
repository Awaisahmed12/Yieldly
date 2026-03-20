import { useState, useCallback } from 'react'

const KEY = 'yieldly_recent'
const MAX = 5

function readRecent(): string[] {
  try {
    const raw = localStorage.getItem(KEY)
    return raw ? (JSON.parse(raw) as string[]) : []
  } catch {
    return []
  }
}

export function useRecentCategories() {
  const [recentSlugs, setRecentSlugs] = useState<string[]>(readRecent)

  const addRecent = useCallback((slug: string) => {
    setRecentSlugs(prev => {
      const next = [slug, ...prev.filter(s => s !== slug)].slice(0, MAX)
      try { localStorage.setItem(KEY, JSON.stringify(next)) } catch { /* ignore */ }
      return next
    })
  }, [])

  return { recentSlugs, addRecent }
}
