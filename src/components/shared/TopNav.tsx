import { Link, useNavigate } from 'react-router-dom'

interface TopNavProps {
  showBack?: boolean
  showSettings?: boolean
  title?: string
}

export function TopNav({ showBack = false, showSettings = false, title }: TopNavProps) {
  const navigate = useNavigate()

  return (
    <header
      className="sticky top-0 z-10 bg-bg border-b border-border flex items-center justify-between px-4"
      style={{ paddingTop: 'env(safe-area-inset-top)', minHeight: 'calc(3.5rem + env(safe-area-inset-top))' }}
    >
      {/* Left */}
      <div className="flex items-center">
        {showBack ? (
          <button
            type="button"
            onClick={() => navigate(-1)}
            className="text-text-primary p-1 -ml-1 hover:text-accent transition-colors"
            aria-label="Go back"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="20"
              height="20"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
            >
              <path d="m15 18-6-6 6-6" />
            </svg>
          </button>
        ) : (
          <span className="font-mono text-accent text-sm font-medium tracking-widest">
            {title ?? 'Yieldly'}
          </span>
        )}
      </div>

      {/* Center title when back shown */}
      {showBack && title && (
        <span className="absolute left-1/2 -translate-x-1/2 font-mono text-text-primary text-sm">
          {title}
        </span>
      )}

      {/* Right */}
      <div className="flex items-center">
        {showSettings && (
          <Link
            to="/settings"
            className="text-muted hover:text-text-primary transition-colors p-1 -mr-1"
            aria-label="Settings"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="20"
              height="20"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
            >
              <path d="M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z" />
              <circle cx="12" cy="12" r="3" />
            </svg>
          </Link>
        )}
      </div>
    </header>
  )
}
