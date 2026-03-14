import type { RankedResult, TiebreakerFactor, TieInfo } from '../types/reward'

/**
 * Detect if the top results are tied and explain why.
 * Tie threshold: within 0.001 cpd (0.1 cent per dollar)
 */
export function detectTie(results: RankedResult[]): TieInfo | null {
  const tiedResults = results.filter(r => r.isTie)
  if (tiedResults.length < 2) return null

  const factors: TiebreakerFactor[] = []

  // Sort tied cards to compare pairs
  const [a, b] = tiedResults.slice(0, 2)

  // Factor 1: Annual fee
  if (a.card.annual_fee !== b.card.annual_fee) {
    const lower = a.card.annual_fee < b.card.annual_fee ? a : b
    factors.push({
      type: 'annual_fee',
      explanation: `${lower.card.display_name} has a lower annual fee ($${lower.card.annual_fee} vs $${Math.max(a.card.annual_fee, b.card.annual_fee)})`,
      favoredCardSlug: lower.card.slug,
    })
  }

  // Factor 2: Cap
  const aHasCap = a.hasCap
  const bHasCap = b.hasCap
  if (aHasCap !== bHasCap) {
    const uncapped = !aHasCap ? a : b
    factors.push({
      type: 'no_cap',
      explanation: `${uncapped.card.display_name} has no spend cap on this category`,
      favoredCardSlug: uncapped.card.slug,
    })
  }

  // Factor 3: Cashback simplicity vs points
  if (a.rateType !== b.rateType) {
    const cashCard = a.rateType === 'cashback' ? a : b
    const ptsCard = a.rateType === 'multiplier' ? a : b
    factors.push({
      type: 'cashback_simplicity',
      explanation: `${cashCard.card.display_name} earns straightforward cash back. ${ptsCard.card.display_name} earns points worth more if you transfer to travel partners.`,
      favoredCardSlug: null,  // user preference
    })
  }

  // Factor 4: Portal restriction
  const portalNotes = tiedResults.filter(r =>
    r.notes?.toLowerCase().includes('portal') ||
    r.notes?.toLowerCase().includes('via ')
  )
  portalNotes.forEach(r => {
    factors.push({
      type: 'portal_restriction',
      explanation: `${r.card.display_name}: ${r.notes}`,
      favoredCardSlug: null,
    })
  })

  if (factors.length === 0) {
    // Generic tie note
    factors.push({
      type: 'cashback_simplicity',
      explanation: 'These cards earn the same effective rate here. Choose based on your other preferences.',
      favoredCardSlug: null,
    })
  }

  return { tiedResults, factors }
}
