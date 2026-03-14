import { useInstallPrompt } from '../../hooks/useInstallPrompt'

export function InstallBanner() {
  const { showBanner, dismiss } = useInstallPrompt()

  return (
    <div
      className={`fixed bottom-0 left-0 right-0 z-30 transition-transform duration-300 ease-out ${
        showBanner ? 'translate-y-0' : 'translate-y-full'
      }`}
      aria-live="polite"
    >
      <div className="bg-surface border-t border-border px-4 py-3 flex items-center gap-3 max-w-[480px] mx-auto">
        {/* App icon */}
        <div className="w-10 h-10 rounded-xl bg-bg border border-border flex items-center justify-center flex-shrink-0">
          <span className="font-serif font-bold text-accent text-lg leading-none">Y</span>
        </div>

        {/* Message */}
        <div className="flex-1 min-w-0">
          <p className="font-mono text-text-primary text-xs leading-snug">
            Add to Home Screen
          </p>
          <p className="font-mono text-muted text-xs mt-0.5">
            Tap <span className="text-text-primary">Share</span> ⬆️ then &ldquo;Add to Home Screen&rdquo;
          </p>
        </div>

        {/* Dismiss */}
        <button
          type="button"
          onClick={dismiss}
          className="text-muted hover:text-text-primary transition-colors p-1 flex-shrink-0 -mr-1"
          aria-label="Dismiss install banner"
        >
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M18 6 6 18M6 6l12 12" />
          </svg>
        </button>
      </div>
    </div>
  )
}
