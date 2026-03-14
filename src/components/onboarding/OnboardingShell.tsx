import { useState } from 'react'
import { BankSection } from './BankSection'
import type { CardRow } from '../../types/reward'
import type { BankRow } from '../../types/reward'

interface OnboardingShellProps {
  banks: BankRow[]
  cards: CardRow[]
  onComplete: (selectedCardIds: string[]) => void
}

export function OnboardingShell({ banks, cards, onComplete }: OnboardingShellProps) {
  const [selectedCardIds, setSelectedCardIds] = useState<string[]>([])

  function handleToggle(cardId: string) {
    setSelectedCardIds(prev =>
      prev.includes(cardId)
        ? prev.filter(id => id !== cardId)
        : [...prev, cardId]
    )
  }

  const bankGroups = banks
    .map(bank => ({
      bank,
      cards: cards.filter(c => c.bank_id === bank.id),
    }))
    .filter(g => g.cards.length > 0)

  return (
    <div className="flex flex-col min-h-dvh bg-bg">
      {/* Header */}
      <div className="px-5 pt-8 pb-4 flex-shrink-0">
        <h1 className="font-serif text-2xl font-semibold text-text-primary leading-snug mb-2">
          Which cards are in your wallet?
        </h1>
        <p className="font-mono text-sm text-muted leading-relaxed">
          We&rsquo;ll only show categories where your cards earn elevated rewards.
        </p>
      </div>

      {/* Scrollable list */}
      <div className="flex-1 overflow-y-auto pb-28 border-t border-border">
        {bankGroups.map(({ bank, cards: bankCards }) => (
          <BankSection
            key={bank.id}
            bank={bank}
            cards={bankCards}
            selectedCardIds={selectedCardIds}
            onToggle={handleToggle}
          />
        ))}
      </div>

      {/* Sticky bottom CTA */}
      <div className="fixed bottom-0 left-0 right-0 bg-bg border-t border-border px-5 py-4 flex flex-col gap-2">
        {selectedCardIds.length > 0 && (
          <p className="font-mono text-xs text-muted text-center">
            {selectedCardIds.length} {selectedCardIds.length === 1 ? 'card' : 'cards'} selected
          </p>
        )}
        <button
          type="button"
          onClick={() => onComplete(selectedCardIds)}
          disabled={selectedCardIds.length === 0}
          className="w-full bg-accent text-bg font-mono font-medium py-3.5 px-4 rounded-xl text-sm transition-opacity disabled:opacity-40 disabled:cursor-not-allowed hover:opacity-90 active:opacity-80"
        >
          Let&rsquo;s go →
        </button>
      </div>
    </div>
  )
}
