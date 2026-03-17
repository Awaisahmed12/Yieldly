import { useState } from 'react'

const KEY = 'seen_intro'

export function useIntroSeen() {
  const [seen, setSeen] = useState(() => !!localStorage.getItem(KEY))

  function markSeen() {
    localStorage.setItem(KEY, '1')
    setSeen(true)
  }

  return { seen, markSeen }
}
