import type { TieInfo } from '../../types/reward'

interface TiebreakerNoteProps {
  tie: TieInfo
}

const FACTOR_ICONS: Record<string, string> = {
  annual_fee: '💳',
  no_cap: '♾️',
  cashback_simplicity: '💡',
  portal_restriction: '⚠️',
}

export function TiebreakerNote({ tie }: TiebreakerNoteProps) {
  return (
    <div className="mx-4 mt-4 rounded-xl border border-accent2/30 bg-accent2/5 p-4">
      <p className="font-mono text-xs font-medium text-accent2 uppercase tracking-wide mb-3">
        Tied — here&rsquo;s how to choose:
      </p>
      <div className="space-y-3">
        {tie.factors.map((factor, i) => (
          <div key={i} className="flex gap-2.5">
            <span className="text-sm leading-none mt-0.5 flex-shrink-0" role="img" aria-hidden="true">
              {FACTOR_ICONS[factor.type] ?? '•'}
            </span>
            <p className="font-mono text-xs text-text-primary leading-relaxed">
              {factor.explanation}
            </p>
          </div>
        ))}
      </div>
    </div>
  )
}
