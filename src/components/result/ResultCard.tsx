import { formatRate } from '../../lib/rewards'
import type { RankedResult } from '../../types/reward'
import type { BankRow } from '../../types/reward'

interface ResultCardProps {
  result: RankedResult
  bank?: BankRow | null
}

export function ResultCard({ result, bank }: ResultCardProps) {
  const brandColor = bank?.brand_color ?? '#1a1a18'

  return (
    <div
      className="relative mx-4 rounded-2xl overflow-hidden"
      style={{
        background: `radial-gradient(ellipse at 80% 10%, ${brandColor}cc 0%, ${brandColor}66 40%, #111110 100%)`,
        border: `1px solid ${brandColor}40`,
      }}
    >
      {/* BEST CARD badge */}
      <div className="absolute top-3 right-3 z-10">
        <span className="font-mono text-xs font-medium bg-accent text-bg px-2 py-1 rounded-full tracking-wide">
          BEST CARD
        </span>
      </div>

      {/* Content */}
      <div className="px-5 pt-6 pb-5">
        {/* Card name */}
        <h2 className="font-serif text-2xl font-semibold text-white leading-tight pr-20 mb-6">
          {result.card.display_name}
        </h2>

        {/* Bottom row */}
        <div className="flex items-end justify-between">
          <div>
            {bank && (
              <p className="font-mono text-xs text-white/50 mb-0.5">
                {bank.display_name}
              </p>
            )}
            {result.notes && (
              <p className="font-mono text-xs text-white/60 leading-snug max-w-[200px]">
                {result.notes}
              </p>
            )}
          </div>
          <div className="text-right">
            <p className="font-serif text-3xl font-bold text-white leading-none">
              {formatRate(result)}
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
