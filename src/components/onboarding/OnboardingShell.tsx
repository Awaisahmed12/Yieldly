import { useState } from 'react'
import { BankSection } from './BankSection'
import type { CardRow } from '../../types/reward'
import type { BankRow } from '../../types/reward'

// Co-branded cards that should appear under a brand bank IN ADDITION to their issuer.
// Key = card slug, value = brand bank slug to also show it under.
const CO_BRANDED_DISPLAY: Record<string, string> = {
  'chase_amazon_prime_visa':           'amazon',
  'citi_costco':                       'costco',
  'synchrony_sams_club':               'sams_club',
  'barclays_jetblue_plus':             'jetblue',
  'barclays_jetblue':                  'jetblue',
}

interface OnboardingShellProps {
  banks: BankRow[]
  cards: CardRow[]
  onComplete: (selectedCardIds: string[]) => void
}

export function OnboardingShell({ banks, cards, onComplete }: OnboardingShellProps) {
  const [selectedCardIds, setSelectedCardIds] = useState<string[]>([])
  const [search, setSearch] = useState('')

  function handleToggle(cardId: string) {
    setSelectedCardIds(prev =>
      prev.includes(cardId)
        ? prev.filter(id => id !== cardId)
        : [...prev, cardId]
    )
  }

  const bankGroups = banks
    .map(bank => {
      const ownCards = cards.filter(c => c.bank_id === bank.id)
      const coCards = cards.filter(
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

  return (
    <div className="flex flex-col min-h-dvh bg-bg">
      {/* Header */}
      <div className="px-5 pt-8 pb-3 flex-shrink-0">
        <h1 className="font-serif text-2xl font-semibold text-text-primary leading-snug mb-2">
          Select your cards
        </h1>
        <p className="font-mono text-sm text-muted leading-relaxed">
        </p>
      </div>

      {/* Search */}
      <div className="px-5 pb-3 flex-shrink-0">
        <input
          type="search"
          value={search}
          onChange={e => setSearch(e.target.value)}
          placeholder="Search cards..."
          className="w-full bg-white/5 border border-border rounded-lg px-3 py-2.5 font-mono text-sm text-text-primary placeholder:text-muted focus:outline-none focus:border-accent/50 transition-colors"
        />
      </div>

      {/* Scrollable list */}
      <div className="flex-1 overflow-y-auto pb-28 border-t border-border">
        {visibleGroups.length === 0 && (
          <p className="font-mono text-sm text-muted text-center py-12 px-5">
            No cards match &ldquo;{search}&rdquo;
          </p>
        )}
        {visibleGroups.map(({ bank, cards: bankCards }) => (
          <BankSection
            key={bank.id}
            bank={bank}
            cards={bankCards}
            selectedCardIds={selectedCardIds}
            onToggle={handleToggle}
            forceExpanded={q ? true : undefined}
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
