import {
  ShoppingCart, UtensilsCrossed, Fuel, Globe, PlaneTakeoff, Hotel, Tv, Pill,
  Clapperboard, Train, ShoppingBag, Home, Warehouse, Package, Leaf, Car, Tag,
  Apple, Scissors, Zap, Dumbbell, BatteryCharging, CreditCard, type LucideIcon,
} from 'lucide-react'
import type { CategoryWithLock } from '../../hooks/useCategories'

const ICON_MAP: Record<string, LucideIcon> = {
  ShoppingCart, UtensilsCrossed, Fuel,
  Plane: Globe, Globe, PlaneTakeoff, Hotel, Tv, Pill,
  Clapperboard, Train, ShoppingBag, Home, Warehouse, Package, Leaf, Car, Tag,
  Apple, Scissors, Zap, Dumbbell, BatteryCharging,
  amazon: Package, whole_foods: Leaf, costco: Warehouse, sams_club: Warehouse,
  united: PlaneTakeoff, delta: PlaneTakeoff, southwest: PlaneTakeoff, jetblue: PlaneTakeoff,
  hilton: Hotel, marriott: Hotel, hyatt: Hotel, ihg: Hotel,
  uber: Car, uber_eats: UtensilsCrossed, ebay: Tag,
}

interface RecentCategoriesRowProps {
  slugs: string[]
  categories: CategoryWithLock[]
  selectedSlug: string | null
  onSelect: (slug: string) => void
}

export function RecentCategoriesRow({ slugs, categories, selectedSlug, onSelect }: RecentCategoriesRowProps) {
  const visible = slugs
    .map(slug => categories.find(c => c.slug === slug))
    .filter((c): c is CategoryWithLock => c !== undefined && !c.locked)

  if (visible.length < 2) return null

  return (
    <div className="px-4 mb-3">
      <p className="font-mono text-[9px] text-muted/50 uppercase tracking-[0.18em] mb-2">Recent</p>
      <div className="flex gap-2 overflow-x-auto scrollbar-hide">
        {visible.map(cat => {
          const Icon = ICON_MAP[cat.icon_name] ?? ICON_MAP[cat.slug] ?? CreditCard
          const isSelected = cat.slug === selectedSlug
          return (
            <button
              key={cat.slug}
              type="button"
              onClick={() => onSelect(cat.slug)}
              className={`
                flex items-center gap-1.5 shrink-0 rounded-lg px-3 py-2
                border font-mono text-xs transition-all duration-150 active:scale-95
                ${isSelected
                  ? 'bg-accent/10 border-accent text-accent'
                  : 'bg-surface border-border text-text-primary hover:border-accent/40 hover:bg-accent/5'
                }
              `}
            >
              <Icon size={13} strokeWidth={1.5} />
              <span>{cat.display_name}</span>
            </button>
          )
        })}
      </div>
    </div>
  )
}
