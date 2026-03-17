interface GuestHeroProps {
  visible: boolean
  onDismiss: () => void
  onGetStarted: () => void
}

export function GuestHero({ visible, onDismiss, onGetStarted }: GuestHeroProps) {
  return (
    <div
      className={[
        'overflow-hidden transition-all duration-300 ease-out',
        visible ? 'max-h-[240px] opacity-100' : 'max-h-0 opacity-0 pointer-events-none',
      ].join(' ')}
    >
      <div className="mx-4 mb-4 bg-surface border border-accent/20 rounded-xl px-5 py-5">
        <p className="font-mono text-[10px] text-accent uppercase tracking-[0.18em] mb-1.5">
          Your rewards, ranked
        </p>
        <p className="font-serif text-xl font-semibold text-text-primary leading-snug">
          Which card earns you the most?
        </p>
        <p className="font-mono text-xs text-muted mt-1.5 leading-relaxed">
          Tap a category below — see your best card instantly.
          Works with popular cards. No account needed.
        </p>
        <div className="flex items-center gap-3 mt-4">
          <button
            type="button"
            onClick={onGetStarted}
            className="bg-accent text-bg font-mono text-xs font-medium py-2.5 px-4 rounded-lg hover:opacity-90 active:opacity-80 transition-opacity"
          >
            Set up your wallet →
          </button>
          <button
            type="button"
            onClick={onDismiss}
            className="font-mono text-xs text-muted hover:text-text-primary transition-colors"
          >
            Try with popular cards
          </button>
        </div>
      </div>
    </div>
  )
}
