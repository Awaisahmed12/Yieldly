import { useState, useRef, useCallback } from 'react'
import { useCategories } from '../hooks/useCategories'
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

export function HomePage() {
  const { categories, loading } = useCategories()
  const { unlocks, categories: allCategories, banks } = useRewardData()
  const { userCardIds } = useUserStore()
  const [subprompt, setSubprompt] = useState<SubpromptState | null>(null)
  const [selectedSlug, setSelectedSlug] = useState<string | null>(null)
  const [resultVisible, setResultVisible] = useState(false)
  const resultRef = useRef<HTMLDivElement>(null)

  const { ranked, winner, tie, loading: resultLoading } = useRewardLookup(selectedSlug)
  const categoryName = allCategories.find(c => c.slug === selectedSlug)?.display_name ?? ''
  const winnerBank = winner ? banks.find(b => b.id === winner.card.bank_id) ?? null : null

  const openResult = useCallback((slug: string) => {
    setResultVisible(false)
    setSelectedSlug(slug)
    requestAnimationFrame(() => {
      setResultVisible(true)
      // Scroll so the label + top of the winner card peek into view — user scrolls for the rest
      setTimeout(() => {
        if (resultRef.current) {
          const top = resultRef.current.getBoundingClientRect().top + window.scrollY
          window.scrollTo({ top: top - window.innerHeight * 0.55, behavior: 'smooth' })
        }
      }, 50)
    })
  }, [])

  function handleCategoryTap(slug: string) {
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

  return (
    <div className="bg-bg max-w-[480px] mx-auto min-h-dvh pb-24">
      <TopNav showSettings title="Yield" />

      {/* Header */}
      <div className="px-4 pt-5 pb-4">
        <p className="font-mono text-[10px] text-muted uppercase tracking-[0.2em] mb-1">
        </p>
        <h1 className="font-serif text-2xl font-semibold text-text-primary leading-snug">
          Select a Category
        </h1>
      </div>

      {/* Category grid */}
      <CategoryGrid
        categories={categories}
        onSelect={handleCategoryTap}
        loading={loading}
        selectedSlug={selectedSlug}
      />

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
              <RankedList results={ranked} />
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
