import { useParams } from 'react-router-dom'
import { useRewardLookup } from '../hooks/useRewardLookup'
import { useRewardData } from '../hooks/useRewardData'
import { TopNav } from '../components/shared/TopNav'
import { ResultCard } from '../components/result/ResultCard'
import { RankedList } from '../components/result/RankedList'
import { TiebreakerNote } from '../components/result/TiebreakerNote'
import { LoadingSpinner } from '../components/shared/LoadingSpinner'

export function ResultPage() {
  const { slug } = useParams<{ slug: string }>()
  const { ranked, winner, tie, loading } = useRewardLookup(slug ?? null)
  const { categories, banks } = useRewardData()

  const category = categories.find(c => c.slug === slug)
  const categoryName = category?.display_name ?? slug ?? ''

  // Find bank for the winner card
  const winnerBank = winner
    ? banks.find(b => b.id === winner.card.bank_id) ?? null
    : null

  return (
    <div className="min-h-dvh bg-bg flex flex-col max-w-[480px] mx-auto">
      <TopNav showBack title={categoryName} />

      {loading ? (
        <div className="flex-1 flex items-center justify-center">
          <LoadingSpinner size="md" />
        </div>
      ) : winner ? (
        <div className="flex-1 pb-10 pt-4">
          {/* Winner card */}
          <ResultCard result={winner} bank={winnerBank} />

          {/* Tiebreaker note */}
          {tie && <TiebreakerNote tie={tie} />}

          {/* Full ranked list */}
          <RankedList results={ranked} isForeignSpending={slug === 'foreign_spending'} />
        </div>
      ) : (
        <div className="flex-1 flex flex-col items-center justify-center gap-3 px-4">
          <p className="font-serif text-xl text-text-primary text-center">
            No results found
          </p>
          <p className="font-mono text-sm text-muted text-center">
            None of your cards have rates for this category.
          </p>
        </div>
      )}
    </div>
  )
}
