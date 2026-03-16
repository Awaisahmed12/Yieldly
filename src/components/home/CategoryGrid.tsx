import { CategoryTile } from './CategoryTile'
import type { CategoryWithLock } from '../../hooks/useCategories'

interface CategoryGridProps {
  categories: CategoryWithLock[]
  onSelect: (slug: string) => void
  loading?: boolean
  selectedSlug?: string | null
}

function SkeletonTile() {
  return (
    <div className="aspect-square rounded-xl bg-surface border border-border animate-pulse" />
  )
}

export function CategoryGrid({ categories, onSelect, loading = false, selectedSlug }: CategoryGridProps) {
  if (loading) {
    return (
      <div className="grid grid-cols-3 gap-3 px-4">
        {Array.from({ length: 6 }).map((_, i) => (
          <SkeletonTile key={i} />
        ))}
      </div>
    )
  }

  if (categories.length === 0) {
    return (
      <div className="px-4 py-12 text-center">
        <p className="font-mono text-sm text-muted">No categories found.</p>
        <p className="font-mono text-xs text-muted/60 mt-1">Add more cards to unlock spending categories.</p>
      </div>
    )
  }

  return (
    <div className="grid grid-cols-3 gap-3 px-4">
      {categories.map(category => (
        <CategoryTile
          key={category.slug}
          category={category}
          onClick={onSelect}
          isSelected={category.slug === selectedSlug}
          locked={category.locked}
        />
      ))}
    </div>
  )
}
