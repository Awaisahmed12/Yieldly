import { useEffect, useRef } from 'react'
import { createPortal } from 'react-dom'

interface BottomSheetProps {
  isOpen: boolean
  onClose: () => void
  children: React.ReactNode
  title?: string
}

export function BottomSheet({ isOpen, onClose, children, title }: BottomSheetProps) {
  const sheetRef = useRef<HTMLDivElement>(null)
  const firstFocusableRef = useRef<HTMLButtonElement>(null)

  // Trap focus when open
  useEffect(() => {
    if (!isOpen) return

    const sheet = sheetRef.current
    if (!sheet) return

    // Focus the sheet on open
    firstFocusableRef.current?.focus()

    function handleKeyDown(e: KeyboardEvent) {
      if (e.key === 'Escape') {
        onClose()
        return
      }

      if (e.key === 'Tab') {
        const focusable = sheet!.querySelectorAll<HTMLElement>(
          'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
        )
        const focusableArray = Array.from(focusable)
        if (focusableArray.length === 0) return

        const first = focusableArray[0]
        const last = focusableArray[focusableArray.length - 1]

        if (e.shiftKey) {
          if (document.activeElement === first) {
            e.preventDefault()
            last.focus()
          }
        } else {
          if (document.activeElement === last) {
            e.preventDefault()
            first.focus()
          }
        }
      }
    }

    document.addEventListener('keydown', handleKeyDown)
    return () => document.removeEventListener('keydown', handleKeyDown)
  }, [isOpen, onClose])

  // Lock body scroll when open
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = ''
    }
    return () => {
      document.body.style.overflow = ''
    }
  }, [isOpen])

  // Shift sheet above keyboard on iOS (layout viewport doesn't resize when keyboard opens)
  useEffect(() => {
    const sheet = sheetRef.current
    if (!sheet || !window.visualViewport) return

    function reposition() {
      const vv = window.visualViewport!
      const offsetFromBottom = window.innerHeight - vv.height - vv.offsetTop
      sheet!.style.bottom = offsetFromBottom > 0 ? `${offsetFromBottom}px` : ''
    }

    if (isOpen) {
      window.visualViewport.addEventListener('resize', reposition)
      window.visualViewport.addEventListener('scroll', reposition)
      reposition()
    }

    return () => {
      window.visualViewport?.removeEventListener('resize', reposition)
      window.visualViewport?.removeEventListener('scroll', reposition)
      if (sheet) sheet.style.bottom = ''
    }
  }, [isOpen])

  const content = (
    <>
      {/* Overlay */}
      <div
        className={`fixed inset-0 z-40 bg-black/60 transition-opacity duration-300 ${
          isOpen ? 'opacity-100' : 'opacity-0 pointer-events-none'
        }`}
        onClick={onClose}
        aria-hidden="true"
      />

      {/* Sheet */}
      <div
        ref={sheetRef}
        role="dialog"
        aria-modal="true"
        aria-label={title ?? 'Menu'}
        className={`fixed bottom-0 left-0 right-0 z-50 flex flex-col bg-surface border-t border-border rounded-t-2xl max-h-[85vh] transition-transform duration-300 ease-out ${
          isOpen ? 'translate-y-0' : 'translate-y-full'
        }`}
      >
        {/* Handle bar */}
        <div className="flex justify-center pt-3 pb-1 flex-shrink-0">
          <div className="w-10 h-1 rounded-full bg-muted/40" />
        </div>

        {/* Header */}
        {title && (
          <div className="flex items-center justify-between px-5 py-3 border-b border-border flex-shrink-0">
            <span className="font-serif text-lg text-text-primary">{title}</span>
            <button
              ref={firstFocusableRef}
              type="button"
              onClick={onClose}
              className="text-muted hover:text-text-primary transition-colors p-1 -mr-1"
              aria-label="Close"
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M18 6 6 18M6 6l12 12" />
              </svg>
            </button>
          </div>
        )}

        {/* Content */}
        <div className="overflow-y-auto flex-1 overscroll-contain">
          {children}
        </div>
      </div>
    </>
  )

  return createPortal(content, document.body)
}
