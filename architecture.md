# Architecture

## System Overview

Yield is a **client-side PWA** with a Supabase backend. There is no custom server — all business logic runs in the browser. Supabase provides auth, database, and RLS-enforced API.

```
┌─────────────────────────────────────────────────┐
│                   Browser (PWA)                  │
│                                                  │
│  React Router → Pages → Hooks → lib/ (pure fns) │
│                    ↕                             │
│              Zustand Store                       │
└──────────────────────┬──────────────────────────┘
                       │ Supabase JS Client
                       ↓
┌─────────────────────────────────────────────────┐
│                  Supabase Cloud                  │
│  Auth (OTP) │ PostgreSQL + RLS │ PostgREST API  │
└─────────────────────────────────────────────────┘
```

## Layers

### Pages (`src/pages/`)
Thin route components. Orchestrate hooks, handle navigation. No business logic.

### Hooks (`src/hooks/`)
Data-fetching and derived state. Each concern is isolated:
- `useAuth` — auth lifecycle
- `useRewardData` — static data cache (module-level, runs once)
- `useRewardLookup` — card ranking for a category
- `useCategories` — visible category grid
- `useUserCards` — user card CRUD
- `useInstallPrompt` — PWA install prompt

### Lib (`src/lib/`)
Pure functions with no side effects. Independently testable.
- `rewards.ts` — CPD computation, card ranking, rate formatting
- `tiebreaker.ts` — tie detection and explanation
- `categories.ts` — category unlock and visibility logic
- `supabase.ts` — Supabase client singleton

### Data (`src/data/`)
Static lookup tables bundled at build time (not fetched from DB):
- `cpp.ts` — cents-per-point values by reward program
- `banks.ts` — bank metadata
- `merchantMap.ts` — merchant-to-category mappings

### Store (`src/store/`)
Zustand store for auth/user state only. Static reward data lives in module scope (see `useRewardData`).

## Key Design Decisions

**No server-side rendering.** All rendering is client-side. Supabase handles data persistence and auth.

**Static data is bundled, not fetched.** CPP values and bank metadata live in `/src/data/` and are imported at build time for zero-latency lookups.

**Module-level caching for reward data.** `useRewardData()` stores fetched data in a module-level variable. This means the data is shared across all component instances and survives re-renders — essentially a manual singleton cache.

**Pure core logic.** `rewards.ts`, `tiebreaker.ts`, and `categories.ts` are pure functions that take data as arguments and return results. No Supabase calls, no store reads. This makes them easy to reason about and test.

**RLS as the auth layer.** Row-Level Security policies in Postgres enforce that users can only read/write their own `user_cards` and `user_preferences`. The frontend does not need to filter by user ID — Supabase handles this automatically via the session JWT.

## Reward Ranking Algorithm

```
For each card in userCards:
  1. Find reward_rate for (card_id, category_slug)
     → fallback to 'other' category rate
     → fallback to 1.0 (base earn)
  2. Compute CPD:
     - cashback: rate / 100
     - multiplier: (rate × cpp[program][mode]) / 100
  3. Sort cards by CPD descending
  4. Detect ties (CPD difference < 0.0001)
  5. Return RankedResult[] with display strings
```

## PWA Architecture

Service worker (via `vite-plugin-pwa`) caches:
- App shell (all JS/CSS bundles)
- Supabase API responses (NetworkFirst, 24h TTL)
- Google Fonts (CacheFirst, 1yr TTL)

Auto-updates: new SW activates immediately on next page load.

## Database Schema Summary

```
banks (13)
  └── cards (57)  ←── reward_rates (207) ──→ categories (29, hierarchical)
                  ←── card_unlocks (21)  ──→ categories (brand only)

auth.users
  └── user_cards (M)
  └── user_preferences (1)
```

Parent/child category hierarchy: base categories have `parent_slug = null`. Brand categories (e.g., `amazon`, `southwest`) have `parent_slug` pointing to their base (e.g., `online_shopping`, `flights`).
