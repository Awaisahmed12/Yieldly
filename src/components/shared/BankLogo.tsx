import { useState } from 'react'

interface BankLogoProps {
  bankSlug: string
  bankName: string
  brandColor: string
  size?: 'sm' | 'md' | 'lg'
}

function getInitials(name: string): string {
  const words = name.trim().split(/\s+/)
  if (words.length === 1) return words[0].slice(0, 2).toUpperCase()
  return words
    .slice(0, 2)
    .map((w) => w[0])
    .join('')
    .toUpperCase()
}

const sizeConfig = {
  sm: { container: 'w-8 h-8 rounded-lg', text: 'text-xs', img: 'w-5 h-5' },
  md: { container: 'w-12 h-12 rounded-xl', text: 'text-base', img: 'w-7 h-7' },
  lg: { container: 'w-16 h-16 rounded-2xl', text: 'text-xl', img: 'w-10 h-10' },
}

export function BankLogo({ bankSlug, bankName, brandColor, size = 'md' }: BankLogoProps) {
  const [imgError, setImgError] = useState(false)
  const cfg = sizeConfig[size]
  const svgPath = `/bank-logos/${bankSlug}.svg`
  const initials = getInitials(bankName)

  return (
    <div
      className={`${cfg.container} flex items-center justify-center flex-shrink-0 overflow-hidden`}
      style={{ backgroundColor: brandColor }}
    >
      {!imgError ? (
        <img
          src={svgPath}
          alt={bankName}
          className={cfg.img}
          onError={() => setImgError(true)}
        />
      ) : (
        <span className={`font-serif font-bold text-white leading-none ${cfg.text}`}>
          {initials}
        </span>
      )}
    </div>
  )
}
