interface OnboardingProgressProps {
  current: number
  total: number
}

export function OnboardingProgress({ current, total }: OnboardingProgressProps) {
  return (
    <div className="flex items-center justify-center gap-1.5" role="progressbar" aria-valuenow={current} aria-valuemin={1} aria-valuemax={total}>
      {Array.from({ length: total }).map((_, i) => (
        <div
          key={i}
          className={`rounded-full transition-all duration-200 ${
            i + 1 === current
              ? 'w-4 h-1.5 bg-accent'
              : i + 1 < current
              ? 'w-1.5 h-1.5 bg-accent/50'
              : 'w-1.5 h-1.5 bg-border'
          }`}
        />
      ))}
    </div>
  )
}
