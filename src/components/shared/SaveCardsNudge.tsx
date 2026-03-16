interface SaveCardsNudgeProps {
  variant: 'personalize' | 'save'
  onConfirm: () => void
  onDismiss: () => void
}

export function SaveCardsNudge({ variant, onConfirm, onDismiss }: SaveCardsNudgeProps) {
  const isPersonalize = variant === 'personalize'

  return (
    <div className="fixed bottom-0 left-0 right-0 z-50 flex justify-center pointer-events-none">
      <div
        className="w-full max-w-[480px] pointer-events-auto"
        style={{ paddingBottom: 'env(safe-area-inset-bottom)' }}
      >
        <div className="mx-3 mb-3 bg-surface border border-border rounded-xl px-5 py-4 shadow-lg">
          <p className="font-mono text-[10px] text-accent uppercase tracking-[0.18em] mb-1.5">
            {isPersonalize ? 'Popular cards' : 'Your wallet'}
          </p>
          <p className="font-serif text-base text-text-primary leading-snug mb-3">
            {isPersonalize
              ? 'These are popular cards. Have your own? Set up your wallet for personalized results.'
              : 'Your cards are saved on this device only. Create a free account to sync across devices.'}
          </p>
          <div className="flex gap-2">
            <button
              type="button"
              onClick={onConfirm}
              className="flex-1 bg-accent text-bg font-mono text-xs font-medium py-2.5 px-4 rounded-lg hover:opacity-90 active:opacity-80 transition-opacity"
            >
              {isPersonalize ? 'Personalize →' : 'Save my cards — it\'s free'}
            </button>
            <button
              type="button"
              onClick={onDismiss}
              className="font-mono text-xs text-muted hover:text-text-primary transition-colors px-3 py-2.5"
            >
              {isPersonalize ? 'These look fine' : 'Maybe later'}
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
