import { useState, useEffect } from 'react'

const DISMISS_KEY = 'yield_install_dismissed'
const DISMISS_DURATION_MS = 7 * 24 * 60 * 60 * 1000  // 7 days

export function useInstallPrompt() {
  const [showBanner, setShowBanner] = useState(false)

  useEffect(() => {
    const isIOS = /iPhone|iPad|iPod/.test(navigator.userAgent)
    const isStandalone = (window.navigator as any).standalone === true // eslint-disable-line @typescript-eslint/no-explicit-any
    const dismissed = localStorage.getItem(DISMISS_KEY)
    const dismissedRecently = dismissed &&
      Date.now() - parseInt(dismissed) < DISMISS_DURATION_MS

    if (isIOS && !isStandalone && !dismissedRecently) {
      // Delay banner appearance slightly
      const t = setTimeout(() => setShowBanner(true), 3000)
      return () => clearTimeout(t)
    }
  }, [])

  function dismiss() {
    localStorage.setItem(DISMISS_KEY, Date.now().toString())
    setShowBanner(false)
  }

  return { showBanner, dismiss }
}
