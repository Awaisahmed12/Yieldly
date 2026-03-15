export interface BankMeta {
  slug: string
  displayName: string
  brandColor: string
  initials: string
}

export const BANKS: BankMeta[] = [
  { slug: 'chase',       displayName: 'Chase',            brandColor: '#117ACA', initials: 'CH' },
  { slug: 'amex',        displayName: 'American Express', brandColor: '#016FD0', initials: 'AX' },
  { slug: 'citi',        displayName: 'Citi',             brandColor: '#003B70', initials: 'CI' },
  { slug: 'capital_one', displayName: 'Capital One',      brandColor: '#D03027', initials: 'C1' },
  { slug: 'discover',    displayName: 'Discover',         brandColor: '#F76F20', initials: 'DS' },
  { slug: 'apple',       displayName: 'Apple',            brandColor: '#555555', initials: 'AP' },
  { slug: 'amazon',      displayName: 'Amazon',           brandColor: '#FF9900', initials: 'AZ' },
  { slug: 'wells_fargo', displayName: 'Wells Fargo',      brandColor: '#CD3129', initials: 'WF' },
  { slug: 'bofa',        displayName: 'Bank of America',  brandColor: '#E31837', initials: 'BA' },
  { slug: 'usbank',      displayName: 'US Bank',          brandColor: '#003087', initials: 'US' },
  { slug: 'robinhood',   displayName: 'Robinhood',        brandColor: '#00C805', initials: 'RH' },
  { slug: 'cash_app',    displayName: 'Cash App',         brandColor: '#00D632', initials: 'CA' },
  { slug: 'synchrony',   displayName: 'Synchrony',        brandColor: '#0071CE', initials: 'SY' },
  { slug: 'barclays',   displayName: 'Barclays',         brandColor: '#00AEEF', initials: 'BR' },
  { slug: 'costco',     displayName: 'Costco',           brandColor: '#005DAA', initials: 'CO' },
  { slug: 'sams_club',  displayName: "Sam's Club",       brandColor: '#0067A0', initials: 'SC' },
  { slug: 'bilt',       displayName: 'Bilt',             brandColor: '#D84848', initials: 'BT' },
]

export const BANK_MAP = Object.fromEntries(BANKS.map(b => [b.slug, b]))
