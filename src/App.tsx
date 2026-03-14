import { BrowserRouter, Routes, Route, Navigate, useLocation } from 'react-router-dom'
import { useAuth } from './hooks/useAuth'
import { useUserStore } from './store/userStore'
import { AuthPage } from './pages/Auth'
import { OnboardingPage } from './pages/Onboarding'
import { HomePage } from './pages/Home'
import { SettingsPage } from './pages/Settings'

interface ProtectedRouteProps {
  children: React.ReactNode
  requireOnboarding?: boolean
}

function ProtectedRoute({ children, requireOnboarding = false }: ProtectedRouteProps) {
  const { user, loading } = useUserStore()
  const prefs = useUserStore((s) => s.prefs)
  const location = useLocation()

  if (loading) {
    return (
      <div className="min-h-dvh bg-bg flex items-center justify-center">
        <div className="text-muted font-mono text-sm animate-pulse">Loading...</div>
      </div>
    )
  }

  if (!user) {
    return <Navigate to="/auth" state={{ from: location }} replace />
  }

  if (requireOnboarding && prefs && !prefs.onboarding_complete) {
    return <Navigate to="/onboarding" replace />
  }

  return <>{children}</>
}

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

function AppRoutes() {
  // Initialize auth state at the app level
  useAuth()

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
      <Route
        path="/onboarding"
        element={
          <ProtectedRoute>
            <OnboardingPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/"
        element={
          <ProtectedRoute requireOnboarding>
            <HomePage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/settings"
        element={
          <ProtectedRoute>
            <SettingsPage />
          </ProtectedRoute>
        }
      />
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
