import { useState } from 'react'
import { BottomSheet } from '../shared/BottomSheet'
import { BankSection } from '../onboarding/BankSection'
import type { CardRow } from '../../types/reward'
import type { BankRow } from '../../types/reward'

interface AddCardSheetProps {
  isOpen: boolean
  onClose: () => void
  onAdd: (cardIds: string[]) => void
  banks: BankRow[]
  allCards: CardRow[]
  ownedCardIds: string[]
}

export function AddCardSheet({ isOpen, onClose, onAdd, banks, allCards, ownedCardIds }: AddCardSheetProps) {
  const [selectedIds, setSelectedIds] = useState<string[]>([])

  function handleToggle(cardId: string) {
    // Can't toggle owned cards
    if (ownedCardIds.includes(cardId)) return

    setSelectedIds(prev =>
      prev.includes(cardId)
        ? prev.filter(id => id !== cardId)
        : [...prev, cardId]
    )
  }

  function handleAdd() {
    onAdd(selectedIds)
    setSelectedIds([])
    onClose()
  }

  // Filter out already-owned cards from toggle-able set, but show them greyed out
  const bankGroups = banks
    .map(bank => ({
      bank,
      cards: allCards.filter(c => c.bank_id === bank.id),
    }))
    .filter(g => g.cards.length > 0)

  const newSelectionsCount = selectedIds.filter(id => !ownedCardIds.includes(id)).length

  return (
    <BottomSheet isOpen={isOpen} onClose={onClose} title="Add Cards">
      <div className="flex flex-col" style={{ maxHeight: '65vh' }}>
        <div className="overflow-y-auto flex-1">
          {bankGroups.map(({ bank, cards }) => (
            <div key={bank.id} className={ownedCardIds.some(id => cards.find(c => c.id === id)) ? '' : ''}>
              <BankSection
                bank={bank}
                cards={cards}
                selectedCardIds={[...ownedCardIds, ...selectedIds]}
                onToggle={handleToggle}
              />
            </div>
          ))}
        </div>

        {/* Add button */}
        <div className="px-5 py-4 border-t border-border flex-shrink-0">
          <button
            type="button"
            onClick={handleAdd}
            disabled={newSelectionsCount === 0}
            className="w-full bg-accent text-bg font-mono font-medium py-3.5 rounded-xl text-sm transition-opacity disabled:opacity-40 disabled:cursor-not-allowed hover:opacity-90 active:opacity-80"
          >
            {newSelectionsCount === 0
              ? 'Select cards to add'
              : `Add ${newSelectionsCount} ${newSelectionsCount === 1 ? 'card' : 'cards'}`
            }
          </button>
        </div>
      </div>
    </BottomSheet>
  )
}
