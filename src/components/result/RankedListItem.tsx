import { formatRateShort } from '../../lib/rewards'
import type { RankedResult } from '../../types/reward'

interface RankedListItemProps {
  result: RankedResult
  isWinner: boolean
  isForeignSpending?: boolean
}

export function RankedListItem({ result, isWinner, isForeignSpending = false }: RankedListItemProps) {
  const hasFtf = isForeignSpending && result.ftfApplied > 0
  const isNegative = result.effectiveCpd < 0
  const annualFee = result.card.annual_fee

  // Break-even: how much to spend here to earn back the annual fee
  const breakEvenSpend = annualFee > 0 && result.effectiveCpd > 0
    ? Math.ceil(annualFee / result.effectiveCpd)
    : null

  return (
    <div
      className={`px-4 py-3.5 flex items-start gap-3 border-b border-border/50 last:border-0 ${
        isWinner ? '' : 'opacity-60'
      }`}
    >
      {/* Rank */}
      <div className="w-6 flex-shrink-0 flex items-center justify-center pt-0.5">
        {isWinner ? (
          <div className="w-2 h-2 rounded-full bg-accent" />
        ) : (
          <span className="font-mono text-xs text-muted">{result.rank}</span>
        )}
      </div>

      {/* Card info */}
      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-2">
          <span className={`font-mono text-sm leading-snug ${isWinner ? 'text-text-primary' : 'text-muted'}`}>
            {result.card.display_name}
          </span>
          {result.hasCap && (
            <span className="font-mono text-xs text-accent2 border border-accent2/30 rounded px-1 py-0.5 flex-shrink-0">
              cap
            </span>
          )}
        </div>

        {/* Foreign fee explanation */}
        {hasFtf && (
          <p className={`font-mono text-xs mt-0.5 leading-snug ${isNegative ? 'text-red-400/80' : 'text-muted/70'}`}>
            {isNegative
              ? `Earns ${(result.effectiveCpd * 100 + result.ftfApplied).toFixed(1)}% but ${result.ftfApplied}% foreign transaction fee = net ${result.estimatedPct}%`
              : `${result.ftfApplied}% foreign transaction fee reduces your return`
            }
          </p>
        )}

        {result.notes && !hasFtf && (
          <p className="font-mono text-xs text-muted/70 mt-0.5 leading-snug">
            {result.notes}
          </p>
        )}

        {/* Annual fee break-even */}
        {breakEvenSpend && (
          <p className="font-mono text-xs text-muted/50 mt-0.5 leading-snug">
            Spend ${breakEvenSpend.toLocaleString()}/yr to cover ${annualFee} fee
          </p>
        )}
      </div>

      {/* Rate */}
      <div className="flex-shrink-0 text-right">
        <span className={`font-mono text-sm font-medium ${
          isNegative && isForeignSpending
            ? 'text-red-400'
            : isWinner
              ? 'text-accent'
              : 'text-muted'
        }`}>
          {formatRateShort(result)}
        </span>
      </div>
    </div>
  )
}
