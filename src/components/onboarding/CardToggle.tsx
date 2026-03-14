import type { CardRow } from '../../types/reward'

interface CardToggleProps {
  card: CardRow
  isSelected: boolean
  onToggle: () => void
}

export function CardToggle({ card, isSelected, onToggle }: CardToggleProps) {
  return (
    <button
      type="button"
      onClick={onToggle}
      className="w-full flex items-center gap-3 px-4 py-3 hover:bg-white/5 active:bg-white/10 transition-colors text-left"
    >
      {/* Checkbox */}
      <div
        className={`w-5 h-5 rounded flex-shrink-0 flex items-center justify-center border transition-colors ${
          isSelected
            ? 'bg-accent border-accent'
            : 'border-border bg-surface'
        }`}
      >
        {isSelected && (
          <svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="#0a0a08" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
            <path d="M2 6l3 3 5-5" />
          </svg>
        )}
      </div>

      {/* Card info */}
      <div className="flex-1 min-w-0">
        <span className="font-mono text-sm text-text-primary leading-snug block truncate">
          {card.display_name}
        </span>
        {card.annual_fee > 0 && (
          <span className="font-mono text-xs text-muted leading-snug">
            (${card.annual_fee}/yr)
          </span>
        )}
      </div>

      {/* Business badge */}
      {card.is_business && (
        <span className="font-mono text-xs text-muted border border-border rounded px-1.5 py-0.5 flex-shrink-0">
          Business
        </span>
      )}
    </button>
  )
}
