import { useState, FormEvent } from 'react'
import { useNavigate } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { OtpInput } from '../components/auth/OtpInput'
import { TermsText } from '../components/auth/TermsText'

type AuthStep = 'input' | 'otp'
type AuthMode = 'email' | 'phone'

function formatPhone(raw: string): string {
  const digits = raw.replace(/\D/g, '')
  return digits.startsWith('1') ? `+${digits}` : `+1${digits}`
}

function formatDisplayPhone(digits: string): string {
  if (digits.length <= 3) return digits
  if (digits.length <= 6) return `(${digits.slice(0, 3)}) ${digits.slice(3)}`
  return `(${digits.slice(0, 3)}) ${digits.slice(3, 6)}-${digits.slice(6, 10)}`
}

export function AuthPage() {
  const navigate = useNavigate()
  const [step, setStep] = useState<AuthStep>('input')
  const [mode] = useState<AuthMode>('email')
  const [email, setEmail] = useState('')
  const [phone, setPhone] = useState('')
  const [otp, setOtp] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const identifier = mode === 'email' ? email.trim() : formatPhone(phone)

  async function handleSendOtp(e: FormEvent) {
    e.preventDefault()
    setError(null)
    setLoading(true)

    try {
      const { error } = mode === 'email'
        ? await supabase.auth.signInWithOtp({
            email: identifier,
            options: { shouldCreateUser: true },
          })
        : await supabase.auth.signInWithOtp({
            phone: identifier,
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
      const { error } = mode === 'email'
        ? await supabase.auth.verifyOtp({ email: identifier, token, type: 'email' })
        : await supabase.auth.verifyOtp({ phone: identifier, token, type: 'sms' })
      if (error) throw error
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


  const displayIdentifier = mode === 'email' ? identifier : identifier.replace('+1', '')

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
              <span className="text-text-primary">{displayIdentifier}</span>
            </p>
          )}
        </div>

        {step === 'input' && (
          <form onSubmit={handleSendOtp} className="space-y-4">

            {mode === 'email' ? (
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
            ) : (
              <div>
                <label className="block text-xs text-muted font-mono mb-1.5 uppercase tracking-wide">
                  Phone number
                </label>
                <div className="flex items-center bg-surface border border-border rounded-lg px-4 py-3 focus-within:border-accent transition-colors">
                  <span className="text-muted font-mono text-base mr-2">+1</span>
                  <input
                    type="tel"
                    value={formatDisplayPhone(phone)}
                    onChange={(e) => {
                      const digits = e.target.value.replace(/\D/g, '').slice(0, 10)
                      setPhone(digits)
                    }}
                    placeholder="(555) 000-0000"
                    required
                    autoFocus
                    className="flex-1 bg-transparent text-text-primary placeholder-muted font-mono text-base focus:outline-none"
                  />
                </div>
              </div>
            )}

            {error && (
              <p className="text-red-400 text-sm font-mono text-center">{error}</p>
            )}

            <button
              type="submit"
              disabled={loading || (mode === 'email' ? !email : phone.replace(/\D/g, '').length < 10)}
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
                ← Change {mode === 'email' ? 'email' : 'number'}
              </button>
            </div>
          </div>
        )}

        <div className="mt-8">
          <TermsText />
        </div>

        <div className="mt-6 text-center">
          <button
            type="button"
            onClick={() => navigate('/')}
            className="font-mono text-xs text-muted hover:text-text-primary transition-colors"
          >
            Try without an account →
          </button>
        </div>
      </div>
    </div>
  )
}
