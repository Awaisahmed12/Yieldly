import { useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useUserStore } from '../store/userStore'
import { useRewardData } from '../hooks/useRewardData'
import { getGuestCardSlugs, setGuestCardSlugs, clearGuestCardSlugs } from '../lib/guestStorage'
import { OnboardingShell } from '../components/onboarding/OnboardingShell'
import { LoadingSpinner } from '../components/shared/LoadingSpinner'
import type { UserPreferencesRow } from '../types/supabase'

export function OnboardingPage() {
  const navigate = useNavigate()
  useEffect(() => { window.scrollTo(0, 0) }, [])

  const { user, userCardIds, setPrefs, setUserCards, setGuestCards } = useUserStore()
  const { banks, cards, loading } = useRewardData()

  // Pre-populate selections:
  // - Authed users with DB cards → use those
  // - Authed users with no DB cards (fresh signup) → fall back to localStorage guest cards
  // - Guests → localStorage
  const guestSlugIds = cards.filter(c => getGuestCardSlugs().includes(c.slug)).map(c => c.id)
  const initialSelectedIds = user
    ? (userCardIds.length > 0 ? userCardIds : guestSlugIds)
    : guestSlugIds

  async function handleSkip() {
    if (!user) return

    const { data } = await supabase
      .from('user_preferences')
      .upsert({ user_id: user.id, onboarding_complete: true, cpp_mode: 'default' as const })
      .select()
      .single()

    if (data) setPrefs(data as UserPreferencesRow)
    clearGuestCardSlugs()
    navigate('/')
  }

  async function handleComplete(selectedCardIds: string[]) {
    // Guest path — save to localStorage and go home
    if (!user) {
      const selectedCards = cards.filter(c => selectedCardIds.includes(c.id))
      setGuestCardSlugs(selectedCards.map(c => c.slug))
      setGuestCards(selectedCards, true)
      navigate('/')
      return
    }

    // Authenticated path — save to DB
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

      clearGuestCardSlugs()
      navigate('/')
    } catch (err) {
      console.error('Error completing onboarding:', err)
    }
  }

  return (
    <div className="min-h-dvh bg-bg">
      {/* Skip — authenticated users only */}
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

      {/* Sign in — guests only */}
      {!user && (
        <div className="absolute top-4 right-4 z-10">
          <button
            type="button"
            onClick={() => navigate('/auth')}
            className="font-mono text-xs text-muted hover:text-text-primary transition-colors"
          >
            Sign in →
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
          initialSelectedIds={initialSelectedIds}
          onComplete={handleComplete}
        />
      )}
    </div>
  )
}
