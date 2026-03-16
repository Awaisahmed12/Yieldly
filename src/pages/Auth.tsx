import { useState, FormEvent } from 'react'
import { supabase } from '../lib/supabase'
import { OtpInput } from '../components/auth/OtpInput'
import { TermsText } from '../components/auth/TermsText'

type AuthStep = 'input' | 'otp'

export function AuthPage() {
  const [step, setStep] = useState<AuthStep>('input')
  const [email, setEmail] = useState('')
  const [otp, setOtp] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function handleSendOtp(e: FormEvent) {
    e.preventDefault()
    setError(null)
    setLoading(true)

    try {
      const { error } = await supabase.auth.signInWithOtp({
        email: email.trim(),
        options: { shouldCreateUser: true },
      })
      if (error) throw error
      setStep('otp')
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Something went wrong. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  async function handleVerifyOtp(token: string) {
    setError(null)
    setLoading(true)

    try {
      const { error } = await supabase.auth.verifyOtp({
        email: email.trim(),
        token,
        type: 'email',
      })
      if (error) throw error
      // Auth state change listener in useAuth will handle redirect
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Invalid code. Please try again.')
      setOtp('')
    } finally {
      setLoading(false)
    }
  }

  function handleOtpComplete(value: string) {
    if (value.length === 6) handleVerifyOtp(value)
  }

  return (
    <div className="min-h-dvh bg-bg flex flex-col items-center justify-center px-5 py-12 max-w-[480px] mx-auto" style={{ paddingTop: 'calc(3rem + env(safe-area-inset-top))' }}>
      <div className="w-full max-w-sm">
        <div className="text-center mb-8">
          <p className="text-accent font-mono text-sm tracking-widest uppercase mb-3">Yieldly</p>
          <h1 className="font-serif text-3xl font-semibold text-text-primary leading-tight">
            {step === 'input' ? 'Sign in or create account' : 'Enter your code'}
          </h1>
          {step === 'otp' && (
            <p className="text-muted text-sm mt-2 font-mono">
              We sent a 6-digit code to{' '}
              <span className="text-text-primary">{email}</span>
            </p>
          )}
        </div>

        {step === 'input' && (
          <form onSubmit={handleSendOtp} className="space-y-4">
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
                className="w-full bg-surface border border-border rounded-lg px-4 py-3 text-text-primary placeholder-muted font-mono text-base focus:outline-none focus:border-accent transition-colors"
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
              {loading ? 'Sending...' : 'Send code'}
            </button>
          </form>
        )}

        {step === 'otp' && (
          <div className="space-y-6">
            <OtpInput
              value={otp}
              onChange={setOtp}
              onComplete={handleOtpComplete}
              disabled={loading}
            />

            {error && (
              <p className="text-red-400 text-sm font-mono text-center">{error}</p>
            )}

            <button
              type="button"
              onClick={() => otp.length === 6 && handleVerifyOtp(otp)}
              disabled={loading || otp.length !== 6}
              className="w-full bg-accent text-bg font-mono font-medium py-3 px-4 rounded-lg text-sm transition-opacity disabled:opacity-50 disabled:cursor-not-allowed hover:opacity-90 active:opacity-80"
            >
              {loading ? 'Verifying...' : 'Verify code'}
            </button>

            <div className="text-center">
              <button
                type="button"
                onClick={() => { setStep('input'); setOtp(''); setError(null) }}
                disabled={loading}
                className="text-muted text-sm font-mono hover:text-text-primary transition-colors"
              >
                ← Change email
              </button>
            </div>
          </div>
        )}

        <div className="mt-8">
          <TermsText />
        </div>
      </div>
    </div>
  )
}
