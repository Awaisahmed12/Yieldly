import type { CategoryRow } from '../../types/reward'

const ICON_MAP: Record<string, string> = {
  ShoppingCart: '🛒',
  UtensilsCrossed: '🍽️',
  Fuel: '⛽',
  Plane: '✈️',
  PlaneTakeoff: '✈️',
  Hotel: '🏨',
  Tv: '📺',
  Pill: '💊',
  Clapperboard: '🎬',
  Train: '🚇',
  ShoppingBag: '🛍️',
  Home: '🏠',
  Warehouse: '🏭',
  Package: '📦',
  Leaf: '🥦',
  Car: '🚗',
  Tag: '🏷️',
  // Brand-specific:
  amazon: '📦',
  whole_foods: '🥦',
  costco: '🏭',
  united: '✈️',
  delta: '✈️',
  southwest: '🛫',
  jetblue: '🛫',
  hilton: '🏨',
  marriott: '🏨',
  hyatt: '🏨',
  ihg: '🏨',
  uber: '🚗',
  uber_eats: '🍔',
  ebay: '🏷️',
}

interface CategoryTileProps {
  category: CategoryRow
  onClick: (slug: string) => void
}

export function CategoryTile({ category, onClick }: CategoryTileProps) {
  const icon = ICON_MAP[category.icon_name] ?? ICON_MAP[category.slug] ?? '💳'

  return (
    <button
      type="button"
      onClick={() => onClick(category.slug)}
      className={`
        aspect-square flex flex-col items-center justify-center gap-2 rounded-xl bg-surface
        border transition-all duration-150
        active:scale-95
        ${category.is_brand
          ? 'border-accent/20 hover:border-accent/50 hover:shadow-[0_0_12px_rgba(200,245,66,0.12)]'
          : 'border-border hover:border-accent/40 hover:shadow-[0_0_12px_rgba(200,245,66,0.1)]'
        }
      `}
    >
      <span className="text-2xl leading-none" role="img" aria-hidden="true">
        {icon}
      </span>
      <span className="font-mono text-xs text-text-primary text-center leading-snug px-1 line-clamp-2">
        {category.display_name}
      </span>
      {category.is_brand && (
        <div className="w-1 h-1 rounded-full bg-accent/60" />
      )}
    </button>
  )
}
