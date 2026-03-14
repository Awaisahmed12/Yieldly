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
  setSession: (session: Session | null) => void
  setUser: (user: User | null) => void
  setUserCards: (cards: CardRow[]) => void
  setPrefs: (prefs: UserPreferencesRow | null) => void
  setLoading: (loading: boolean) => void
  reset: () => void
}

const initialState = {
  user: null,
  session: null,
  userCards: [],
  userCardIds: [],
  prefs: null,
  loading: true,
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
}))
