import { useState, FormEvent } from 'react'
import { supabase } from '../lib/supabase'
import { TermsText } from '../components/auth/TermsText'

type AuthStep = 'input' | 'sent'

export function AuthPage() {
  const [step, setStep] = useState<AuthStep>('input')
  const [email, setEmail] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setError(null)
    setLoading(true)

    try {
      const { error } = await supabase.auth.signInWithOtp({
        email: email.trim(),
        options: { shouldCreateUser: true },
      })
      if (error) throw error
      setStep('sent')
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Something went wrong. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-dvh bg-bg flex flex-col items-center justify-center px-5 py-12">
      <div className="w-full max-w-sm">
        <div className="text-center mb-8">
          <p className="text-accent font-mono text-sm tracking-widest uppercase mb-3">Yield</p>
          <h1 className="font-serif text-3xl font-semibold text-text-primary leading-tight">
            {step === 'input' ? 'Sign in or create account' : 'Check your email'}
          </h1>
        </div>

        {step === 'input' && (
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-xs text-muted font-mono mb-1.5 uppercase tracking-wide">
                Email address
              </label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="you@example.com"
                required
                autoFocus
                className="w-full bg-surface border border-border rounded-lg px-4 py-3 text-text-primary placeholder-muted font-mono text-sm focus:outline-none focus:border-accent transition-colors"
              />
            </div>

            {error && (
              <p className="text-red-400 text-sm font-mono text-center">{error}</p>
            )}

            <button
              type="submit"
              disabled={loading || !email}
              className="w-full bg-accent text-bg font-mono font-medium py-3 px-4 rounded-lg text-sm transition-opacity disabled:opacity-50 disabled:cursor-not-allowed hover:opacity-90 active:opacity-80"
            >
              {loading ? 'Sending...' : 'Send link'}
            </button>
          </form>
        )}

        {step === 'sent' && (
          <div className="text-center space-y-5">
            <p className="font-mono text-sm text-muted leading-relaxed">
              We sent a magic link to{' '}
              <span className="text-text-primary">{email}</span>.
              Tap the link in the email to sign in.
            </p>
            <button
              type="button"
              onClick={() => { setStep('input'); setError(null) }}
              className="text-muted text-sm font-mono hover:text-text-primary transition-colors"
            >
              ← Use a different email
            </button>
          </div>
        )}

        <div className="mt-8">
          <TermsText />
        </div>
      </div>
    </div>
  )
}
