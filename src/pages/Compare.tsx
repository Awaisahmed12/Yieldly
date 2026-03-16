import { useState, useMemo, useRef } from 'react'
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
  const { cards: allCards, rates } = useRewardData()
  const cppMode = prefs?.cpp_mode ?? 'default'

  const [selectedIds, setSelectedIds] = useState<string[]>(userCards.slice(0, 3).map(c => c.id))
  const [search, setSearch] = useState('')
  const [searchOpen, setSearchOpen] = useState(false)
  const inputRef = useRef<HTMLInputElement>(null)

  const selectedCards = useMemo(
    () => selectedIds.map(id => allCards.find(c => c.id === id)).filter(Boolean) as typeof allCards,
    [selectedIds, allCards]
  )

  const searchResults = useMemo(() => {
    const q = search.trim().toLowerCase()
    if (!q) return []
    return allCards
      .filter(c =>
        (c.display_name.toLowerCase().includes(q) || c.full_name.toLowerCase().includes(q)) &&
        !selectedIds.includes(c.id)
      )
      .slice(0, 6)
  }, [search, allCards, selectedIds])

  function addCard(id: string) {
    if (selectedIds.length >= 4 || selectedIds.includes(id)) return
    setSelectedIds(prev => [...prev, id])
    setSearch('')
    setSearchOpen(false)
  }

  function removeCard(id: string) {
    setSelectedIds(prev => prev.filter(x => x !== id))
  }

  function toggleUserCard(id: string) {
    if (selectedIds.includes(id)) {
      removeCard(id)
    } else if (selectedIds.length < 4) {
      setSelectedIds(prev => [...prev, id])
    }
  }

  // Build comparison table
  const table = useMemo(() => {
    if (selectedCards.length === 0) return []
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
      return { ...cat, cells }
    }).filter(row => row.cells.some(c => c.pct !== 0))
  }, [selectedCards, rates, cppMode])

  return (
    <div className="min-h-dvh bg-bg flex flex-col max-w-[480px] mx-auto">
      <TopNav showBack title="Compare Cards" />

      <div className="flex-1 overflow-y-auto pb-12">
        <div className="px-4 pt-4 pb-2 space-y-4">

          {/* Selected cards chips */}
          {selectedCards.length > 0 && (
            <div>
              <p className="font-mono text-[10px] text-muted uppercase tracking-widest mb-2">
                Comparing ({selectedCards.length}/4)
              </p>
              <div className="flex flex-wrap gap-2">
                {selectedCards.map(card => (
                  <button
                    key={card.id}
                    type="button"
                    onClick={() => removeCard(card.id)}
                    className="flex items-center gap-1.5 font-mono text-xs px-3 py-1.5 rounded-full bg-accent/10 border border-accent/30 text-accent hover:bg-red-500/10 hover:border-red-400/30 hover:text-red-400 transition-colors"
                  >
                    {card.display_name}
                    <span className="text-[10px] opacity-60">✕</span>
                  </button>
                ))}
              </div>
            </div>
          )}

          {/* Search */}
          {selectedIds.length < 4 && (
            <div className="relative">
              <input
                ref={inputRef}
                type="search"
                value={search}
                onChange={e => { setSearch(e.target.value); setSearchOpen(true) }}
                onFocus={() => setSearchOpen(true)}
                onBlur={() => setTimeout(() => setSearchOpen(false), 150)}
                placeholder="Search any card to add..."
                className="w-full bg-surface border border-border rounded-lg px-3 py-2.5 font-mono text-sm text-text-primary placeholder:text-muted focus:outline-none focus:border-accent/50 transition-colors"
              />
              {searchOpen && searchResults.length > 0 && (
                <div className="absolute z-20 top-full mt-1 left-0 right-0 bg-surface border border-border rounded-lg overflow-hidden shadow-xl">
                  {searchResults.map(card => (
                    <button
                      key={card.id}
                      type="button"
                      onMouseDown={() => addCard(card.id)}
                      className="w-full text-left px-4 py-3 font-mono text-sm text-text-primary hover:bg-white/5 border-b border-border/50 last:border-0 transition-colors"
                    >
                      {card.display_name}
                      <span className="text-xs text-muted ml-2">{card.full_name.split(' ').slice(0, 2).join(' ')}…</span>
                    </button>
                  ))}
                </div>
              )}
              {searchOpen && search.trim().length > 0 && searchResults.length === 0 && (
                <div className="absolute z-20 top-full mt-1 left-0 right-0 bg-surface border border-border rounded-lg px-4 py-3">
                  <p className="font-mono text-sm text-muted">No cards found</p>
                </div>
              )}
            </div>
          )}

          {/* Your cards quick-add */}
          {userCards.length > 0 && (
            <div>
              <p className="font-mono text-[10px] text-muted uppercase tracking-widest mb-2">Your cards</p>
              <div className="flex flex-wrap gap-2">
                {userCards.map(card => (
                  <button
                    key={card.id}
                    type="button"
                    onClick={() => toggleUserCard(card.id)}
                    disabled={!selectedIds.includes(card.id) && selectedIds.length >= 4}
                    className={`font-mono text-xs px-3 py-1.5 rounded-full border transition-colors disabled:opacity-30 disabled:cursor-not-allowed ${
                      selectedIds.includes(card.id)
                        ? 'bg-accent text-bg border-accent'
                        : 'bg-surface border-border text-muted hover:border-accent/40'
                    }`}
                  >
                    {card.display_name}
                  </button>
                ))}
              </div>
            </div>
          )}
        </div>

        {selectedCards.length === 0 && (
          <div className="mx-4 mt-6 py-10 text-center">
            <p className="font-mono text-sm text-muted">Search or select cards above to compare</p>
          </div>
        )}

        {selectedCards.length > 0 && (
          <div className="mx-4 mt-2 overflow-x-auto">
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
                      <td key={cell.card.id} className="text-center py-2.5 px-2">
                        <span className={`font-mono text-xs font-medium ${
                          cell.isNegative ? 'text-red-400' : cell.isBest ? 'text-accent' : 'text-muted'
                        }`}>
                          {cell.pct === 0 ? '—' : `${cell.pct > 0 ? '' : ''}${cell.pct}%`}
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
