import { useState, useRef, useCallback } from 'react'
import { Search, X } from 'lucide-react'
import { useNavigate } from 'react-router-dom'
import { useCategories } from '../hooks/useCategories'
import { useRewardData } from '../hooks/useRewardData'
import { useRewardLookup } from '../hooks/useRewardLookup'
import { useUserStore } from '../store/userStore'
import { getSubpromptOptions, orderByUsage } from '../lib/categories'
import { searchCategorySlugs } from '../lib/categorySearch'
import { TopNav } from '../components/shared/TopNav'
import { CategoryGrid } from '../components/home/CategoryGrid'
import { SubpromptSheet } from '../components/home/SubpromptSheet'
import { InstallBanner } from '../components/shared/InstallBanner'
import { useCategoryUsage } from '../hooks/useCategoryUsage'
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
  const navigate = useNavigate()
  const { categories, loading } = useCategories()
  const { unlocks, categories: allCategories, banks } = useRewardData()
  const { userCardIds } = useUserStore()
  const { usage, recordTap } = useCategoryUsage()
  const [searchQuery, setSearchQuery] = useState('')
  const [subprompt, setSubprompt] = useState<SubpromptState | null>(null)
  const [selectedSlug, setSelectedSlug] = useState<string | null>(null)
  const [resultVisible, setResultVisible] = useState(false)
  const resultRef = useRef<HTMLDivElement>(null)

  const visibleCategories = categories.filter(c => !c.locked)
  const filteredCategories = searchQuery.trim()
    ? (() => {
        const matchedSlugs = searchCategorySlugs(searchQuery)
        if (matchedSlugs.length === 0) return []
        const matched = visibleCategories.filter(c => matchedSlugs.includes(c.slug))
        // other always last
        matched.sort((a, b) => {
          if (a.slug === 'other') return 1
          if (b.slug === 'other') return -1
          return matchedSlugs.indexOf(a.slug) - matchedSlugs.indexOf(b.slug)
        })
        return matched
      })()
    : orderByUsage(visibleCategories, usage)

  const { ranked, winner, tie, loading: resultLoading } = useRewardLookup(selectedSlug)
  const categoryName = allCategories.find(c => c.slug === selectedSlug)?.display_name ?? ''
  const winnerBank = winner ? banks.find(b => b.id === winner.card.bank_id) ?? null : null


  const openResult = useCallback((slug: string) => {
    recordTap(slug)
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
    })
  }, [recordTap])

  function handleCategoryTap(slug: string) {
    if (slug === selectedSlug) {
      setSelectedSlug(null)
      setResultVisible(false)
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

  return (
    <div className="bg-bg max-w-[480px] mx-auto min-h-dvh pb-24">
      <TopNav showSettings title="Yieldly" />

      {/* Header */}
      <div className="px-4 pt-5 pb-3">
        <h1 className="font-serif text-2xl font-semibold text-text-primary leading-snug">
          Select a Category
        </h1>
        <p className="font-mono text-xs text-muted mt-1">
          Tap a category to see which card earns you the most.
        </p>
      </div>

      {/* Search */}
      <div className="px-4 pb-4">
        <div className="relative flex items-center">
          <Search size={14} className="absolute left-3 text-muted/50 pointer-events-none" />
          <input
            type="text"
            value={searchQuery}
            onChange={e => setSearchQuery(e.target.value)}
            placeholder="Search or type a store, activity…"
            className="w-full bg-surface border border-border rounded-xl pl-9 pr-9 py-2.5 font-mono text-xs text-text-primary placeholder:text-muted/40 focus:outline-none focus:border-accent/50 transition-colors"
          />
          {searchQuery && (
            <button
              type="button"
              onClick={() => setSearchQuery('')}
              className="absolute right-3 text-muted/50 hover:text-muted transition-colors"
            >
              <X size={14} />
            </button>
          )}
        </div>
      </div>

      {/* Category grid */}
      <CategoryGrid
        categories={filteredCategories}
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
