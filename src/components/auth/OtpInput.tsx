import { useRef, useEffect, KeyboardEvent, ClipboardEvent, ChangeEvent } from 'react'

interface OtpInputProps {
  value: string
  onChange: (value: string) => void
  onComplete?: (value: string) => void
  disabled?: boolean
}

export function OtpInput({ value, onChange, onComplete, disabled }: OtpInputProps) {
  const LENGTH = 6
  const inputRefs = useRef<(HTMLInputElement | null)[]>([])

  const digits = value.split('').slice(0, LENGTH)
  while (digits.length < LENGTH) digits.push('')

  useEffect(() => {
    // Focus first empty input on mount
    const firstEmpty = digits.findIndex((d) => d === '')
    const target = firstEmpty === -1 ? LENGTH - 1 : firstEmpty
    inputRefs.current[target]?.focus()
    // Only run on mount
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  function updateValue(index: number, digit: string) {
    const newDigits = [...digits]
    newDigits[index] = digit
    const newValue = newDigits.join('')
    onChange(newValue)
    if (newValue.replace(/\s/g, '').length === LENGTH) {
      onComplete?.(newValue)
    }
    return newDigits
  }

  function handleChange(index: number, e: ChangeEvent<HTMLInputElement>) {
    const raw = e.target.value
    // Allow only digits
    const digit = raw.replace(/\D/g, '').slice(-1)
    updateValue(index, digit)
    if (digit && index < LENGTH - 1) {
      inputRefs.current[index + 1]?.focus()
    }
  }

  function handleKeyDown(index: number, e: KeyboardEvent<HTMLInputElement>) {
    if (e.key === 'Backspace') {
      if (digits[index]) {
        updateValue(index, '')
      } else if (index > 0) {
        updateValue(index - 1, '')
        inputRefs.current[index - 1]?.focus()
      }
    } else if (e.key === 'ArrowLeft' && index > 0) {
      inputRefs.current[index - 1]?.focus()
    } else if (e.key === 'ArrowRight' && index < LENGTH - 1) {
      inputRefs.current[index + 1]?.focus()
    }
  }

  function handlePaste(e: ClipboardEvent<HTMLInputElement>) {
    e.preventDefault()
    const pasted = e.clipboardData.getData('text').replace(/\D/g, '').slice(0, LENGTH)
    if (!pasted) return
    const newDigits = [...digits]
    for (let i = 0; i < pasted.length; i++) {
      newDigits[i] = pasted[i]
    }
    const newValue = newDigits.join('')
    onChange(newValue)
    if (newValue.length === LENGTH) {
      onComplete?.(newValue)
      inputRefs.current[LENGTH - 1]?.focus()
    } else {
      inputRefs.current[pasted.length]?.focus()
    }
  }

  return (
    <div className="flex gap-2 justify-center">
      {digits.map((digit, index) => (
        <input
          key={index}
          ref={(el) => { inputRefs.current[index] = el }}
          type="text"
          inputMode="numeric"
          pattern="[0-9]*"
          maxLength={1}
          value={digit}
          disabled={disabled}
          onChange={(e) => handleChange(index, e)}
          onKeyDown={(e) => handleKeyDown(index, e)}
          onPaste={handlePaste}
          onFocus={(e) => e.target.select()}
          className={[
            'w-11 h-14 text-center text-xl font-mono rounded-lg border',
            'bg-surface text-text-primary',
            'border-border focus:border-accent focus:outline-none',
            'transition-colors duration-150',
            digit ? 'border-accent/50' : 'border-border',
            disabled ? 'opacity-50 cursor-not-allowed' : '',
          ].join(' ')}
        />
      ))}
    </div>
  )
}
