import {
  ShoppingCart, UtensilsCrossed, Fuel, Globe, PlaneTakeoff, Hotel, Tv, Pill,
  Clapperboard, Train, ShoppingBag, Home, Warehouse, Package, Leaf, Car, Tag,
  Apple, CreditCard, type LucideIcon,
} from 'lucide-react'
import type { CategoryRow } from '../../types/reward'

const ICON_MAP: Record<string, LucideIcon> = {
  // Standard categories (icon_name from DB)
  ShoppingCart,
  UtensilsCrossed,
  Fuel,
  Plane: Globe,        // Travel = portal = Globe
  PlaneTakeoff,        // Flights = PlaneTakeoff
  Hotel,
  Tv,
  Pill,
  Clapperboard,
  Train,
  ShoppingBag,
  Home,
  Warehouse,
  Package,
  Leaf,
  Car,
  Tag,
  Apple,
  // Brand slug fallbacks
  amazon: Package,
  whole_foods: Leaf,
  costco: Warehouse,
  sams_club: Warehouse,
  united: PlaneTakeoff,
  delta: PlaneTakeoff,
  southwest: PlaneTakeoff,
  jetblue: PlaneTakeoff,
  hilton: Hotel,
  marriott: Hotel,
  hyatt: Hotel,
  ihg: Hotel,
  uber: Car,
  uber_eats: UtensilsCrossed,
  ebay: Tag,
}

// Small clarifying subtitles for ambiguous categories
const SUBTITLES: Record<string, string> = {
  travel: 'via portal',
}

interface CategoryTileProps {
  category: CategoryRow
  onClick: (slug: string) => void
  isSelected?: boolean
}

export function CategoryTile({ category, onClick, isSelected = false }: CategoryTileProps) {
  const IconComponent = ICON_MAP[category.icon_name] ?? ICON_MAP[category.slug] ?? CreditCard
  const subtitle = SUBTITLES[category.slug]

  return (
    <button
      type="button"
      onClick={() => onClick(category.slug)}
      className={`
        aspect-square flex flex-col items-center justify-center gap-1.5 rounded-xl
        border transition-all duration-150 active:scale-95
        ${isSelected
          ? 'bg-accent/10 border-accent shadow-[0_0_16px_rgba(200,245,66,0.18)]'
          : category.is_brand
            ? 'bg-surface border-accent/20 hover:border-accent/50 hover:bg-accent/5'
            : 'bg-surface border-border hover:border-accent/40 hover:bg-accent/5'
        }
      `}
    >
      <IconComponent
        size={20}
        strokeWidth={1.5}
        className={isSelected ? 'text-accent' : 'text-text-primary'}
      />
      <span className={`font-mono text-xs text-center leading-snug px-1 line-clamp-2 ${isSelected ? 'text-accent' : 'text-text-primary'}`}>
        {category.display_name}
      </span>
      {subtitle && (
        <span className="font-mono text-[9px] text-muted leading-none px-1">
          {subtitle}
        </span>
      )}
      {category.is_brand && !isSelected && !subtitle && (
        <div className="w-1 h-1 rounded-full bg-accent/60" />
      )}
    </button>
  )
}
