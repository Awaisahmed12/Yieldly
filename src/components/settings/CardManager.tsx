import type { CardRow } from '../../types/reward'

interface CardManagerProps {
  cards: CardRow[]
  onAddCards: () => void
  onRemoveCard: (cardId: string) => void
}

export function CardManager({ cards, onAddCards, onRemoveCard }: CardManagerProps) {
  return (
    <div>
      <div className="flex items-center justify-between px-4 py-3">
        <h2 className="font-mono text-xs text-muted uppercase tracking-widest">My Cards</h2>
        <button
          type="button"
          onClick={onAddCards}
          className="font-mono text-xs text-accent hover:opacity-80 transition-opacity flex items-center gap-1"
        >
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
            <path d="M12 5v14M5 12h14" />
          </svg>
          Add cards
        </button>
      </div>

      {cards.length === 0 ? (
        <div className="px-4 py-8 text-center">
          <p className="font-mono text-sm text-muted">No cards added yet.</p>
          <button
            type="button"
            onClick={onAddCards}
            className="mt-3 font-mono text-sm text-accent hover:opacity-80 transition-opacity"
          >
            Add your first card →
          </button>
        </div>
      ) : (
        <div className="border-t border-border">
          {cards.map(card => (
            <div
              key={card.id}
              className="flex items-center gap-3 px-4 py-3.5 border-b border-border/50 last:border-0"
            >
              <div className="flex-1 min-w-0">
                <p className="font-mono text-sm text-text-primary truncate">
                  {card.display_name}
                </p>
                {card.annual_fee > 0 && (
                  <p className="font-mono text-xs text-muted mt-0.5">
                    ${card.annual_fee}/yr
                  </p>
                )}
              </div>
              {card.is_business && (
                <span className="font-mono text-xs text-muted border border-border rounded px-1.5 py-0.5 flex-shrink-0">
                  Business
                </span>
              )}
              <button
                type="button"
                onClick={() => onRemoveCard(card.id)}
                className="text-muted hover:text-red-400 transition-colors p-1 flex-shrink-0"
                aria-label={`Remove ${card.display_name}`}
              >
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                </svg>
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
