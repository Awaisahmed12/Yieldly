import { createClient } from '@supabase/supabase-js'
import type { Database } from '../types/supabase'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

console.log('[supabase] URL:', supabaseUrl ?? 'UNDEFINED')
console.log('[supabase] Key:', supabaseAnonKey ? supabaseAnonKey.slice(0, 20) + '…' : 'UNDEFINED')

export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey)
