import { useState, useRef, useCallback } from 'react'
import { Lock } from 'lucide-react'
import { useNavigate } from 'react-router-dom'
import { useCategories, type CategoryWithLock } from '../hooks/useCategories'
import { useRewardData } from '../hooks/useRewardData'
import { useRewardLookup } from '../hooks/useRewardLookup'
import { useUserStore } from '../store/userStore'
import { getSubpromptOptions } from '../lib/categories'
import { TopNav } from '../components/shared/TopNav'
import { CategoryGrid } from '../components/home/CategoryGrid'
import { SubpromptSheet } from '../components/home/SubpromptSheet'
import { InstallBanner } from '../components/shared/InstallBanner'
import { ResultCard } from '../components/result/ResultCard'
import { RankedList } from '../components/result/RankedList'
import { TiebreakerNote } from '../components/result/TiebreakerNote'
import { LoadingSpinner } from '../components/shared/LoadingSpinner'
import type { SubpromptOption } from '../types/reward'

interface SubpromptState {
  options: SubpromptOption[]
  parentLabel: string
}

type NudgeVariant = 'personalize' | null

export function HomePage() {
  const navigate = useNavigate()
  const { categories, loading } = useCategories()
  const { unlocks, categories: allCategories, banks } = useRewardData()
  const { userCardIds, isGuest } = useUserStore()
  const [subprompt, setSubprompt] = useState<SubpromptState | null>(null)
  const [selectedSlug, setSelectedSlug] = useState<string | null>(null)
  const [resultVisible, setResultVisible] = useState(false)
  const [activeNudge, setActiveNudge] = useState<NudgeVariant>(null)
  const resultRef = useRef<HTMLDivElement>(null)

  const { ranked, winner, tie, loading: resultLoading } = useRewardLookup(selectedSlug)
  const categoryName = allCategories.find(c => c.slug === selectedSlug)?.display_name ?? ''
  const winnerBank = winner ? banks.find(b => b.id === winner.card.bank_id) ?? null : null


  const openResult = useCallback((slug: string) => {
    setResultVisible(false)
    setSelectedSlug(slug)
    requestAnimationFrame(() => {
      setResultVisible(true)
      setTimeout(() => {
        if (resultRef.current) {
          const top = resultRef.current.getBoundingClientRect().top + window.scrollY
          window.scrollTo({ top: top - window.innerHeight * 0.55, behavior: 'smooth' })
        }
      }, 50)

      // Show personalization nudge after 3rd result view for guests (once per session)
      if (isGuest && !sessionStorage.getItem('nudge_shown')) {
        const count = parseInt(sessionStorage.getItem('result_view_count') ?? '0', 10) + 1
        sessionStorage.setItem('result_view_count', String(count))
        if (count >= 3) {
          sessionStorage.setItem('nudge_shown', '1')
          setActiveNudge('personalize')
        }
      }
    })
  }, [isGuest])

  function handleCategoryTap(slug: string) {
    if (slug === selectedSlug) {
      setSelectedSlug(null)
      setResultVisible(false)
      return
    }
    const cat = categories.find(c => c.slug === slug) as CategoryWithLock | undefined
    if (cat?.locked) {
      navigate('/auth')
      return
    }
    const options = getSubpromptOptions(slug, userCardIds, unlocks, allCategories)
    if (options && options.length >= 2) {
      const label = categories.find(c => c.slug === slug)?.display_name ?? slug
      setSubprompt({ options, parentLabel: label })
    } else {
      openResult(slug)
    }
  }

  function handleSubpromptSelect(slug: string) {
    setSubprompt(null)
    openResult(slug)
  }

  function handleNudgeConfirm() {
    setActiveNudge(null)
    navigate('/onboarding')
  }

  function handleNudgeDismiss() {
    setActiveNudge(null)
  }

  return (
    <div className="bg-bg max-w-[480px] mx-auto min-h-dvh pb-24">
      <TopNav showSettings title="Yieldly" />

      {/* Header */}
      <div className="px-4 pt-5 pb-4">
        <h1 className="font-serif text-2xl font-semibold text-text-primary leading-snug">
          Select a Category
        </h1>
        <p className="font-mono text-xs text-muted mt-1">
          Tap a category to see which card earns you the most.
        </p>
      </div>

      {/* Category grid */}
      <CategoryGrid
        categories={categories.filter(c => !c.locked)}
        onSelect={handleCategoryTap}
        loading={loading}
        selectedSlug={selectedSlug}
      />

      {/* Unlock prompt for guests */}
      {isGuest && !loading && (
        <div className="px-4 mt-3">
          <button
            type="button"
            onClick={() => navigate('/auth')}
            className="w-full flex items-center justify-between bg-surface/40 border border-border/40 rounded-xl px-4 py-3 hover:border-accent/30 transition-colors"
          >
            <span className="font-mono text-xs text-muted/50">+9 more categories</span>
            <span className="font-mono text-xs text-accent">Sign in to unlock →</span>
          </button>
        </div>
      )}

      {/* Inline result — slides in below grid, no overlay */}
      {selectedSlug && (
        <div
          ref={resultRef}
          className="transition-opacity duration-200"
          style={{ opacity: resultVisible ? 1 : 0 }}
        >
          {/* Section label */}
          <div className="px-4 pt-8 pb-3">
            <p className="font-mono text-[10px] text-muted uppercase tracking-[0.2em]">
              Best card for {categoryName} →
            </p>
          </div>

          {resultLoading ? (
            <div className="flex items-center justify-center py-12">
              <LoadingSpinner size="md" />
            </div>
          ) : winner ? (
            <>
              <ResultCard result={winner} bank={winnerBank} />
              {tie && <TiebreakerNote tie={tie} />}
              {activeNudge === 'personalize' && (
                <div className="mx-4 mt-4 mb-1 bg-surface border border-accent/20 rounded-xl px-4 py-4">
                  <p className="font-mono text-[10px] text-accent uppercase tracking-[0.18em] mb-1">
                    Popular cards
                  </p>
                  <p className="font-serif text-sm text-text-primary leading-snug mb-3">
                    Have your own cards? Set up your wallet for personalized results.
                  </p>
                  <div className="flex items-center gap-3">
                    <button
                      type="button"
                      onClick={handleNudgeConfirm}
                      className="bg-accent text-bg font-mono text-xs font-medium py-2 px-4 rounded-lg hover:opacity-90 active:opacity-80 transition-opacity"
                    >
                      Personalize →
                    </button>
                    <button
                      type="button"
                      onClick={handleNudgeDismiss}
                      className="font-mono text-xs text-muted hover:text-text-primary transition-colors"
                    >
                      These look fine
                    </button>
                  </div>
                </div>
              )}
              <RankedList results={ranked} isForeignSpending={selectedSlug === 'foreign_spending'} />
            </>
          ) : (
            <div className="px-4 py-10 text-center">
              <p className="font-serif text-lg text-text-primary">No results</p>
              <p className="font-mono text-xs text-muted mt-1">
                None of your cards earn elevated rewards here.
              </p>
            </div>
          )}
        </div>
      )}

      {/* Tools */}
      <div className="mx-4 mt-8 mb-2">
        <p className="font-mono text-[10px] text-muted uppercase tracking-[0.2em] mb-3">Tools</p>
        {isGuest ? (
          <button
            type="button"
            onClick={() => navigate('/auth')}
            className="w-full flex items-center justify-between bg-surface/40 border border-border/40 rounded-xl px-4 py-3 hover:border-accent/30 transition-colors"
          >
            <div className="text-left">
              <p className="font-mono text-xs text-muted/50">Spending Mix & Compare Cards</p>
              <p className="font-mono text-[10px] text-muted/30 mt-0.5">Sign in to unlock</p>
            </div>
            <Lock size={14} className="text-muted/30 flex-shrink-0" />
          </button>
        ) : (
          <div className="grid grid-cols-2 gap-2">
            <button
              type="button"
              onClick={() => navigate('/compare')}
              className="flex flex-col gap-1 bg-surface border border-border rounded-xl px-3 py-3 text-left hover:border-accent/40 transition-colors"
            >
              <span className="font-mono text-xs text-accent">Compare Cards</span>
              <span className="font-mono text-[10px] text-muted leading-snug">Side-by-side across categories</span>
            </button>
            <button
              type="button"
              onClick={() => navigate('/optimize')}
              className="flex flex-col gap-1 bg-surface border border-border rounded-xl px-3 py-3 text-left hover:border-accent/40 transition-colors"
            >
              <span className="font-mono text-xs text-accent">Spending Mix</span>
              <span className="font-mono text-[10px] text-muted leading-snug">Best card for your overall spend</span>
            </button>
          </div>
        )}
      </div>

      {/* Disclaimer */}
      <p className="font-mono text-[10px] text-muted/30 text-center px-6 mt-8 mb-2 leading-relaxed">
        Reward rates are estimates based on publicly available information and may not reflect current issuer terms. Verify rates with your card issuer before making financial decisions.
      </p>

      {/* Subprompt sheet */}
      <SubpromptSheet
        isOpen={subprompt !== null}
        onClose={() => setSubprompt(null)}
        options={subprompt?.options ?? []}
        parentLabel={subprompt?.parentLabel ?? ''}
        onSelect={handleSubpromptSelect}
      />

      <InstallBanner />
    </div>
  )
}
