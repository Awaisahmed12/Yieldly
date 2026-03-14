import { formatRateShort } from '../../lib/rewards'
import type { RankedResult } from '../../types/reward'

interface RankedListItemProps {
  result: RankedResult
  isWinner: boolean
}

export function RankedListItem({ result, isWinner }: RankedListItemProps) {
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
        {result.notes && (
          <p className="font-mono text-xs text-muted/70 mt-0.5 leading-snug">
            {result.notes}
          </p>
        )}
      </div>

      {/* Rate */}
      <div className="flex-shrink-0 text-right">
        <span className={`font-mono text-sm font-medium ${isWinner ? 'text-accent' : 'text-muted'}`}>
          {formatRateShort(result)}
        </span>
      </div>
    </div>
  )
}
