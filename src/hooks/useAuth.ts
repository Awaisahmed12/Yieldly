import { useEffect } from 'react'
import { supabase } from '../lib/supabase'
import { useUserStore } from '../store/userStore'
import { migrateGuestCards } from '../lib/migration'
import { clearGuestCardSlugs } from '../lib/guestStorage'
import type { UserPreferencesRow } from '../types/supabase'

export function useAuth() {
  const { user, session, loading, setSession, setUser, setUserCards, setPrefs, setLoading } =
    useUserStore()

  useEffect(() => {
    let mounted = true

    async function loadUserData(userId: string) {
      try {
        const { data: userCardRows } = await supabase
          .from('user_cards')
          .select('card_id, cards(*)')
          .eq('user_id', userId)

        if (mounted && userCardRows) {
          const cards = userCardRows
            .map((row) => (row as { card_id: string; cards: unknown }).cards)
            .filter(Boolean) as Parameters<typeof setUserCards>[0]
          setUserCards(cards)
        }

        const { data: existingPrefs } = await supabase
          .from('user_preferences')
          .select('*')
          .eq('user_id', userId)
          .single()

        if (mounted) {
          if (existingPrefs) {
            setPrefs(existingPrefs as UserPreferencesRow)
          } else {
            const { data: newPrefs } = await supabase
              .from('user_preferences')
              .insert({
                user_id: userId,
                onboarding_complete: false,
                cpp_mode: 'default' as const,
              })
              .select()
              .single()
            if (newPrefs) setPrefs(newPrefs as UserPreferencesRow)
          }
        }
      } catch {
        // Silently handle errors — store stays empty
      }
    }

    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (!mounted) return
      setSession(session)
      setUser(session?.user ?? null)
      if (session?.user) {
        loadUserData(session.user.id).finally(() => {
          if (mounted) setLoading(false)
        })
      } else {
        setLoading(false)
      }
    }).catch((err) => {
      console.error('[useAuth] getSession failed:', err)
      if (mounted) setLoading(false)
    })

    // Subscribe to auth state changes
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((event, session) => {
      if (!mounted) return
      setSession(session)
      setUser(session?.user ?? null)
      if (session?.user) {
        setLoading(true)
        const { isGuest, hasCustomizedCards, userCardIds, clearGuest } = useUserStore.getState()

        const runLoad = async () => {
          if (event === 'SIGNED_IN' && isGuest && hasCustomizedCards && userCardIds.length > 0) {
            try {
              await migrateGuestCards(session.user.id, userCardIds)
              clearGuestCardSlugs()
              clearGuest()
            } catch (err) {
              console.error('[useAuth] guest migration failed:', err)
            }
          }
          await loadUserData(session.user.id)
        }

        runLoad().finally(() => {
          if (mounted) setLoading(false)
        })
      } else {
        useUserStore.getState().reset()
        setLoading(false)
      }
    })

    return () => {
      mounted = false
      subscription.unsubscribe()
    }
  }, [setSession, setUser, setUserCards, setPrefs, setLoading])

  return { user, session, loading }
}
