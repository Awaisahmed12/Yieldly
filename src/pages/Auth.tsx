import { useState, FormEvent } from 'react'
import { supabase } from '../lib/supabase'
import { OtpInput } from '../components/auth/OtpInput'
import { TermsText } from '../components/auth/TermsText'

type AuthMethod = 'email' | 'phone'
type AuthStep = 'input' | 'otp'

export function AuthPage() {
  const [method, setMethod] = useState<AuthMethod>('email')
  const [step, setStep] = useState<AuthStep>('input')
  const [email, setEmail] = useState('')
  const [phone, setPhone] = useState('')
  const [otp, setOtp] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  function resetError() {
    setError(null)
  }

  async function handleSendOtp(e: FormEvent) {
    e.preventDefault()
    setError(null)
    setLoading(true)

    try {
      if (method === 'email') {
        const { error } = await supabase.auth.signInWithOtp({
          email: email.trim(),
          options: { shouldCreateUser: true },
        })
        if (error) throw error
      } else {
        const fullPhone = phone.startsWith('+') ? phone.trim() : `+1${phone.trim()}`
        const { error } = await supabase.auth.signInWithOtp({ phone: fullPhone })
        if (error) throw error
      }
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
      if (method === 'email') {
        const { error } = await supabase.auth.verifyOtp({
          email: email.trim(),
          token,
          type: 'email',
        })
        if (error) throw error
      } else {
        const fullPhone = phone.startsWith('+') ? phone.trim() : `+1${phone.trim()}`
        const { error } = await supabase.auth.verifyOtp({
          phone: fullPhone,
          token,
          type: 'sms',
        })
        if (error) throw error
      }
      // Auth state change listener in useAuth will handle redirect
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Invalid code. Please try again.')
      setOtp('')
    } finally {
      setLoading(false)
    }
  }

  function handleOtpComplete(value: string) {
    if (value.length === 6) {
      handleVerifyOtp(value)
    }
  }

  function handleBack() {
    setStep('input')
    setOtp('')
    setError(null)
  }

  return (
    <div className="min-h-dvh bg-bg flex flex-col items-center justify-center px-5 py-12">
      <div className="w-full max-w-sm">
        {/* Header */}
        <div className="text-center mb-8">
          <p className="text-accent font-mono text-sm tracking-widest uppercase mb-3">Yield</p>
          <h1 className="font-serif text-3xl font-semibold text-text-primary leading-tight">
            {step === 'input' ? 'Sign in or create account' : 'Enter your code'}
          </h1>
          {step === 'otp' && (
            <p className="text-muted text-sm mt-2">
              We sent a 6-digit code to{' '}
              <span className="text-text-primary">
                {method === 'email' ? email : `+1 ${phone}`}
              </span>
            </p>
          )}
        </div>

        {step === 'input' && (
          <>
            {/* Toggle */}
            <div className="flex rounded-lg border border-border bg-surface p-1 mb-6">
              <button
                type="button"
                onClick={() => { setMethod('email'); resetError() }}
                className={[
                  'flex-1 py-2 px-3 rounded-md text-sm font-mono transition-colors duration-150',
                  method === 'email'
                    ? 'bg-accent text-bg font-medium'
                    : 'text-muted hover:text-text-primary',
                ].join(' ')}
              >
                Email
              </button>
              <button
                type="button"
                onClick={() => { setMethod('phone'); resetError() }}
                className={[
                  'flex-1 py-2 px-3 rounded-md text-sm font-mono transition-colors duration-150',
                  method === 'phone'
                    ? 'bg-accent text-bg font-medium'
                    : 'text-muted hover:text-text-primary',
                ].join(' ')}
              >
                Phone number
              </button>
            </div>

            {/* Form */}
            <form onSubmit={handleSendOtp} className="space-y-4">
              {method === 'email' ? (
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
              ) : (
                <div>
                  <label className="block text-xs text-muted font-mono mb-1.5 uppercase tracking-wide">
                    Phone number
                  </label>
                  <div className="flex">
                    <span className="flex items-center px-3 bg-surface border border-r-0 border-border rounded-l-lg text-muted font-mono text-sm">
                      +1
                    </span>
                    <input
                      type="tel"
                      value={phone}
                      onChange={(e) => setPhone(e.target.value.replace(/\D/g, ''))}
                      placeholder="(555) 000-0000"
                      required
                      autoFocus
                      className="flex-1 bg-surface border border-border rounded-r-lg px-4 py-3 text-text-primary placeholder-muted font-mono text-sm focus:outline-none focus:border-accent transition-colors"
                    />
                  </div>
                </div>
              )}

              {error && (
                <p className="text-red-400 text-sm font-mono text-center">{error}</p>
              )}

              <button
                type="submit"
                disabled={loading || (method === 'email' ? !email : !phone)}
                className="w-full bg-accent text-bg font-mono font-medium py-3 px-4 rounded-lg text-sm transition-opacity disabled:opacity-50 disabled:cursor-not-allowed hover:opacity-90 active:opacity-80"
              >
                {loading ? 'Sending...' : 'Send code'}
              </button>
            </form>
          </>
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
                onClick={handleBack}
                disabled={loading}
                className="text-muted text-sm font-mono hover:text-text-primary transition-colors"
              >
                ← Change {method === 'email' ? 'email' : 'phone number'}
              </button>
            </div>
          </div>
        )}

        {/* Terms */}
        <div className="mt-8">
          <TermsText />
        </div>
      </div>
    </div>
  )
}
