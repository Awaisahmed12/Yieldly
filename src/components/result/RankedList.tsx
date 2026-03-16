import { RankedListItem } from './RankedListItem'
import type { RankedResult } from '../../types/reward'

interface RankedListProps {
  results: RankedResult[]
  isForeignSpending?: boolean
}

export function RankedList({ results, isForeignSpending = false }: RankedListProps) {
  if (results.length === 0) return null

  return (
    <div className="mx-4 mt-5">
      <h3 className="font-mono text-xs text-muted uppercase tracking-widest mb-3">
        All your cards
      </h3>
      <div className="bg-surface border border-border rounded-xl overflow-hidden">
        {results.map((result, i) => (
          <RankedListItem
            key={result.card.id}
            result={result}
            isWinner={i === 0 || result.rank === 1}
            isForeignSpending={isForeignSpending}
          />
        ))}
      </div>
      {isForeignSpending && (
        <p className="font-mono text-xs text-muted/50 mt-3 leading-relaxed px-1">
          Foreign transaction fees (FTF) are charged by some cards on purchases made in a foreign currency. A card earning 1.5% but charging 3% FTF costs you 1.5% net on every foreign purchase.
        </p>
      )}
    </div>
  )
}
