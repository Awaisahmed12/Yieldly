import { supabase } from './supabase'

export async function migrateGuestCards(userId: string, cardIds: string[]): Promise<void> {
  await supabase.from('user_cards').delete().eq('user_id', userId)

  if (cardIds.length > 0) {
    await supabase
      .from('user_cards')
      .insert(cardIds.map((card_id) => ({ user_id: userId, card_id })))
  }

  await supabase.from('user_preferences').upsert({
    user_id: userId,
    onboarding_complete: true,
    cpp_mode: 'default' as const,
  })
}
