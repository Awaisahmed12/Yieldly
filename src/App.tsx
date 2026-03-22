import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { useAuth } from './hooks/useAuth'
import { useGuestCardSync } from './hooks/useGuestCardSync'
import { useUserStore } from './store/userStore'
import { AuthPage } from './pages/Auth'
import { OnboardingPage } from './pages/Onboarding'
import { HomePage } from './pages/Home'
import { SettingsPage } from './pages/Settings'
import { AdminPage } from './pages/Admin'
import { OptimizePage } from './pages/Optimize'
import { ComparePage } from './pages/Compare'


function AuthRoute({ children }: { children: React.ReactNode }) {
  const { user, loading } = useUserStore()
  const prefs = useUserStore((s) => s.prefs)

  if (loading) {
    return (
      <div className="min-h-dvh bg-bg flex items-center justify-center">
        <div className="text-muted font-mono text-sm animate-pulse">Loading...</div>
      </div>
    )
  }

  if (user && prefs?.onboarding_complete) {
    return <Navigate to="/" replace />
  }

  if (user && prefs && !prefs.onboarding_complete) {
    return <Navigate to="/onboarding" replace />
  }

  return <>{children}</>
}

function OnboardingRoute({ children }: { children: React.ReactNode }) {
  const { user, loading, prefs } = useUserStore()

  if (loading) {
    return (
      <div className="min-h-dvh bg-bg flex items-center justify-center">
        <div className="text-muted font-mono text-sm animate-pulse">Loading...</div>
      </div>
    )
  }

  // Fully onboarded users don't need to see this again
  if (user && prefs?.onboarding_complete) {
    return <Navigate to="/" replace />
  }

  return <>{children}</>
}

function AppRoutes() {
  useAuth()
  useGuestCardSync()

  return (
    <Routes>
      <Route
        path="/auth"
        element={
          <AuthRoute>
            <AuthPage />
          </AuthRoute>
        }
      />
      <Route path="/onboarding" element={<OnboardingRoute><OnboardingPage /></OnboardingRoute>} />
      <Route path="/" element={<HomePage />} />
      <Route path="/settings" element={<SettingsPage />} />
      <Route path="/admin" element={<AdminPage />} />
      <Route path="/optimize" element={<OptimizePage />} />
      <Route path="/compare" element={<ComparePage />} />
      {/* Fallback */}
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}

function App() {
  return (
    <BrowserRouter>
      <AppRoutes />
    </BrowserRouter>
  )
}

export default App
