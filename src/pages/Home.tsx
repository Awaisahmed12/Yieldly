import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useCategories } from '../hooks/useCategories'
import { useRewardData } from '../hooks/useRewardData'
import { useUserStore } from '../store/userStore'
import { getSubpromptOptions } from '../lib/categories'
import { TopNav } from '../components/shared/TopNav'
import { CategoryGrid } from '../components/home/CategoryGrid'
import { SubpromptSheet } from '../components/home/SubpromptSheet'
import { InstallBanner } from '../components/shared/InstallBanner'
import type { SubpromptOption } from '../types/reward'

interface SubpromptState {
  options: SubpromptOption[]
  parentLabel: string
}

export function HomePage() {
  const navigate = useNavigate()
  const { categories, loading } = useCategories()
  const { unlocks, categories: allCategories } = useRewardData()
  const { userCardIds } = useUserStore()
  const [subprompt, setSubprompt] = useState<SubpromptState | null>(null)

  function handleCategoryTap(slug: string) {
    const category = categories.find(c => c.slug === slug)
    const label = category?.display_name ?? slug

    const options = getSubpromptOptions(slug, userCardIds, unlocks, allCategories)
    if (options && options.length >= 2) {
      setSubprompt({ options, parentLabel: label })
    } else {
      navigate(`/result/${slug}`)
    }
  }

  function handleSubpromptSelect(slug: string) {
    navigate(`/result/${slug}`)
  }

  return (
    <div className="min-h-dvh bg-bg flex flex-col max-w-[480px] mx-auto">
      <TopNav showSettings title="Yield" />

      {/* Eyebrow */}
      <div className="px-4 pt-5 pb-4 flex-shrink-0">
        <h1 className="font-serif text-2xl font-semibold text-text-primary leading-snug">
          Where are you spending?
        </h1>
      </div>

      {/* Category grid */}
      <div className="flex-1 pb-20">
        <CategoryGrid
          categories={categories}
          onSelect={handleCategoryTap}
          loading={loading}
        />
      </div>

      {/* Subprompt sheet */}
      <SubpromptSheet
        isOpen={subprompt !== null}
        onClose={() => setSubprompt(null)}
        options={subprompt?.options ?? []}
        parentLabel={subprompt?.parentLabel ?? ''}
        onSelect={handleSubpromptSelect}
      />

      {/* Install banner */}
      <InstallBanner />
    </div>
  )
}
