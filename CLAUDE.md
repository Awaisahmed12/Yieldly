# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
npm run dev        # Start dev server with HMR
npm run build      # Type-check + build to /dist
npm run lint       # ESLint (TypeScript strict rules)
npm run preview    # Preview production build locally
```

No test framework is configured. TypeScript strict mode (`noUnusedLocals`, `noUnusedParameters`) acts as a compile-time safety net — `npm run build` will fail on type errors.

## Environment

Requires `.env.local` with:
```
VITE_SUPABASE_URL=...
VITE_SUPABASE_ANON_KEY=...
```

## Architecture

**Yield** is a mobile-first PWA that ranks a user's credit cards by reward rate for a given spending category.

### Data Flow

```
Supabase (static tables) → useRewardData() [module-level cache]
                                ↓
useRewardLookup(slug) → rewards.ts (pure CPD computation) → ResultPage
useCategories()       → categories.ts (visibility logic) → HomePage grid
```

### State

`src/store/userStore.ts` (Zustand) is the single source of truth for auth/user state: `user`, `session`, `userCards`, `userCardIds`, `prefs`. Initialized by `useAuth()` on mount.

### Core Logic (pure functions)

- `src/lib/rewards.ts` — CPD (cents-per-dollar) computation and card ranking. Cashback: `rate/100`, Multiplier: `(rate × cpp)/100`. Uses `src/data/cpp.ts` for points valuations.
- `src/lib/tiebreaker.ts` — Detects top-rank ties (threshold: 0.0001) and returns human-readable explanations (annual fee, spend cap, cashback simplicity).
- `src/lib/categories.ts` — Derives visible categories from user's card set. Brand categories (Amazon, Costco, etc.) are unlocked per card via `card_unlocks` table. Subprompt sheets appear when ≥2 brand children are unlocked.

### Route Structure

```
/auth           → OTP authentication
/onboarding     → Card selection (blocked until auth)
/               → Category grid (requires onboarding_complete)
/result/:slug   → Ranked card results for a category
/settings       → Manage cards
```

`ProtectedRoute` in `App.tsx` enforces both auth and onboarding gating.

### Database

Supabase/PostgreSQL with RLS. Key tables: `banks`, `cards` (57), `categories` (29, hierarchical), `reward_rates` (207), `card_unlocks` (21), `user_cards`, `user_preferences`. All static tables have public read access. Migrations in `supabase/migrations/`, seed data in `supabase/seed/`.

### Design System

Tailwind with custom tokens in `tailwind.config.ts`: dark background (`#0a0a08`), lime accent (`#c8f542`), DM Mono + Fraunces fonts. Mobile-first: `max-w-[480px]` constraints, `dvh` units.
