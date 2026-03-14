import { CreditCard, Infinity, Zap, AlertTriangle } from 'lucide-react'
import type { LucideIcon } from 'lucide-react'
import type { TieInfo } from '../../types/reward'

interface TiebreakerNoteProps {
  tie: TieInfo
}

const FACTOR_ICONS: Record<string, LucideIcon> = {
  annual_fee: CreditCard,
  no_cap: Infinity,
  cashback_simplicity: Zap,
  portal_restriction: AlertTriangle,
}

export function TiebreakerNote({ tie }: TiebreakerNoteProps) {
  return (
    <div className="mx-4 mt-4 rounded-xl border border-accent2/30 bg-accent2/5 p-4">
      <p className="font-mono text-xs font-medium text-accent2 uppercase tracking-wide mb-3">
        Tied — here&rsquo;s how to choose:
      </p>
      <div className="space-y-3">
        {tie.factors.map((factor, i) => {
          const Icon = FACTOR_ICONS[factor.type] ?? AlertTriangle
          return (
            <div key={i} className="flex gap-2.5">
              <Icon size={14} strokeWidth={1.5} className="text-accent2 flex-shrink-0 mt-0.5" />
              <p className="font-mono text-xs text-text-primary leading-relaxed">
                {factor.explanation}
              </p>
            </div>
          )
        })}
      </div>
    </div>
  )
}
