import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useUserStore } from '../store/userStore'
import { setGuestCardSlugs } from '../lib/guestStorage'
import { useRewardData } from '../hooks/useRewardData'
import { TopNav } from '../components/shared/TopNav'
import { CardManager } from '../components/settings/CardManager'
import { AddCardSheet } from '../components/settings/AddCardSheet'
import type { CppMode } from '../types/reward'
import type { UserPreferencesRow } from '../types/supabase'

const CPP_MODES: { value: CppMode; label: string; description: string }[] = [
  {
    value: 'conservative',
    label: 'Conservative',
    description: 'Uses minimum point valuations. Best if you mostly redeem for gift cards or statement credits.',
  },
  {
    value: 'default',
    label: 'Default',
    description: 'Balanced valuations based on typical redemption patterns.',
  },
  {
    value: 'optimistic',
    label: 'Optimistic',
    description: 'Uses higher point valuations for transfer partners. Best if you redeem for premium travel.',
  },
]

export function SettingsPage() {
  const navigate = useNavigate()
  const { user, userCards, prefs, setPrefs, setUserCards, setGuestCards, isGuest, reset } = useUserStore()
  const { banks, cards: allCards } = useRewardData()
  const [showAddSheet, setShowAddSheet] = useState(false)
  const [advancedOpen, setAdvancedOpen] = useState(false)
  const [, setRemovingId] = useState<string | null>(null)

  const cppMode = prefs?.cpp_mode ?? 'default'

  async function handleRemoveCard(cardId: string) {
    if (!window.confirm('Remove this card?')) return

    if (isGuest) {
      const updated = userCards.filter(c => c.id !== cardId)
      setGuestCardSlugs(updated.map(c => c.slug))
      setGuestCards(updated, true)
      return
    }

    if (!user) return
    setRemovingId(cardId)
    try {
      await supabase
        .from('user_cards')
        .delete()
        .eq('user_id', user.id)
        .eq('card_id', cardId)

      setUserCards(userCards.filter(c => c.id !== cardId))
    } catch (err) {
      console.error('Error removing card:', err)
    } finally {
      setRemovingId(null)
    }
  }

  async function handleAddCards(newCardIds: string[]) {
    if (newCardIds.length === 0) return

    if (isGuest) {
      const newCards = allCards.filter(c => newCardIds.includes(c.id))
      const updated = [...userCards, ...newCards]
      setGuestCardSlugs(updated.map(c => c.slug))
      setGuestCards(updated, true)
      return
    }

    if (!user) return
    try {
      await supabase
        .from('user_cards')
        .insert(newCardIds.map(cardId => ({ user_id: user.id, card_id: cardId })))

      const newCards = allCards.filter(c => newCardIds.includes(c.id))
      setUserCards([...userCards, ...newCards])
    } catch (err) {
      console.error('Error adding cards:', err)
    }
  }

  async function handleCppModeChange(mode: CppMode) {
    if (!user) return

    try {
      const { data } = await supabase
        .from('user_preferences')
        .upsert({
          user_id: user.id,
          cpp_mode: mode,
        })
        .select()
        .single()

      if (data) setPrefs(data as UserPreferencesRow)
    } catch (err) {
      console.error('Error updating cpp mode:', err)
    }
  }

  async function handleSignOut() {
    navigate('/auth')
    reset()
    supabase.auth.signOut({ scope: 'local' })
  }

  async function handleDeleteAccount() {
    if (!user) return
    if (!window.confirm('Permanently delete your account and all data? This cannot be undone.')) return

    try {
      await supabase.from('user_cards').delete().eq('user_id', user.id)
      await supabase.from('user_preferences').delete().eq('user_id', user.id)
      await supabase.auth.signOut({ scope: 'local' })
      reset()
      navigate('/auth')
    } catch (err) {
      console.error('Error deleting account:', err)
      window.alert('Something went wrong. Email ahmedawais672@gmail.com to request deletion.')
    }
  }

  const ownedCardIds = userCards.map(c => c.id)

  return (
    <div className="min-h-dvh bg-bg flex flex-col max-w-[480px] mx-auto">
      <TopNav showBack title="Settings" />

      <div className="flex-1 overflow-y-auto pb-10">
        {/* Card Manager */}
        <div className="mt-4 mx-4 bg-surface border border-border rounded-xl overflow-hidden">
          <CardManager
            cards={userCards}
            onAddCards={() => setShowAddSheet(true)}
            onRemoveCard={handleRemoveCard}
          />
        </div>

        {/* Advanced section */}
        <div className="mt-4 mx-4">
          <button
            type="button"
            onClick={() => setAdvancedOpen(prev => !prev)}
            className="w-full flex items-center justify-between px-4 py-3.5 bg-surface border border-border rounded-xl hover:bg-white/5 transition-colors"
          >
            <span className="font-mono text-sm text-text-primary">Advanced</span>
            <svg
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              className={`text-muted transition-transform duration-200 ${advancedOpen ? 'rotate-180' : ''}`}
            >
              <path d="m6 9 6 6 6-6" />
            </svg>
          </button>

          {advancedOpen && (
            <div className="mt-2 bg-surface border border-border rounded-xl overflow-hidden">
              <div className="px-4 pt-4 pb-3">
                <p className="font-mono text-xs text-muted uppercase tracking-widest mb-1">
                  Points Valuation Mode
                </p>
                <p className="font-mono text-xs text-muted/70 leading-relaxed mb-4">
                  Controls how we estimate the value of points and miles. Only affects cards with transferable points.
                </p>

                <div className="space-y-2">
                  {CPP_MODES.map(mode => (
                    <button
                      key={mode.value}
                      type="button"
                      onClick={() => handleCppModeChange(mode.value)}
                      className={`w-full flex items-start gap-3 px-3 py-3 rounded-lg border transition-colors text-left ${
                        cppMode === mode.value
                          ? 'border-accent/50 bg-accent/5'
                          : 'border-border hover:border-border/80'
                      }`}
                    >
                      {/* Radio indicator */}
                      <div
                        className={`w-4 h-4 rounded-full border-2 flex-shrink-0 mt-0.5 flex items-center justify-center ${
                          cppMode === mode.value ? 'border-accent' : 'border-border'
                        }`}
                      >
                        {cppMode === mode.value && (
                          <div className="w-2 h-2 rounded-full bg-accent" />
                        )}
                      </div>
                      <div>
                        <p className={`font-mono text-sm font-medium ${cppMode === mode.value ? 'text-accent' : 'text-text-primary'}`}>
                          {mode.label}
                        </p>
                        <p className="font-mono text-xs text-muted leading-snug mt-0.5">
                          {mode.description}
                        </p>
                      </div>
                    </button>
                  ))}
                </div>
              </div>
            </div>
          )}
        </div>

        {isGuest ? (
          <div className="mt-6 mx-4">
            <button
              type="button"
              onClick={() => navigate('/auth')}
              className="w-full font-mono text-sm text-accent hover:opacity-80 transition-opacity py-3 border border-accent/30 rounded-xl"
            >
              Sign in to sync across devices →
            </button>
          </div>
        ) : (
          <>
            {/* Sign out */}
            <div className="mt-6 mx-4">
              <button
                type="button"
                onClick={handleSignOut}
                className="w-full font-mono text-sm text-muted hover:text-red-400 transition-colors py-3 border border-border rounded-xl hover:border-red-400/30"
              >
                Sign out
              </button>
            </div>

            {/* Delete account */}
            <div className="mt-3 mx-4">
              <button
                type="button"
                onClick={handleDeleteAccount}
                className="w-full font-mono text-sm text-red-500/50 hover:text-red-400 transition-colors py-3 border border-red-500/10 rounded-xl hover:border-red-400/30"
              >
                Delete account
              </button>
            </div>
          </>
        )}

        {/* App version / info */}
        <p className="font-mono text-xs text-muted/40 text-center mt-6">
          Yieldly · Rewards Optimizer
        </p>
      </div>

      {/* Add card sheet */}
      <AddCardSheet
        isOpen={showAddSheet}
        onClose={() => setShowAddSheet(false)}
        onAdd={handleAddCards}
        banks={banks}
        allCards={allCards}
        ownedCardIds={ownedCardIds}
      />
    </div>
  )
}
