import { RankedListItem } from './RankedListItem'
import type { RankedResult } from '../../types/reward'

interface RankedListProps {
  results: RankedResult[]
}

export function RankedList({ results }: RankedListProps) {
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
          />
        ))}
      </div>
    </div>
  )
}
