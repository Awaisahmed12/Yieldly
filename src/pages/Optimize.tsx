import { useState, useMemo } from 'react'
import { useUserStore } from '../store/userStore'
import { useRewardData } from '../hooks/useRewardData'
import { rankCardsForCategory } from '../lib/rewards'
import { TopNav } from '../components/shared/TopNav'
import type { CardRow } from '../types/reward'

const SLIDER_CATEGORIES: { slug: string; label: string; defaultAmount: number }[] = [
  { slug: 'dining',          label: 'Dining',          defaultAmount: 0 },
  { slug: 'groceries',       label: 'Groceries',       defaultAmount: 0 },
  { slug: 'online_groceries',label: 'Online Groceries',defaultAmount: 0 },
  { slug: 'gas',             label: 'Gas',             defaultAmount: 0 },
  { slug: 'travel',          label: 'Travel (portal)', defaultAmount: 0 },
  { slug: 'flights',         label: 'Flights',         defaultAmount: 0 },
  { slug: 'hotels',          label: 'Hotels',          defaultAmount: 0 },
  { slug: 'streaming',       label: 'Streaming',       defaultAmount: 0 },
  { slug: 'pharmacy',        label: 'Pharmacy',        defaultAmount: 0 },
  { slug: 'entertainment',   label: 'Entertainment',   defaultAmount: 0 },
  { slug: 'transit',         label: 'Transit',         defaultAmount: 0 },
  { slug: 'online_shopping', label: 'Online Shopping', defaultAmount: 0 },
  { slug: 'rent',            label: 'Rent',            defaultAmount: 0 },
  { slug: 'wholesale_clubs', label: 'Wholesale',       defaultAmount: 0 },
  { slug: 'car_rental',      label: 'Car Rental',      defaultAmount: 0 },
  { slug: 'foreign_spending',label: 'Foreign Spending',defaultAmount: 0 },
]

function formatDollars(n: number) {
  if (n >= 1000) return `$${(n / 1000).toFixed(n % 1000 === 0 ? 0 : 1)}k`
  return `$${n}`
}

export function OptimizePage() {
  const { userCardIds, prefs } = useUserStore()
  const { cards: allCards, rates } = useRewardData()
  const cppMode = prefs?.cpp_mode ?? 'default'

  const userCardIdSet = useMemo(() => new Set(userCardIds), [userCardIds])

  const [spend, setSpend] = useState<Record<string, number>>(
    Object.fromEntries(SLIDER_CATEGORIES.map(c => [c.slug, c.defaultAmount]))
  )

  const totalMonthly = Object.values(spend).reduce((a, b) => a + b, 0)

  const cardResults = useMemo(() => {
    if (!allCards.length) return []

    return allCards.map((card: CardRow) => {
      let totalAnnualRewards = 0

      for (const cat of SLIDER_CATEGORIES) {
        const monthly = spend[cat.slug] ?? 0
        if (monthly === 0) continue

        const ranked = rankCardsForCategory([card], cat.slug, rates, cppMode)
        const cpd = ranked[0]?.effectiveCpd ?? 0
        totalAnnualRewards += monthly * 12 * cpd
      }

      const net = totalAnnualRewards - card.annual_fee

      return {
        card,
        totalAnnualRewards,
        net,
        annualFee: card.annual_fee,
        inWallet: userCardIdSet.has(card.id),
      }
    }).sort((a, b) => b.net - a.net)
  }, [allCards, spend, rates, cppMode, userCardIdSet])

  // Best category per card (for top card)
  const topCard = cardResults[0]
  const topCardCategoryWins = useMemo(() => {
    if (!topCard) return []
    return SLIDER_CATEGORIES.filter(cat => {
      const monthly = spend[cat.slug] ?? 0
      if (monthly === 0) return false
      const ranked = rankCardsForCategory(allCards, cat.slug, rates, cppMode)
      return ranked[0]?.card.id === topCard.card.id
    }).map(c => c.label)
  }, [topCard, spend, allCards, rates, cppMode])

  return (
    <div className="min-h-dvh bg-bg flex flex-col max-w-[480px] mx-auto">
      <TopNav showBack title="Spending Mix" />

      <div className="flex-1 overflow-y-auto pb-12">
        {/* Intro */}
        <div className="px-4 pt-4 pb-2">
          <p className="font-mono text-xs text-muted leading-relaxed">
            Set your average monthly spend in each category to see which card earns you the most overall — after annual fees.
          </p>
        </div>

        {/* Sliders */}
        <div className="mx-4 mt-3 bg-surface border border-border rounded-xl overflow-hidden">
          {SLIDER_CATEGORIES.map((cat, i) => (
            <div
              key={cat.slug}
              className={`px-4 py-3 ${i < SLIDER_CATEGORIES.length - 1 ? 'border-b border-border/50' : ''}`}
            >
              <div className="flex items-center justify-between mb-1.5">
                <span className="font-mono text-xs text-text-primary">{cat.label}</span>
                <span className="font-mono text-xs text-accent tabular-nums w-14 text-right">
                  {formatDollars(spend[cat.slug] ?? 0)}/mo
                </span>
              </div>
              <input
                type="range"
                min={0}
                max={cat.slug === 'rent' ? 5000 : cat.slug === 'flights' || cat.slug === 'hotels' ? 3000 : 2000}
                step={50}
                value={spend[cat.slug] ?? 0}
                onChange={e => setSpend(prev => ({ ...prev, [cat.slug]: Number(e.target.value) }))}
                className="w-full accent-accent h-1.5 rounded-full"
              />
            </div>
          ))}
        </div>

        {/* Total */}
        {totalMonthly > 0 && (
          <div className="mx-4 mt-3 px-4 py-3 bg-accent/5 border border-accent/20 rounded-xl">
            <p className="font-mono text-xs text-muted">
              Total monthly spend: <span className="text-accent">{formatDollars(totalMonthly)}</span>
              {' '}· Annual: <span className="text-accent">{formatDollars(totalMonthly * 12)}</span>
            </p>
          </div>
        )}

        {/* Results */}
        {totalMonthly > 0 && cardResults.length > 0 && (
          <div className="mx-4 mt-4">
            <h2 className="font-mono text-xs text-muted uppercase tracking-widest mb-3">
              Best card for this spend mix
            </h2>
            <div className="bg-surface border border-border rounded-xl overflow-hidden">
              {cardResults.map((item, i) => (
                <div
                  key={item.card.id}
                  className={`px-4 py-3.5 flex items-start gap-3 border-b border-border/50 last:border-0 ${i > 0 ? 'opacity-60' : ''}`}
                >
                  <div className="w-6 flex-shrink-0 flex items-center justify-center pt-0.5">
                    {i === 0
                      ? <div className="w-2 h-2 rounded-full bg-accent" />
                      : <span className="font-mono text-xs text-muted">{i + 1}</span>
                    }
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2">
                      <p className={`font-mono text-sm ${i === 0 ? 'text-text-primary' : 'text-muted'}`}>
                        {item.card.display_name}
                      </p>
                      {item.inWallet && (
                        <span className="font-mono text-[9px] text-accent/70 border border-accent/30 rounded px-1 py-px leading-none">
                          yours
                        </span>
                      )}
                    </div>
                    {i === 0 && topCardCategoryWins.length > 0 && (
                      <p className="font-mono text-xs text-muted/60 mt-0.5 leading-snug">
                        Wins: {topCardCategoryWins.join(', ')}
                      </p>
                    )}
                    {item.annualFee > 0 && (
                      <p className="font-mono text-xs text-muted/50 mt-0.5">
                        ${item.annualFee} annual fee deducted
                      </p>
                    )}
                  </div>
                  <div className="text-right flex-shrink-0">
                    <p className={`font-mono text-sm font-medium ${i === 0 ? 'text-accent' : 'text-muted'}`}>
                      ${Math.round(item.net).toLocaleString()}/yr
                    </p>
                    {item.annualFee > 0 && (
                      <p className="font-mono text-[10px] text-muted/50">
                        ${Math.round(item.totalAnnualRewards)} gross
                      </p>
                    )}
                  </div>
                </div>
              ))}
            </div>
            <p className="font-mono text-xs text-muted/40 mt-2 px-1">
              Net annual value = estimated rewards minus annual fee
            </p>
          </div>
        )}

        {totalMonthly === 0 && (
          <div className="mx-4 mt-6 px-4 py-6 text-center">
            <p className="font-mono text-sm text-muted">Move the sliders to get started</p>
          </div>
        )}
      </div>
    </div>
  )
}
