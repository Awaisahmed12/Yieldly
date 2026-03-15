import { useState, useEffect, useCallback } from 'react'
import { Navigate } from 'react-router-dom'
import { Trash2, Upload, ChevronDown, ChevronUp } from 'lucide-react'
import { supabase } from '../lib/supabase'
import { useUserStore } from '../store/userStore'

// ── Types ─────────────────────────────────────────────────────────────────────

type Tab = 'banks' | 'cards' | 'categories' | 'rates' | 'unlocks' | 'import'

interface Bank { id: string; slug: string; display_name: string; brand_color: string; sort_order: number }
interface Card { id: string; bank_id: string; slug: string; display_name: string; full_name: string; reward_currency: string; annual_fee: number; is_active: boolean; is_business: boolean }
interface Category { id: string; slug: string; display_name: string; icon_name: string; is_brand: boolean; parent_slug: string | null; sort_order: number }
interface Rate { id: string; card_id: string; category_slug: string; rate: number; rate_type: string; cap_amount: number | null; cap_period: string | null; notes: string | null }
interface Unlock { card_id: string; category_slug: string }

// ── Helpers ───────────────────────────────────────────────────────────────────

function isAdmin(session: ReturnType<typeof useUserStore.getState>['session']): boolean {
  return session?.user?.app_metadata?.role === 'admin'
}

function ErrorMsg({ msg }: { msg: string }) {
  return <p className="text-red-400 font-mono text-xs mt-2">{msg}</p>
}

function Label({ children }: { children: React.ReactNode }) {
  return <label className="block text-xs text-muted font-mono mb-1 uppercase tracking-wide">{children}</label>
}

function Input({ ...props }: React.InputHTMLAttributes<HTMLInputElement>) {
  return (
    <input
      {...props}
      className="w-full bg-surface border border-border rounded px-3 py-2 text-text-primary font-mono text-sm focus:outline-none focus:border-accent transition-colors"
    />
  )
}

function Select({ children, ...props }: React.SelectHTMLAttributes<HTMLSelectElement>) {
  return (
    <select
      {...props}
      className="w-full bg-surface border border-border rounded px-3 py-2 text-text-primary font-mono text-sm focus:outline-none focus:border-accent transition-colors"
    >
      {children}
    </select>
  )
}

function Btn({ children, variant = 'primary', ...props }: React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: 'primary' | 'ghost' | 'danger' }) {
  const base = 'font-mono text-xs px-3 py-1.5 rounded transition-opacity disabled:opacity-40'
  const styles = {
    primary: 'bg-accent text-bg hover:opacity-90',
    ghost: 'border border-border text-muted hover:text-text-primary',
    danger: 'bg-red-500/20 text-red-400 hover:bg-red-500/30',
  }
  return <button {...props} className={`${base} ${styles[variant]} ${props.className ?? ''}`}>{children}</button>
}

function SectionToggle({ title, children }: { title: string; children: React.ReactNode }) {
  const [open, setOpen] = useState(false)
  return (
    <div className="border border-border rounded-lg overflow-hidden">
      <button
        type="button"
        onClick={() => setOpen(v => !v)}
        className="w-full flex items-center justify-between px-4 py-3 text-left font-mono text-sm text-text-primary hover:bg-white/5 transition-colors"
      >
        {title}
        {open ? <ChevronUp size={14} /> : <ChevronDown size={14} />}
      </button>
      {open && <div className="px-4 pb-4 border-t border-border">{children}</div>}
    </div>
  )
}

// ── Banks Tab ─────────────────────────────────────────────────────────────────

function BanksTab() {
  const [banks, setBanks] = useState<Bank[]>([])
  const [loading, setLoading] = useState(true)
  const [err, setErr] = useState('')
  const [form, setForm] = useState({ slug: '', display_name: '', brand_color: '#000000', sort_order: '0' })

  const load = useCallback(async () => {
    setLoading(true)
    const { data, error } = await supabase.from('banks').select('*').order('sort_order')
    if (error) setErr(error.message)
    else setBanks((data ?? []) as Bank[])
    setLoading(false)
  }, [])

  useEffect(() => { load() }, [load])

  async function handleAdd(e: React.FormEvent) {
    e.preventDefault()
    setErr('')
    const { error } = await supabase.from('banks').insert({
      slug: form.slug.trim(),
      display_name: form.display_name.trim(),
      brand_color: form.brand_color,
      sort_order: parseInt(form.sort_order) || 0,
    })
    if (error) { setErr(error.message); return }
    setForm({ slug: '', display_name: '', brand_color: '#000000', sort_order: '0' })
    load()
  }

  async function handleDelete(id: string) {
    if (!confirm('Delete this bank? This may fail if cards reference it.')) return
    const { error } = await supabase.from('banks').delete().eq('id', id)
    if (error) setErr(error.message)
    else load()
  }

  return (
    <div className="space-y-4">
      <SectionToggle title="+ Add Bank">
        <form onSubmit={handleAdd} className="grid grid-cols-2 gap-3 pt-3">
          <div><Label>Slug</Label><Input value={form.slug} onChange={e => setForm(f => ({ ...f, slug: e.target.value }))} placeholder="e.g. chase" required /></div>
          <div><Label>Display Name</Label><Input value={form.display_name} onChange={e => setForm(f => ({ ...f, display_name: e.target.value }))} placeholder="e.g. Chase" required /></div>
          <div><Label>Brand Color</Label><Input type="color" value={form.brand_color} onChange={e => setForm(f => ({ ...f, brand_color: e.target.value }))} /></div>
          <div><Label>Sort Order</Label><Input type="number" value={form.sort_order} onChange={e => setForm(f => ({ ...f, sort_order: e.target.value }))} /></div>
          <div className="col-span-2"><Btn type="submit">Add Bank</Btn></div>
        </form>
      </SectionToggle>

      {err && <ErrorMsg msg={err} />}

      {loading ? (
        <p className="font-mono text-xs text-muted">Loading...</p>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-xs font-mono">
            <thead><tr className="border-b border-border text-muted">
              <th className="text-left py-2 pr-4">Slug</th>
              <th className="text-left py-2 pr-4">Name</th>
              <th className="text-left py-2 pr-4">Color</th>
              <th className="text-left py-2 pr-4">Order</th>
              <th />
            </tr></thead>
            <tbody>
              {banks.map(b => (
                <tr key={b.id} className="border-b border-border/30 hover:bg-white/5">
                  <td className="py-2 pr-4 text-accent">{b.slug}</td>
                  <td className="py-2 pr-4">{b.display_name}</td>
                  <td className="py-2 pr-4 flex items-center gap-2">
                    <span className="w-4 h-4 rounded-full inline-block border border-border" style={{ background: b.brand_color }} />
                    {b.brand_color}
                  </td>
                  <td className="py-2 pr-4">{b.sort_order}</td>
                  <td className="py-2">
                    <button onClick={() => handleDelete(b.id)} className="text-red-400 hover:text-red-300"><Trash2 size={12} /></button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}

// ── Cards Tab ─────────────────────────────────────────────────────────────────

function CardsTab() {
  const [cards, setCards] = useState<Card[]>([])
  const [banks, setBanks] = useState<Bank[]>([])
  const [loading, setLoading] = useState(true)
  const [err, setErr] = useState('')
  const [form, setForm] = useState({
    bank_id: '', slug: '', display_name: '', full_name: '',
    reward_currency: 'CB', annual_fee: '0', is_business: 'false',
  })

  const load = useCallback(async () => {
    setLoading(true)
    const [cardsRes, banksRes] = await Promise.all([
      supabase.from('cards').select('*').order('display_name'),
      supabase.from('banks').select('*').order('display_name'),
    ])
    if (cardsRes.error) setErr(cardsRes.error.message)
    else setCards((cardsRes.data ?? []) as Card[])
    if (banksRes.data) setBanks(banksRes.data as Bank[])
    setLoading(false)
  }, [])

  useEffect(() => { load() }, [load])

  async function handleAdd(e: React.FormEvent) {
    e.preventDefault()
    setErr('')
    const { error } = await supabase.from('cards').insert({
      bank_id: form.bank_id,
      slug: form.slug.trim(),
      display_name: form.display_name.trim(),
      full_name: form.full_name.trim(),
      reward_currency: form.reward_currency.trim(),
      annual_fee: parseFloat(form.annual_fee) || 0,
      is_business: form.is_business === 'true',
    })
    if (error) { setErr(error.message); return }
    setForm({ bank_id: form.bank_id, slug: '', display_name: '', full_name: '', reward_currency: 'CB', annual_fee: '0', is_business: 'false' })
    load()
  }

  async function handleToggleActive(card: Card) {
    await supabase.from('cards').update({ is_active: !card.is_active }).eq('id', card.id)
    load()
  }

  async function handleDelete(id: string) {
    if (!confirm('Delete this card? All associated rates and unlocks will be removed.')) return
    const { error } = await supabase.from('cards').delete().eq('id', id)
    if (error) setErr(error.message)
    else load()
  }

  const bankMap = Object.fromEntries(banks.map(b => [b.id, b.display_name]))

  return (
    <div className="space-y-4">
      <SectionToggle title="+ Add Card">
        <form onSubmit={handleAdd} className="grid grid-cols-2 gap-3 pt-3">
          <div className="col-span-2">
            <Label>Bank</Label>
            <Select value={form.bank_id} onChange={e => setForm(f => ({ ...f, bank_id: e.target.value }))} required>
              <option value="">Select bank…</option>
              {banks.map(b => <option key={b.id} value={b.id}>{b.display_name}</option>)}
            </Select>
          </div>
          <div><Label>Slug</Label><Input value={form.slug} onChange={e => setForm(f => ({ ...f, slug: e.target.value }))} placeholder="e.g. chase_freedom_unlimited" required /></div>
          <div><Label>Display Name</Label><Input value={form.display_name} onChange={e => setForm(f => ({ ...f, display_name: e.target.value }))} placeholder="e.g. Freedom Unlimited" required /></div>
          <div className="col-span-2"><Label>Full Name</Label><Input value={form.full_name} onChange={e => setForm(f => ({ ...f, full_name: e.target.value }))} placeholder="e.g. Chase Freedom Unlimited®" required /></div>
          <div><Label>Reward Currency</Label><Input value={form.reward_currency} onChange={e => setForm(f => ({ ...f, reward_currency: e.target.value }))} placeholder="CB / UR / MR / …" required /></div>
          <div><Label>Annual Fee ($)</Label><Input type="number" value={form.annual_fee} onChange={e => setForm(f => ({ ...f, annual_fee: e.target.value }))} /></div>
          <div>
            <Label>Business Card</Label>
            <Select value={form.is_business} onChange={e => setForm(f => ({ ...f, is_business: e.target.value }))}>
              <option value="false">No</option>
              <option value="true">Yes</option>
            </Select>
          </div>
          <div className="col-span-2"><Btn type="submit">Add Card</Btn></div>
        </form>
      </SectionToggle>

      {err && <ErrorMsg msg={err} />}

      {loading ? (
        <p className="font-mono text-xs text-muted">Loading...</p>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-xs font-mono">
            <thead><tr className="border-b border-border text-muted">
              <th className="text-left py-2 pr-3">Slug</th>
              <th className="text-left py-2 pr-3">Name</th>
              <th className="text-left py-2 pr-3">Bank</th>
              <th className="text-left py-2 pr-3">Currency</th>
              <th className="text-left py-2 pr-3">Fee</th>
              <th className="text-left py-2 pr-3">Active</th>
              <th />
            </tr></thead>
            <tbody>
              {cards.map(c => (
                <tr key={c.id} className={`border-b border-border/30 hover:bg-white/5 ${!c.is_active ? 'opacity-40' : ''}`}>
                  <td className="py-1.5 pr-3 text-accent">{c.slug}</td>
                  <td className="py-1.5 pr-3">{c.display_name}</td>
                  <td className="py-1.5 pr-3 text-muted">{bankMap[c.bank_id] ?? '—'}</td>
                  <td className="py-1.5 pr-3">{c.reward_currency}</td>
                  <td className="py-1.5 pr-3">${c.annual_fee}</td>
                  <td className="py-1.5 pr-3">
                    <button onClick={() => handleToggleActive(c)} className={`text-xs ${c.is_active ? 'text-accent' : 'text-muted'}`}>
                      {c.is_active ? 'yes' : 'no'}
                    </button>
                  </td>
                  <td className="py-1.5">
                    <button onClick={() => handleDelete(c.id)} className="text-red-400 hover:text-red-300"><Trash2 size={12} /></button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}

// ── Categories Tab ────────────────────────────────────────────────────────────

function CategoriesTab() {
  const [categories, setCategories] = useState<Category[]>([])
  const [loading, setLoading] = useState(true)
  const [err, setErr] = useState('')
  const [form, setForm] = useState({
    slug: '', display_name: '', icon_name: '', is_brand: 'false',
    parent_slug: '', sort_order: '0',
  })

  const load = useCallback(async () => {
    setLoading(true)
    const { data, error } = await supabase.from('categories').select('*').order('sort_order')
    if (error) setErr(error.message)
    else setCategories((data ?? []) as Category[])
    setLoading(false)
  }, [])

  useEffect(() => { load() }, [load])

  async function handleAdd(e: React.FormEvent) {
    e.preventDefault()
    setErr('')
    const { error } = await supabase.from('categories').insert({
      slug: form.slug.trim(),
      display_name: form.display_name.trim(),
      icon_name: form.icon_name.trim(),
      is_brand: form.is_brand === 'true',
      parent_slug: form.parent_slug.trim() || null,
      sort_order: parseInt(form.sort_order) || 0,
    })
    if (error) { setErr(error.message); return }
    setForm({ slug: '', display_name: '', icon_name: '', is_brand: 'false', parent_slug: '', sort_order: '0' })
    load()
  }

  async function handleDelete(slug: string) {
    if (!confirm(`Delete category "${slug}"?`)) return
    const { error } = await supabase.from('categories').delete().eq('slug', slug)
    if (error) setErr(error.message)
    else load()
  }

  const standard = categories.filter(c => !c.is_brand)
  const brand = categories.filter(c => c.is_brand)

  return (
    <div className="space-y-4">
      <SectionToggle title="+ Add Category">
        <form onSubmit={handleAdd} className="grid grid-cols-2 gap-3 pt-3">
          <div><Label>Slug</Label><Input value={form.slug} onChange={e => setForm(f => ({ ...f, slug: e.target.value }))} placeholder="e.g. car_rental" required /></div>
          <div><Label>Display Name</Label><Input value={form.display_name} onChange={e => setForm(f => ({ ...f, display_name: e.target.value }))} placeholder="e.g. Car Rental" required /></div>
          <div><Label>Icon Name (Lucide)</Label><Input value={form.icon_name} onChange={e => setForm(f => ({ ...f, icon_name: e.target.value }))} placeholder="e.g. Car" required /></div>
          <div><Label>Sort Order</Label><Input type="number" value={form.sort_order} onChange={e => setForm(f => ({ ...f, sort_order: e.target.value }))} /></div>
          <div>
            <Label>Brand Category</Label>
            <Select value={form.is_brand} onChange={e => setForm(f => ({ ...f, is_brand: e.target.value }))}>
              <option value="false">No (standard)</option>
              <option value="true">Yes (brand)</option>
            </Select>
          </div>
          <div>
            <Label>Parent Slug (brand only)</Label>
            <Select value={form.parent_slug} onChange={e => setForm(f => ({ ...f, parent_slug: e.target.value }))}>
              <option value="">None</option>
              {standard.map(c => <option key={c.slug} value={c.slug}>{c.slug}</option>)}
            </Select>
          </div>
          <div className="col-span-2"><Btn type="submit">Add Category</Btn></div>
        </form>
      </SectionToggle>

      {err && <ErrorMsg msg={err} />}

      {loading ? (
        <p className="font-mono text-xs text-muted">Loading...</p>
      ) : (
        <div className="space-y-4">
          {[{ label: 'Standard', items: standard }, { label: 'Brand', items: brand }].map(group => (
            <div key={group.label}>
              <p className="font-mono text-xs text-muted mb-2 uppercase tracking-wider">{group.label}</p>
              <div className="overflow-x-auto">
                <table className="w-full text-xs font-mono">
                  <thead><tr className="border-b border-border text-muted">
                    <th className="text-left py-2 pr-3">Slug</th>
                    <th className="text-left py-2 pr-3">Name</th>
                    <th className="text-left py-2 pr-3">Icon</th>
                    <th className="text-left py-2 pr-3">Parent</th>
                    <th className="text-left py-2 pr-3">Order</th>
                    <th />
                  </tr></thead>
                  <tbody>
                    {group.items.map(c => (
                      <tr key={c.slug} className="border-b border-border/30 hover:bg-white/5">
                        <td className="py-1.5 pr-3 text-accent">{c.slug}</td>
                        <td className="py-1.5 pr-3">{c.display_name}</td>
                        <td className="py-1.5 pr-3 text-muted">{c.icon_name}</td>
                        <td className="py-1.5 pr-3 text-muted">{c.parent_slug ?? '—'}</td>
                        <td className="py-1.5 pr-3">{c.sort_order}</td>
                        <td className="py-1.5">
                          <button onClick={() => handleDelete(c.slug)} className="text-red-400 hover:text-red-300"><Trash2 size={12} /></button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

// ── Rates Tab ─────────────────────────────────────────────────────────────────

function RatesTab() {
  const [rates, setRates] = useState<Rate[]>([])
  const [cards, setCards] = useState<Card[]>([])
  const [categories, setCategories] = useState<Category[]>([])
  const [loading, setLoading] = useState(true)
  const [err, setErr] = useState('')
  const [cardFilter, setCardFilter] = useState('')
  const [form, setForm] = useState({
    card_id: '', category_slug: '', rate: '', rate_type: 'cashback',
    cap_amount: '', cap_period: '', notes: '',
  })

  const load = useCallback(async () => {
    setLoading(true)
    const [ratesRes, cardsRes, catsRes] = await Promise.all([
      supabase.from('reward_rates').select('*').order('category_slug'),
      supabase.from('cards').select('id,slug,display_name').order('display_name'),
      supabase.from('categories').select('slug,display_name').order('slug'),
    ])
    if (ratesRes.error) setErr(ratesRes.error.message)
    else setRates((ratesRes.data ?? []) as Rate[])
    if (cardsRes.data) setCards(cardsRes.data as Card[])
    if (catsRes.data) setCategories(catsRes.data as Category[])
    setLoading(false)
  }, [])

  useEffect(() => { load() }, [load])

  async function handleAdd(e: React.FormEvent) {
    e.preventDefault()
    setErr('')
    const { error } = await supabase.from('reward_rates').insert({
      card_id: form.card_id,
      category_slug: form.category_slug,
      rate: parseFloat(form.rate),
      rate_type: form.rate_type,
      cap_amount: form.cap_amount ? parseFloat(form.cap_amount) : null,
      cap_period: form.cap_period || null,
      notes: form.notes || null,
    })
    if (error) { setErr(error.message); return }
    setForm(f => ({ ...f, category_slug: '', rate: '', cap_amount: '', cap_period: '', notes: '' }))
    load()
  }

  async function handleDelete(id: string) {
    const { error } = await supabase.from('reward_rates').delete().eq('id', id)
    if (error) setErr(error.message)
    else load()
  }

  const cardMap = Object.fromEntries(cards.map(c => [c.id, c.slug]))
  const filtered = cardFilter ? rates.filter(r => r.card_id === cardFilter) : rates

  return (
    <div className="space-y-4">
      <SectionToggle title="+ Add Rate">
        <form onSubmit={handleAdd} className="grid grid-cols-2 gap-3 pt-3">
          <div className="col-span-2">
            <Label>Card</Label>
            <Select value={form.card_id} onChange={e => setForm(f => ({ ...f, card_id: e.target.value }))} required>
              <option value="">Select card…</option>
              {cards.map(c => <option key={c.id} value={c.id}>{c.display_name}</option>)}
            </Select>
          </div>
          <div>
            <Label>Category</Label>
            <Select value={form.category_slug} onChange={e => setForm(f => ({ ...f, category_slug: e.target.value }))} required>
              <option value="">Select category…</option>
              {categories.map(c => <option key={c.slug} value={c.slug}>{c.slug}</option>)}
            </Select>
          </div>
          <div><Label>Rate</Label><Input type="number" step="0.01" value={form.rate} onChange={e => setForm(f => ({ ...f, rate: e.target.value }))} placeholder="e.g. 3" required /></div>
          <div>
            <Label>Rate Type</Label>
            <Select value={form.rate_type} onChange={e => setForm(f => ({ ...f, rate_type: e.target.value }))}>
              <option value="cashback">cashback</option>
              <option value="multiplier">multiplier</option>
            </Select>
          </div>
          <div><Label>Cap Amount ($)</Label><Input type="number" value={form.cap_amount} onChange={e => setForm(f => ({ ...f, cap_amount: e.target.value }))} placeholder="optional" /></div>
          <div>
            <Label>Cap Period</Label>
            <Select value={form.cap_period} onChange={e => setForm(f => ({ ...f, cap_period: e.target.value }))}>
              <option value="">None</option>
              <option value="monthly">monthly</option>
              <option value="quarterly">quarterly</option>
              <option value="annual">annual</option>
            </Select>
          </div>
          <div className="col-span-2"><Label>Notes</Label><Input value={form.notes} onChange={e => setForm(f => ({ ...f, notes: e.target.value }))} placeholder="optional" /></div>
          <div className="col-span-2"><Btn type="submit">Add Rate</Btn></div>
        </form>
      </SectionToggle>

      <div>
        <Label>Filter by card</Label>
        <Select value={cardFilter} onChange={e => setCardFilter(e.target.value)}>
          <option value="">All cards</option>
          {cards.map(c => <option key={c.id} value={c.id}>{c.display_name}</option>)}
        </Select>
      </div>

      {err && <ErrorMsg msg={err} />}

      {loading ? (
        <p className="font-mono text-xs text-muted">Loading...</p>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-xs font-mono">
            <thead><tr className="border-b border-border text-muted">
              <th className="text-left py-2 pr-3">Card</th>
              <th className="text-left py-2 pr-3">Category</th>
              <th className="text-left py-2 pr-3">Rate</th>
              <th className="text-left py-2 pr-3">Type</th>
              <th className="text-left py-2 pr-3">Cap</th>
              <th className="text-left py-2 pr-3">Notes</th>
              <th />
            </tr></thead>
            <tbody>
              {filtered.map(r => (
                <tr key={r.id} className="border-b border-border/30 hover:bg-white/5">
                  <td className="py-1.5 pr-3 text-accent max-w-[120px] truncate">{cardMap[r.card_id] ?? r.card_id.slice(0, 8)}</td>
                  <td className="py-1.5 pr-3">{r.category_slug}</td>
                  <td className="py-1.5 pr-3">{r.rate}{r.rate_type === 'multiplier' ? 'x' : '%'}</td>
                  <td className="py-1.5 pr-3 text-muted">{r.rate_type}</td>
                  <td className="py-1.5 pr-3 text-muted">{r.cap_amount ? `$${r.cap_amount}/${r.cap_period}` : '—'}</td>
                  <td className="py-1.5 pr-3 text-muted max-w-[150px] truncate">{r.notes ?? '—'}</td>
                  <td className="py-1.5">
                    <button onClick={() => handleDelete(r.id)} className="text-red-400 hover:text-red-300"><Trash2 size={12} /></button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          <p className="font-mono text-xs text-muted mt-2">{filtered.length} rates</p>
        </div>
      )}
    </div>
  )
}

// ── Unlocks Tab ───────────────────────────────────────────────────────────────

function UnlocksTab() {
  const [unlocks, setUnlocks] = useState<Unlock[]>([])
  const [cards, setCards] = useState<Card[]>([])
  const [categories, setCategories] = useState<Category[]>([])
  const [loading, setLoading] = useState(true)
  const [err, setErr] = useState('')
  const [form, setForm] = useState({ card_id: '', category_slug: '' })

  const load = useCallback(async () => {
    setLoading(true)
    const [unlocksRes, cardsRes, catsRes] = await Promise.all([
      supabase.from('card_unlocks').select('*'),
      supabase.from('cards').select('id,slug,display_name').order('display_name'),
      supabase.from('categories').select('slug').filter('is_brand', 'eq', true).order('slug'),
    ])
    if (unlocksRes.error) setErr(unlocksRes.error.message)
    else setUnlocks((unlocksRes.data ?? []) as Unlock[])
    if (cardsRes.data) setCards(cardsRes.data as Card[])
    if (catsRes.data) setCategories(catsRes.data as Category[])
    setLoading(false)
  }, [])

  useEffect(() => { load() }, [load])

  async function handleAdd(e: React.FormEvent) {
    e.preventDefault()
    setErr('')
    const { error } = await supabase.from('card_unlocks').insert({
      card_id: form.card_id,
      category_slug: form.category_slug,
    })
    if (error) { setErr(error.message); return }
    load()
  }

  async function handleDelete(card_id: string, category_slug: string) {
    const { error } = await supabase.from('card_unlocks')
      .delete().eq('card_id', card_id).eq('category_slug', category_slug)
    if (error) setErr(error.message)
    else load()
  }

  const cardMap = Object.fromEntries(cards.map(c => [c.id, c.display_name]))

  return (
    <div className="space-y-4">
      <SectionToggle title="+ Add Unlock">
        <form onSubmit={handleAdd} className="grid grid-cols-2 gap-3 pt-3">
          <div>
            <Label>Card</Label>
            <Select value={form.card_id} onChange={e => setForm(f => ({ ...f, card_id: e.target.value }))} required>
              <option value="">Select card…</option>
              {cards.map(c => <option key={c.id} value={c.id}>{c.display_name}</option>)}
            </Select>
          </div>
          <div>
            <Label>Brand Category</Label>
            <Select value={form.category_slug} onChange={e => setForm(f => ({ ...f, category_slug: e.target.value }))} required>
              <option value="">Select category…</option>
              {categories.map(c => <option key={c.slug} value={c.slug}>{c.slug}</option>)}
            </Select>
          </div>
          <div className="col-span-2"><Btn type="submit">Add Unlock</Btn></div>
        </form>
      </SectionToggle>

      {err && <ErrorMsg msg={err} />}

      {loading ? (
        <p className="font-mono text-xs text-muted">Loading...</p>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-xs font-mono">
            <thead><tr className="border-b border-border text-muted">
              <th className="text-left py-2 pr-4">Card</th>
              <th className="text-left py-2 pr-4">Brand Category</th>
              <th />
            </tr></thead>
            <tbody>
              {unlocks.map(u => (
                <tr key={`${u.card_id}-${u.category_slug}`} className="border-b border-border/30 hover:bg-white/5">
                  <td className="py-1.5 pr-4 text-accent">{cardMap[u.card_id] ?? u.card_id.slice(0, 8)}</td>
                  <td className="py-1.5 pr-4">{u.category_slug}</td>
                  <td className="py-1.5">
                    <button onClick={() => handleDelete(u.card_id, u.category_slug)} className="text-red-400 hover:text-red-300"><Trash2 size={12} /></button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}

// ── Import Tab ────────────────────────────────────────────────────────────────

type ImportTarget = 'banks' | 'cards' | 'categories' | 'reward_rates' | 'card_unlocks'

function ImportTab() {
  const [target, setTarget] = useState<ImportTarget>('cards')
  const [json, setJson] = useState('')
  const [status, setStatus] = useState<{ ok: boolean; msg: string } | null>(null)
  const [importing, setImporting] = useState(false)

  async function handleImport(e: React.FormEvent) {
    e.preventDefault()
    setStatus(null)
    setImporting(true)

    let rows: unknown[]
    try {
      rows = JSON.parse(json)
      if (!Array.isArray(rows)) throw new Error('Expected a JSON array')
    } catch (err) {
      setStatus({ ok: false, msg: `JSON parse error: ${err instanceof Error ? err.message : String(err)}` })
      setImporting(false)
      return
    }

    const { error } = await supabase.from(target).upsert(rows as Record<string, unknown>[], { onConflict: 'slug' })
    if (error) {
      setStatus({ ok: false, msg: error.message })
    } else {
      setStatus({ ok: true, msg: `Imported ${rows.length} rows into ${target}` })
      setJson('')
    }
    setImporting(false)
  }

  const examples: Record<ImportTarget, string> = {
    banks: JSON.stringify([{ slug: 'example_bank', display_name: 'Example Bank', brand_color: '#123456', sort_order: 99 }], null, 2),
    cards: JSON.stringify([{ slug: 'example_card', display_name: 'Example Card', full_name: 'Example Card Full Name', reward_currency: 'CB', annual_fee: 0, is_business: false }], null, 2),
    categories: JSON.stringify([{ slug: 'example_cat', display_name: 'Example', icon_name: 'Tag', is_brand: false, sort_order: 99 }], null, 2),
    reward_rates: JSON.stringify([{ category_slug: 'dining', rate: 3, rate_type: 'cashback' }], null, 2),
    card_unlocks: JSON.stringify([{ category_slug: 'amazon' }], null, 2),
  }

  return (
    <div className="space-y-4">
      <div>
        <p className="font-mono text-xs text-muted mb-3">
          Paste a JSON array of rows to bulk-upsert into any table. For cards, the bank_id must be a valid UUID — look up the bank first from the Banks tab.
        </p>
        <form onSubmit={handleImport} className="space-y-3">
          <div>
            <Label>Target Table</Label>
            <Select value={target} onChange={e => setTarget(e.target.value as ImportTarget)}>
              <option value="banks">banks</option>
              <option value="cards">cards</option>
              <option value="categories">categories</option>
              <option value="reward_rates">reward_rates</option>
              <option value="card_unlocks">card_unlocks</option>
            </Select>
          </div>

          <div>
            <div className="flex items-center justify-between mb-1">
              <Label>JSON Array</Label>
              <button type="button" onClick={() => setJson(examples[target])} className="font-mono text-xs text-accent hover:opacity-80">load example</button>
            </div>
            <textarea
              value={json}
              onChange={e => setJson(e.target.value)}
              rows={12}
              placeholder={`[\n  { ... }\n]`}
              required
              className="w-full bg-surface border border-border rounded px-3 py-2 text-text-primary font-mono text-xs focus:outline-none focus:border-accent transition-colors resize-y"
            />
          </div>

          {status && (
            <p className={`font-mono text-xs ${status.ok ? 'text-accent' : 'text-red-400'}`}>{status.msg}</p>
          )}

          <Btn type="submit" disabled={importing}>
            <Upload size={12} className="inline mr-1.5" />
            {importing ? 'Importing…' : 'Import'}
          </Btn>
        </form>
      </div>
    </div>
  )
}

// ── Main Admin Page ───────────────────────────────────────────────────────────

export function AdminPage() {
  const session = useUserStore(s => s.session)
  const { user, loading } = useUserStore()
  const [tab, setTab] = useState<Tab>('banks')

  if (loading) {
    return (
      <div className="min-h-dvh bg-bg flex items-center justify-center">
        <div className="text-muted font-mono text-sm animate-pulse">Loading...</div>
      </div>
    )
  }

  if (!user || !isAdmin(session)) {
    return <Navigate to="/" replace />
  }

  const tabs: { key: Tab; label: string }[] = [
    { key: 'banks', label: 'Banks' },
    { key: 'cards', label: 'Cards' },
    { key: 'categories', label: 'Categories' },
    { key: 'rates', label: 'Rates' },
    { key: 'unlocks', label: 'Unlocks' },
    { key: 'import', label: 'Import' },
  ]

  return (
    <div className="min-h-dvh bg-bg" style={{ paddingTop: 'env(safe-area-inset-top)' }}>
      <div className="max-w-[900px] mx-auto px-4 py-6">
        {/* Header */}
        <div className="flex items-center justify-between mb-6">
          <div>
            <p className="font-mono text-xs text-accent uppercase tracking-widest mb-1">Yield Admin</p>
            <h1 className="font-serif text-2xl font-semibold text-text-primary">Data Console</h1>
          </div>
          <div className="flex items-center gap-2">
            <span className="font-mono text-xs text-muted">{user.email}</span>
            <span className="font-mono text-xs bg-accent/20 text-accent px-2 py-0.5 rounded">admin</span>
          </div>
        </div>

        {/* Tabs */}
        <div className="flex gap-1 mb-6 border-b border-border pb-0">
          {tabs.map(t => (
            <button
              key={t.key}
              onClick={() => setTab(t.key)}
              className={`font-mono text-xs px-4 py-2 transition-colors border-b-2 -mb-[1px] ${
                tab === t.key
                  ? 'border-accent text-accent'
                  : 'border-transparent text-muted hover:text-text-primary'
              }`}
            >
              {t.label}
            </button>
          ))}
        </div>

        {/* Tab content */}
        <div>
          {tab === 'banks' && <BanksTab />}
          {tab === 'cards' && <CardsTab />}
          {tab === 'categories' && <CategoriesTab />}
          {tab === 'rates' && <RatesTab />}
          {tab === 'unlocks' && <UnlocksTab />}
          {tab === 'import' && <ImportTab />}
        </div>
      </div>
    </div>
  )
}
