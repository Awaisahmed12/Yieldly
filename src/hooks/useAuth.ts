import { useEffect } from 'react'
import { supabase } from '../lib/supabase'
import { useUserStore } from '../store/userStore'
import type { UserPreferencesRow } from '../types/supabase'

export function useAuth() {
  const { user, session, loading, setSession, setUser, setUserCards, setPrefs, setLoading } =
    useUserStore()

  useEffect(() => {
    let mounted = true

    async function loadUserData(userId: string) {
      try {
        console.log('[useAuth] fetching user_cards…')
        const { data: userCardRows, error: cardsError } = await supabase
          .from('user_cards')
          .select('card_id, cards(*)')
          .eq('user_id', userId)

        if (cardsError) console.error('[useAuth] user_cards error:', cardsError)
        else console.log('[useAuth] user_cards rows:', userCardRows?.length ?? 0)

        if (mounted && userCardRows) {
          const cards = userCardRows
            .map((row) => (row as { card_id: string; cards: unknown }).cards)
            .filter(Boolean) as Parameters<typeof setUserCards>[0]
          setUserCards(cards)
        }

        console.log('[useAuth] fetching user_preferences…')
        const { data: existingPrefs, error: prefsError } = await supabase
          .from('user_preferences')
          .select('*')
          .eq('user_id', userId)
          .single()

        if (prefsError) console.error('[useAuth] user_preferences error:', prefsError)
        else console.log('[useAuth] prefs:', existingPrefs)

        if (mounted) {
          if (existingPrefs) {
            setPrefs(existingPrefs as UserPreferencesRow)
          } else {
            console.log('[useAuth] creating default prefs…')
            const { data: newPrefs, error: insertError } = await supabase
              .from('user_preferences')
              .insert({
                user_id: userId,
                onboarding_complete: false,
                cpp_mode: 'default' as const,
              })
              .select()
              .single()
            if (insertError) console.error('[useAuth] insert prefs error:', insertError)
            if (newPrefs) setPrefs(newPrefs as UserPreferencesRow)
          }
        }
      } catch (err) {
        console.error('[useAuth] loadUserData threw:', err)
      }
    }

    // Get initial session
    console.log('[useAuth] calling getSession…')
    supabase.auth.getSession().then(({ data: { session } }) => {
      console.log('[useAuth] getSession resolved, user:', session?.user?.id ?? 'none')
      if (!mounted) return
      setSession(session)
      setUser(session?.user ?? null)
      if (session?.user) {
        console.log('[useAuth] loading user data…')
        loadUserData(session.user.id).finally(() => {
          console.log('[useAuth] loadUserData done, clearing loading')
          if (mounted) setLoading(false)
        })
      } else {
        console.log('[useAuth] no session, clearing loading')
        setLoading(false)
      }
    }).catch((err) => {
      console.error('[useAuth] getSession failed:', err)
      if (mounted) setLoading(false)
    })

    // Subscribe to auth state changes
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      if (!mounted) return
      setSession(session)
      setUser(session?.user ?? null)
      if (session?.user) {
        setLoading(true)
        loadUserData(session.user.id).finally(() => {
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
