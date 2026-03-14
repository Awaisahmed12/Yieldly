import type { CardRow, RewardRateRow, RankedResult, CppMode } from '../types/reward'
import { CPP } from '../data/cpp'

const DEFAULT_RATE = 1.0  // fallback rate if no row exists

/**
 * Get the cpp value for a card given the user's cpp_mode preference.
 */
export function getCpp(card: CardRow, mode: CppMode): number {
  const currency = card.reward_currency
  const cardCpp = {
    conservative: card.cpp_low,
    default: card.cpp_default,
    optimistic: card.cpp_high,
  }[mode]

  // Prefer card-specific cpp, fallback to CPP table, fallback to 1.0
  if (cardCpp != null) return cardCpp
  const tableCpp = CPP[currency]
  if (tableCpp) {
    const cppKey: 'low' | 'default' | 'high' = mode === 'conservative' ? 'low' : mode === 'optimistic' ? 'high' : 'default'
    return tableCpp[cppKey]
  }
  return 1.0
}

/**
 * Compute normalized cents-per-dollar spent.
 * For cashback: rate / 100
 * For multiplier: (rate × cpp) / 100
 */
export function computeEffectiveCpd(
  rate: number,
  rateType: 'multiplier' | 'cashback',
  cpp: number
): number {
  if (rateType === 'cashback') return rate / 100
  return (rate * cpp) / 100
}

/**
 * Rank all user cards for a given category.
 * Falls back to DEFAULT_RATE (1x/1%) for cards with no rate row for the category.
 * Also checks the 'other' category as a base rate for flat-rate cards.
 */
export function rankCardsForCategory(
  userCards: CardRow[],
  categorySlug: string,
  allRates: RewardRateRow[],
  cppMode: CppMode
): RankedResult[] {
  const results: RankedResult[] = userCards.map(card => {
    // Find specific rate for this category
    const rateRow = allRates.find(
      r => r.card_id === card.id && r.category_slug === categorySlug
    )

    // Fallback: check 'other' category for base rate (handles flat-rate cards like CFU 1.5%)
    const otherRateRow = allRates.find(
      r => r.card_id === card.id && r.category_slug === 'other'
    )

    // Use specific > other > default
    const activeRow = rateRow ?? otherRateRow ?? null
    const rate = activeRow?.rate ?? DEFAULT_RATE
    const rateType = (activeRow?.rate_type ?? 'cashback') as 'multiplier' | 'cashback'

    const cpp = getCpp(card, cppMode)
    const effectiveCpd = computeEffectiveCpd(rate, rateType, cpp)
    const estimatedPct = parseFloat((effectiveCpd * 100).toFixed(2))

    return {
      card,
      rawRate: rate,
      rateType,
      rewardCurrency: card.reward_currency,
      effectiveCpd,
      estimatedPct,
      notes: activeRow?.notes ?? null,
      hasCap: activeRow?.cap_amount != null,
      isTie: false,  // set after sorting
      rank: 0,       // set after sorting
    }
  })

  // Sort descending by effectiveCpd
  results.sort((a, b) => b.effectiveCpd - a.effectiveCpd)

  // Assign ranks (ties get same rank)
  let currentRank = 1
  results.forEach((r, i) => {
    if (i > 0 && Math.abs(r.effectiveCpd - results[i - 1].effectiveCpd) < 0.0001) {
      r.rank = results[i - 1].rank
    } else {
      r.rank = currentRank
    }
    currentRank++
  })

  // Mark ties
  const topRank1Count = results.filter(r => r.rank === 1).length
  if (topRank1Count > 1) {
    results.filter(r => r.rank === 1).forEach(r => (r.isTie = true))
  }

  return results
}

/**
 * Format a rate for display.
 * cashback: "3% back"
 * multiplier + cashback equivalent: "3x UR · ~4.5% est."
 */
export function formatRate(result: RankedResult): string {
  if (result.rateType === 'cashback') {
    return `${result.rawRate}% back`
  }
  return `${result.rawRate}x ${result.rewardCurrency} · ~${result.estimatedPct}% est.`
}

/**
 * Format a short rate for ranked list rows.
 */
export function formatRateShort(result: RankedResult): string {
  if (result.rateType === 'cashback') {
    return `${result.rawRate}%`
  }
  return `${result.rawRate}x (~${result.estimatedPct}%)`
}
