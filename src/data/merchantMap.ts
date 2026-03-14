export interface MerchantMapping {
  domain: string
  merchantName: string
  categorySlug: string
  confidence: 'exact' | 'high' | 'medium'
}

export const MERCHANT_MAP: MerchantMapping[] = [
  { domain: 'amazon.com',            merchantName: 'Amazon',           categorySlug: 'amazon',          confidence: 'exact' },
  { domain: 'wholefoodsmarket.com',  merchantName: 'Whole Foods',      categorySlug: 'whole_foods',     confidence: 'exact' },
  { domain: 'costco.com',            merchantName: 'Costco',           categorySlug: 'costco',          confidence: 'exact' },
  { domain: 'united.com',            merchantName: 'United Airlines',  categorySlug: 'united',          confidence: 'exact' },
  { domain: 'delta.com',             merchantName: 'Delta',            categorySlug: 'delta',           confidence: 'exact' },
  { domain: 'southwest.com',         merchantName: 'Southwest',        categorySlug: 'southwest',       confidence: 'exact' },
  { domain: 'jetblue.com',           merchantName: 'JetBlue',          categorySlug: 'jetblue',         confidence: 'exact' },
  { domain: 'hilton.com',            merchantName: 'Hilton',           categorySlug: 'hilton',          confidence: 'exact' },
  { domain: 'marriott.com',          merchantName: 'Marriott',         categorySlug: 'marriott',        confidence: 'exact' },
  { domain: 'hyatt.com',             merchantName: 'Hyatt',            categorySlug: 'hyatt',           confidence: 'exact' },
  { domain: 'uber.com',              merchantName: 'Uber',             categorySlug: 'uber',            confidence: 'exact' },
  { domain: 'ubereats.com',          merchantName: 'Uber Eats',        categorySlug: 'uber_eats',       confidence: 'exact' },
  { domain: 'lyft.com',              merchantName: 'Lyft',             categorySlug: 'transit',         confidence: 'exact' },
  { domain: 'ebay.com',              merchantName: 'eBay',             categorySlug: 'ebay',            confidence: 'exact' },
  { domain: 'netflix.com',           merchantName: 'Netflix',          categorySlug: 'streaming',       confidence: 'exact' },
  { domain: 'spotify.com',           merchantName: 'Spotify',          categorySlug: 'streaming',       confidence: 'exact' },
  { domain: 'hulu.com',              merchantName: 'Hulu',             categorySlug: 'streaming',       confidence: 'exact' },
  { domain: 'disneyplus.com',        merchantName: 'Disney+',          categorySlug: 'streaming',       confidence: 'exact' },
  { domain: 'hbomax.com',            merchantName: 'Max',              categorySlug: 'streaming',       confidence: 'exact' },
  { domain: 'max.com',               merchantName: 'Max',              categorySlug: 'streaming',       confidence: 'exact' },
  { domain: 'peacocktv.com',         merchantName: 'Peacock',          categorySlug: 'streaming',       confidence: 'exact' },
  { domain: 'apple.com',             merchantName: 'Apple',            categorySlug: 'apple',           confidence: 'exact' },
  { domain: 'target.com',            merchantName: 'Target',           categorySlug: 'online_shopping', confidence: 'high' },
  { domain: 'walmart.com',           merchantName: 'Walmart',          categorySlug: 'online_shopping', confidence: 'high' },
  { domain: 'bestbuy.com',           merchantName: 'Best Buy',         categorySlug: 'online_shopping', confidence: 'high' },
  { domain: 'chewy.com',             merchantName: 'Chewy',            categorySlug: 'online_shopping', confidence: 'high' },
  { domain: 'doordash.com',          merchantName: 'DoorDash',         categorySlug: 'dining',          confidence: 'exact' },
  { domain: 'grubhub.com',           merchantName: 'Grubhub',          categorySlug: 'dining',          confidence: 'exact' },
  { domain: 'instacart.com',         merchantName: 'Instacart',        categorySlug: 'groceries',       confidence: 'high' },
  { domain: 'walgreens.com',         merchantName: 'Walgreens',        categorySlug: 'pharmacy',        confidence: 'exact' },
  { domain: 'cvs.com',               merchantName: 'CVS',              categorySlug: 'pharmacy',        confidence: 'exact' },
  { domain: 'rite-aid.com',          merchantName: 'Rite Aid',         categorySlug: 'pharmacy',        confidence: 'exact' },
]

export function getCategoryForDomain(domain: string): MerchantMapping | null {
  const normalized = domain.replace(/^www\./, '')
  return MERCHANT_MAP.find(m => m.domain === normalized) ?? null
}
