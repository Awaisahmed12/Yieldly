import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useUserStore } from '../store/userStore'
import { useRewardData } from '../hooks/useRewardData'
import { getGuestCardSlugs, setGuestCardSlugs } from '../lib/guestStorage'
import { OnboardingShell } from '../components/onboarding/OnboardingShell'
import { LoadingSpinner } from '../components/shared/LoadingSpinner'
import { TermsText } from '../components/auth/TermsText'
import type { UserPreferencesRow } from '../types/supabase'

type OnboardingView = 'select' | 'save'

export function OnboardingPage() {
  const navigate = useNavigate()
  useEffect(() => { window.scrollTo(0, 0) }, [])

  const { user, userCardIds, setPrefs, setUserCards, setGuestCards } = useUserStore()
  const { banks, cards, loading } = useRewardData()

  // Pre-populate selections: authed users get their existing cards, guests get localStorage
  const initialSelectedIds = user
    ? userCardIds
    : cards.filter(c => getGuestCardSlugs().includes(c.slug)).map(c => c.id)

  const [view, setView] = useState<OnboardingView>('select')
  const [pendingCardIds, setPendingCardIds] = useState<string[]>([])

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
    // Guest path — show save/continue prompt
    if (!user) {
      setPendingCardIds(selectedCardIds)
      setView('save')
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

  function handleSaveToAccount() {
    const selectedCards = cards.filter((c) => pendingCardIds.includes(c.id))
    setGuestCardSlugs(selectedCards.map((c) => c.slug))
    setGuestCards(selectedCards, true)
    navigate('/auth')
  }

  function handleContinueAsGuest() {
    const selectedCards = cards.filter((c) => pendingCardIds.includes(c.id))
    setGuestCardSlugs(selectedCards.map((c) => c.slug))
    setGuestCards(selectedCards, true)
    navigate('/')
  }

  if (view === 'save') {
    return (
      <div className="min-h-dvh bg-bg flex flex-col items-center justify-center px-5 py-12 max-w-[480px] mx-auto" style={{ paddingTop: 'calc(3rem + env(safe-area-inset-top))' }}>
        <div className="w-full max-w-sm">
          <div className="text-center mb-8">
            <p className="text-accent font-mono text-sm tracking-widest uppercase mb-3">Yieldly</p>
            <h1 className="font-serif text-3xl font-semibold text-text-primary leading-tight">
              Your wallet is ready
            </h1>
            <p className="text-muted font-mono text-xs mt-3 leading-relaxed">
              Save it to a free account and your cards sync across devices — or just keep going.
            </p>
          </div>

          <div className="space-y-3">
            <button
              type="button"
              onClick={handleSaveToAccount}
              className="w-full bg-accent text-bg font-mono font-medium py-3 px-4 rounded-lg text-sm hover:opacity-90 active:opacity-80 transition-opacity"
            >
              Save to account →
            </button>
            <button
              type="button"
              onClick={handleContinueAsGuest}
              className="w-full bg-surface border border-border font-mono text-sm text-muted py-3 px-4 rounded-lg hover:text-text-primary hover:border-accent/30 transition-colors"
            >
              Continue as guest
            </button>
          </div>

          <div className="mt-8">
            <TermsText />
          </div>
        </div>
      </div>
    )
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
