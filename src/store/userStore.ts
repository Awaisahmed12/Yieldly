import { create } from 'zustand'
import type { User, Session } from '@supabase/supabase-js'
import type { CardRow, UserPreferencesRow } from '../types/supabase'

interface UserState {
  user: User | null
  session: Session | null
  userCards: CardRow[]
  userCardIds: string[]
  prefs: UserPreferencesRow | null
  loading: boolean
  isGuest: boolean
  hasCustomizedCards: boolean
  showSaveNudge: boolean
  setSession: (session: Session | null) => void
  setUser: (user: User | null) => void
  setUserCards: (cards: CardRow[]) => void
  setPrefs: (prefs: UserPreferencesRow | null) => void
  setLoading: (loading: boolean) => void
  reset: () => void
  setGuestCards: (cards: CardRow[], hasCustomized: boolean) => void
  clearGuest: () => void
  showSaveNudgePrompt: () => void
  dismissSaveNudge: () => void
}

const initialState = {
  user: null,
  session: null,
  userCards: [],
  userCardIds: [],
  prefs: null,
  loading: true,
  isGuest: false,
  hasCustomizedCards: false,
  showSaveNudge: false,
}

export const useUserStore = create<UserState>((set) => ({
  ...initialState,

  setSession: (session) => set({ session }),

  setUser: (user) => set({ user }),

  setUserCards: (cards) =>
    set({
      userCards: cards,
      userCardIds: cards.map((c) => c.id),
    }),

  setPrefs: (prefs) => set({ prefs }),

  setLoading: (loading) => set({ loading }),

  reset: () => set(initialState),

  setGuestCards: (cards, hasCustomized) =>
    set({
      userCards: cards,
      userCardIds: cards.map((c) => c.id),
      isGuest: true,
      hasCustomizedCards: hasCustomized,
    }),

  clearGuest: () =>
    set({
      isGuest: false,
      hasCustomizedCards: false,
      showSaveNudge: false,
    }),

  showSaveNudgePrompt: () => set({ showSaveNudge: true }),

  dismissSaveNudge: () => set({ showSaveNudge: false }),
}))
