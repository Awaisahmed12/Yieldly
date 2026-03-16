import { useEffect } from 'react'
import { useUserStore } from '../store/userStore'
import { useRewardData } from './useRewardData'
import { getGuestCardSlugs, DEFAULT_CARD_SLUGS } from '../lib/guestStorage'

export function useGuestCardSync() {
  const user = useUserStore((s) => s.user)
  const loading = useUserStore((s) => s.loading)
  const setGuestCards = useUserStore((s) => s.setGuestCards)
  const { cards, loading: dataLoading } = useRewardData()

  useEffect(() => {
    if (loading || dataLoading || user) return

    const storedSlugs = getGuestCardSlugs()
    const slugsToUse = storedSlugs.length > 0 ? storedSlugs : DEFAULT_CARD_SLUGS
    const hydratedCards = cards.filter((c) => slugsToUse.includes(c.slug))
    setGuestCards(hydratedCards, storedSlugs.length > 0)
  }, [user, loading, dataLoading, cards, setGuestCards])
}
