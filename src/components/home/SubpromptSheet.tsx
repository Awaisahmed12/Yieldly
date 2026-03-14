import { BottomSheet } from '../shared/BottomSheet'
import type { SubpromptOption } from '../../types/reward'

interface SubpromptSheetProps {
  isOpen: boolean
  onClose: () => void
  options: SubpromptOption[]
  parentLabel: string
  onSelect: (slug: string) => void
}

export function SubpromptSheet({ isOpen, onClose, options, parentLabel, onSelect }: SubpromptSheetProps) {
  function handleSelect(slug: string) {
    onSelect(slug)
    onClose()
  }

  return (
    <BottomSheet
      isOpen={isOpen}
      onClose={onClose}
      title={`Which ${parentLabel}?`}
    >
      <div className="py-2 pb-8">
        {options.map(option => (
          <button
            key={option.slug}
            type="button"
            onClick={() => handleSelect(option.slug)}
            className="w-full flex items-center justify-between px-5 py-4 hover:bg-white/5 active:bg-white/10 transition-colors border-b border-border/50 last:border-0"
          >
            <span className="font-mono text-base text-text-primary">
              {option.label}
            </span>
            <svg
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              className="text-muted flex-shrink-0"
            >
              <path d="m9 18 6-6-6-6" />
            </svg>
          </button>
        ))}
      </div>
    </BottomSheet>
  )
}
