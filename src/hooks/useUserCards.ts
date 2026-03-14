import { useEffect } from 'react'
import { supabase } from '../lib/supabase'
import { useUserStore } from '../store/userStore'
import type { CardRow } from '../types/reward'

export function useUserCards() {
  const { user, setUserCards } = useUserStore()

  useEffect(() => {
    if (!user) return

    async function fetchUserCards() {
      const { data, error } = await supabase
        .from('user_cards')
        .select('card_id, cards(*)')
        .eq('user_id', user!.id)

      if (error) {
        console.error('Failed to fetch user cards:', error)
        return
      }

      const cards: CardRow[] = (data ?? [])
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        .map((row: any) => row.cards)
        .filter(Boolean)

      setUserCards(cards)
    }

    fetchUserCards()
  }, [user, setUserCards])
}
