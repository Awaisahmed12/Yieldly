import { BottomSheet } from '../shared/BottomSheet'
import { useRewardLookup } from '../../hooks/useRewardLookup'
import { useRewardData } from '../../hooks/useRewardData'
import { ResultCard } from './ResultCard'
import { RankedList } from './RankedList'
import { TiebreakerNote } from './TiebreakerNote'
import { LoadingSpinner } from '../shared/LoadingSpinner'

interface ResultSheetProps {
  slug: string | null
  categoryName: string
  isOpen: boolean
  onClose: () => void
}

export function ResultSheet({ slug, categoryName, isOpen, onClose }: ResultSheetProps) {
  const { ranked, winner, tie, loading } = useRewardLookup(slug)
  const { banks } = useRewardData()

  const winnerBank = winner
    ? banks.find(b => b.id === winner.card.bank_id) ?? null
    : null

  return (
    <BottomSheet isOpen={isOpen} onClose={onClose} title={categoryName}>
      {loading ? (
        <div className="flex items-center justify-center py-16">
          <LoadingSpinner size="md" />
        </div>
      ) : winner ? (
        <div className="pb-10 pt-2">
          <ResultCard result={winner} bank={winnerBank} />
          {tie && <TiebreakerNote tie={tie} />}
          <RankedList results={ranked} />
        </div>
      ) : (
        <div className="flex flex-col items-center justify-center gap-3 px-4 py-16">
          <p className="font-serif text-xl text-text-primary text-center">
            No results found
          </p>
          <p className="font-mono text-sm text-muted text-center">
            None of your cards have rates for this category.
          </p>
        </div>
      )}
    </BottomSheet>
  )
}
