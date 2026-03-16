import { useState, useMemo } from 'react'
import { useUserStore } from '../store/userStore'
import { useRewardData } from '../hooks/useRewardData'
import { rankCardsForCategory } from '../lib/rewards'
import { TopNav } from '../components/shared/TopNav'

const COMPARE_CATEGORIES = [
  { slug: 'dining',          label: 'Dining' },
  { slug: 'groceries',       label: 'Groceries' },
  { slug: 'gas',             label: 'Gas' },
  { slug: 'travel',          label: 'Travel' },
  { slug: 'flights',         label: 'Flights' },
  { slug: 'hotels',          label: 'Hotels' },
  { slug: 'streaming',       label: 'Streaming' },
  { slug: 'pharmacy',        label: 'Pharmacy' },
  { slug: 'entertainment',   label: 'Entertainment' },
  { slug: 'transit',         label: 'Transit' },
  { slug: 'online_shopping', label: 'Online' },
  { slug: 'rent',            label: 'Rent' },
  { slug: 'wholesale_clubs', label: 'Wholesale' },
  { slug: 'car_rental',      label: 'Car Rental' },
  { slug: 'foreign_spending',label: 'Foreign' },
]

export function ComparePage() {
  const { userCards, prefs } = useUserStore()
  const { rates } = useRewardData()
  const cppMode = prefs?.cpp_mode ?? 'default'

  const [selected, setSelected] = useState<string[]>(userCards.slice(0, 3).map(c => c.id))

  const selectedCards = useMemo(
    () => userCards.filter(c => selected.includes(c.id)),
    [userCards, selected]
  )

  function toggleCard(id: string) {
    setSelected(prev =>
      prev.includes(id)
        ? prev.filter(x => x !== id)
        : prev.length < 4 ? [...prev, id] : prev
    )
  }

  // Build comparison table: category → card → pct
  const table = useMemo(() => {
    return COMPARE_CATEGORIES.map(cat => {
      const ranked = rankCardsForCategory(selectedCards, cat.slug, rates, cppMode)
      const maxPct = Math.max(...ranked.map(r => r.estimatedPct))
      const cells = selectedCards.map(card => {
        const result = ranked.find(r => r.card.id === card.id)
        const pct = result?.estimatedPct ?? 0
        const isBest = pct === maxPct && pct > 0
        const isNegative = pct < 0
        return { card, pct, isBest, isNegative, ftfApplied: result?.ftfApplied ?? 0 }
      })
      const anyBonus = cells.some(c => c.pct > 1.0)
      return { ...cat, cells, anyBonus }
    }).filter(row => row.cells.some(c => c.pct !== 0))
  }, [selectedCards, rates, cppMode])

  return (
    <div className="min-h-dvh bg-bg flex flex-col max-w-[480px] mx-auto">
      <TopNav showBack title="Compare Cards" />

      <div className="flex-1 overflow-y-auto pb-12">
        {/* Card selector */}
        <div className="px-4 pt-4 pb-2">
          <p className="font-mono text-xs text-muted mb-3">Select up to 4 cards to compare</p>
          <div className="flex flex-wrap gap-2">
            {userCards.map(card => (
              <button
                key={card.id}
                type="button"
                onClick={() => toggleCard(card.id)}
                className={`font-mono text-xs px-3 py-1.5 rounded-full border transition-colors ${
                  selected.includes(card.id)
                    ? 'bg-accent text-bg border-accent'
                    : 'bg-surface border-border text-muted hover:border-accent/40'
                }`}
              >
                {card.display_name}
              </button>
            ))}
          </div>
        </div>

        {selectedCards.length === 0 && (
          <div className="mx-4 mt-6 py-10 text-center">
            <p className="font-mono text-sm text-muted">Select cards above to compare</p>
          </div>
        )}

        {selectedCards.length > 0 && (
          <div className="mx-4 mt-4 overflow-x-auto">
            <table className="w-full border-collapse">
              <thead>
                <tr className="border-b border-border">
                  <th className="font-mono text-[10px] text-muted uppercase tracking-widest text-left py-2 pr-3 w-24 min-w-[96px]">
                    Category
                  </th>
                  {selectedCards.map(card => (
                    <th
                      key={card.id}
                      className="font-mono text-[10px] text-muted text-center py-2 px-2 min-w-[72px]"
                    >
                      {card.display_name.split(' ').slice(-1)[0]}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {table.map(row => (
                  <tr key={row.slug} className="border-b border-border/40 last:border-0">
                    <td className="font-mono text-xs text-muted py-2.5 pr-3 leading-snug">
                      {row.label}
                    </td>
                    {row.cells.map(cell => (
                      <td
                        key={cell.card.id}
                        className="text-center py-2.5 px-2"
                      >
                        <span className={`font-mono text-xs font-medium ${
                          cell.isNegative
                            ? 'text-red-400'
                            : cell.isBest
                              ? 'text-accent'
                              : 'text-muted'
                        }`}>
                          {cell.pct === 0 ? '—' : `${cell.pct}%`}
                        </span>
                        {cell.ftfApplied > 0 && (
                          <span className="block font-mono text-[9px] text-red-400/60 leading-none mt-0.5">
                            -{cell.ftfApplied}% foreign fee
                          </span>
                        )}
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>

            {/* Legend */}
            <div className="mt-4 flex items-center gap-4">
              <div className="flex items-center gap-1.5">
                <span className="font-mono text-xs text-accent">2.5%</span>
                <span className="font-mono text-[10px] text-muted">= best in row</span>
              </div>
              <div className="flex items-center gap-1.5">
                <span className="font-mono text-xs text-red-400">-1.5%</span>
                <span className="font-mono text-[10px] text-muted">= net loss abroad</span>
              </div>
            </div>
            <p className="font-mono text-[10px] text-muted/40 mt-2">
              Foreign Spending = base reward rate minus the card's foreign transaction fee. Some cards charge 2.7–3% on foreign purchases, which can wipe out your rewards entirely.
            </p>
          </div>
        )}
      </div>
    </div>
  )
}
