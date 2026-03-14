# State Management

## Overview

State is managed via **Zustand** (`src/store/userStore.ts`). There is a single store for all user/auth state. No context providers or prop drilling.

## Store Shape

```typescript
{
  // Auth
  user: User | null           // Supabase auth user
  session: Session | null     // Supabase session

  // User data
  userCards: CardRow[]        // Full card objects for user's selected cards
  userCardIds: string[]       // Derived IDs for fast membership checks
  prefs: UserPreferencesRow | null  // { onboarding_complete, cpp_mode }

  // UI
  loading: boolean            // Global loading flag (auth init)
}
```

## Initialization

`useAuth()` (`src/hooks/useAuth.ts`) is called once in `App.tsx`. It:
1. Subscribes to `supabase.auth.onAuthStateChange`
2. On `SIGNED_IN`: fetches `user_cards` and `user_preferences` rows, hydrates the store
3. On `SIGNED_OUT`: calls `reset()` to clear all state

## Static Data (not in store)

All static reward data (cards, categories, rates, unlocks, banks) is fetched and cached at **module level** in `useRewardData()` (`src/hooks/useRewardData.ts`). This runs once per app session, not per component mount. The data is used downstream by `useRewardLookup` and `useCategories`.

## Derived State via Hooks

| Hook | Derives |
|------|---------|
| `useCategories()` | Visible category tiles from `userCardIds` + static data |
| `useRewardLookup(slug)` | Ranked card list for a category |
| `useUserCards()` | CRUD operations on `user_cards` table |

## CPP Mode

`prefs.cpp_mode` controls whether points are valued at `high`, `default`, or `low` CPP. This flows into `rewards.ts` via `useRewardLookup`.
