import { useState } from 'react'

export function TermsText() {
  const [expanded, setExpanded] = useState(false)

  return (
    <div className="text-center">
      <p className="text-muted text-xs leading-relaxed">
        By continuing, you agree to our{' '}
        <button
          type="button"
          onClick={() => setExpanded((v) => !v)}
          className="underline text-muted hover:text-text-primary transition-colors"
        >
          Terms of Service and Privacy Policy
        </button>
        .
      </p>

      {expanded && (
        <div className="mt-3 text-left text-xs text-muted leading-relaxed border border-border rounded-lg p-3 bg-surface space-y-2">
          <p>
            <strong className="text-text-primary">About Yieldly</strong><br />
            Yieldly helps you track which credit card to use for maximum rewards. It is a personal
            finance tool intended for individual, non-commercial use only.
          </p>
          <p>
            <strong className="text-text-primary">Data &amp; Privacy</strong><br />
            Your data is stored securely via Supabase. We do not sell, share, or rent your personal
            information to third parties. Card and preference data is used solely to power your
            recommendations.
          </p>
          <p>
            <strong className="text-text-primary">Use of Service</strong><br />
            This service is provided as-is with no warranties of any kind. You may delete your
            account and all associated data at any time from Settings. Continued use of the service
            constitutes acceptance of these terms.
          </p>
          <p>
            <strong className="text-text-primary">Changes</strong><br />
            We may update these terms from time to time. Material changes will be communicated via
            the app.
          </p>
          <button
            type="button"
            onClick={() => setExpanded(false)}
            className="text-accent text-xs underline"
          >
            Collapse
          </button>
        </div>
      )}
    </div>
  )
}
