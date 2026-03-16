export function TermsText() {
  return (
    <div className="text-center">
      <p className="text-muted text-xs leading-relaxed">
        By continuing, you agree to our{' '}
        <a
          href="/terms.html"
          target="_blank"
          rel="noopener noreferrer"
          className="underline text-muted hover:text-text-primary transition-colors"
        >
          Terms of Service
        </a>
        {' '}and{' '}
        <a
          href="/privacy.html"
          target="_blank"
          rel="noopener noreferrer"
          className="underline text-muted hover:text-text-primary transition-colors"
        >
          Privacy Policy
        </a>
        .
      </p>
    </div>
  )
}
