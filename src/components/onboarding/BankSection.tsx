import { useState } from 'react'
import { BankLogo } from '../shared/BankLogo'
import { CardToggle } from './CardToggle'
import type { CardRow } from '../../types/reward'
import type { BankRow } from '../../types/reward'

interface BankSectionProps {
  bank: BankRow
  cards: CardRow[]
  selectedCardIds: string[]
  onToggle: (cardId: string) => void
}

export function BankSection({ bank, cards, selectedCardIds, onToggle }: BankSectionProps) {
  const [isExpanded, setIsExpanded] = useState(true)

  const selectedCount = cards.filter(c => selectedCardIds.includes(c.id)).length

  return (
    <div className="border-b border-border">
      {/* Bank header */}
      <button
        type="button"
        onClick={() => setIsExpanded(prev => !prev)}
        className="w-full flex items-center gap-3 px-4 py-3.5 hover:bg-white/5 active:bg-white/10 transition-colors text-left"
      >
        <BankLogo
          bankSlug={bank.slug}
          bankName={bank.display_name}
          brandColor={bank.brand_color}
          size="sm"
        />
        <span className="flex-1 font-mono text-sm font-medium text-text-primary">
          {bank.display_name}
        </span>
        {selectedCount > 0 && (
          <span className="font-mono text-xs text-accent mr-1">
            {selectedCount}
          </span>
        )}
        {/* Chevron */}
        <svg
          width="16"
          height="16"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
          className={`text-muted transition-transform duration-200 ${isExpanded ? 'rotate-180' : ''}`}
        >
          <path d="m6 9 6 6 6-6" />
        </svg>
      </button>

      {/* Card list */}
      {isExpanded && (
        <div className="border-t border-border/50">
          {cards.map(card => (
            <CardToggle
              key={card.id}
              card={card}
              isSelected={selectedCardIds.includes(card.id)}
              onToggle={() => onToggle(card.id)}
            />
          ))}
        </div>
      )}
    </div>
  )
}
