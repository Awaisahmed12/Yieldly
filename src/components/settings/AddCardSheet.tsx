import { useState } from 'react'
import { BottomSheet } from '../shared/BottomSheet'
import { BankSection } from '../onboarding/BankSection'
import type { CardRow } from '../../types/reward'
import type { BankRow } from '../../types/reward'

const CO_BRANDED_DISPLAY: Record<string, string> = {
  'chase_amazon_prime_visa':           'amazon',
  'citi_costco':                       'costco',
  'synchrony_sams_club':               'sams_club',
  'barclays_jetblue_plus':             'jetblue',
  'barclays_jetblue':                  'jetblue',
}

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
  const [search, setSearch] = useState('')

  function handleToggle(cardId: string) {
    if (ownedCardIds.includes(cardId)) return
    setSelectedIds(prev =>
      prev.includes(cardId) ? prev.filter(id => id !== cardId) : [...prev, cardId]
    )
  }

  function handleAdd() {
    onAdd(selectedIds)
    setSelectedIds([])
    setSearch('')
    onClose()
  }

  const bankGroups = banks
    .map(bank => {
      const ownCards = allCards.filter(c => c.bank_id === bank.id)
      const coCards = allCards.filter(
        c => CO_BRANDED_DISPLAY[c.slug] === bank.slug && c.bank_id !== bank.id
      )
      return { bank, cards: [...ownCards, ...coCards] }
    })
    .filter(g => g.cards.length > 0)

  const q = search.trim().toLowerCase()
  const visibleGroups = q
    ? bankGroups
        .map(g => ({
          ...g,
          cards: g.cards.filter(
            c =>
              c.display_name.toLowerCase().includes(q) ||
              c.full_name.toLowerCase().includes(q) ||
              g.bank.display_name.toLowerCase().includes(q)
          ),
        }))
        .filter(g => g.cards.length > 0)
    : bankGroups

  const newSelectionsCount = selectedIds.filter(id => !ownedCardIds.includes(id)).length

  return (
    <BottomSheet isOpen={isOpen} onClose={onClose} title="Add Cards">
      <div className="flex flex-col" style={{ maxHeight: '72vh' }}>
        {/* Search */}
        <div className="px-5 pt-1 pb-3 flex-shrink-0">
          <input
            type="search"
            value={search}
            onChange={e => setSearch(e.target.value)}
            placeholder="Search cards..."
            className="w-full bg-white/5 border border-border rounded-lg px-3 py-2.5 font-mono text-base text-text-primary placeholder:text-muted focus:outline-none focus:border-accent/50 transition-colors"
          />
        </div>

        {/* Card list */}
        <div className="overflow-y-auto flex-1 border-t border-border">
          {visibleGroups.length === 0 && (
            <p className="font-mono text-sm text-muted text-center py-10 px-5">
              No cards match &ldquo;{search}&rdquo;
            </p>
          )}
          {visibleGroups.map(({ bank, cards }) => (
            <BankSection
              key={bank.id}
              bank={bank}
              cards={cards}
              selectedCardIds={[...ownedCardIds, ...selectedIds]}
              onToggle={handleToggle}
              forceExpanded={q ? true : undefined}
            />
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
