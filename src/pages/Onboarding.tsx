import { useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useUserStore } from '../store/userStore'
import { useRewardData } from '../hooks/useRewardData'
import { setGuestCardSlugs } from '../lib/guestStorage'
import { OnboardingShell } from '../components/onboarding/OnboardingShell'
import { LoadingSpinner } from '../components/shared/LoadingSpinner'
import type { UserPreferencesRow } from '../types/supabase'

export function OnboardingPage() {
  const navigate = useNavigate()
  useEffect(() => { window.scrollTo(0, 0) }, [])

  const { user, setPrefs, setUserCards, setGuestCards } = useUserStore()
  const isGuest = useUserStore((s) => s.isGuest)
  const { banks, cards, loading } = useRewardData()

  async function handleSkip() {
    if (!user) return

    const { data } = await supabase
      .from('user_preferences')
      .upsert({ user_id: user.id, onboarding_complete: true, cpp_mode: 'default' as const })
      .select()
      .single()

    if (data) setPrefs(data as UserPreferencesRow)
    navigate('/')
  }

  async function handleComplete(selectedCardIds: string[]) {
    // Guest path — save to localStorage, no DB
    if (!user) {
      const selectedCards = cards.filter((c) => selectedCardIds.includes(c.id))
      setGuestCardSlugs(selectedCards.map((c) => c.slug))
      setGuestCards(selectedCards, true)
      navigate('/')
      return
    }

    // Authenticated path
    try {
      await supabase
        .from('user_cards')
        .delete()
        .eq('user_id', user.id)

      if (selectedCardIds.length > 0) {
        await supabase
          .from('user_cards')
          .insert(selectedCardIds.map(cardId => ({ user_id: user.id, card_id: cardId })))
      }

      const { data: prefsData } = await supabase
        .from('user_preferences')
        .upsert({
          user_id: user.id,
          onboarding_complete: true,
          cpp_mode: 'default' as const,
        })
        .select()
        .single()

      if (prefsData) setPrefs(prefsData as UserPreferencesRow)

      const selectedCards = cards.filter(c => selectedCardIds.includes(c.id))
      setUserCards(selectedCards)

      navigate('/')
    } catch (err) {
      console.error('Error completing onboarding:', err)
    }
  }

  return (
    <div className="min-h-dvh bg-bg">
      {/* Skip link — only shown for authenticated users */}
      {user && (
        <div className="absolute top-4 right-4 z-10">
          <button
            type="button"
            onClick={handleSkip}
            className="font-mono text-xs text-muted hover:text-text-primary transition-colors"
          >
            Skip for now
          </button>
        </div>
      )}

      {/* Back link for guests */}
      {isGuest && (
        <div className="absolute top-4 left-4 z-10">
          <button
            type="button"
            onClick={() => navigate('/')}
            className="font-mono text-xs text-muted hover:text-text-primary transition-colors"
          >
            ← Back
          </button>
        </div>
      )}

      {loading ? (
        <div className="min-h-dvh flex flex-col items-center justify-center gap-4">
          <LoadingSpinner size="md" />
          <p className="font-mono text-sm text-muted">Loading cards...</p>
        </div>
      ) : (
        <OnboardingShell
          banks={banks}
          cards={cards}
          onComplete={handleComplete}
        />
      )}
    </div>
  )
}
