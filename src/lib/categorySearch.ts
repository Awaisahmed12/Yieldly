/**
 * Intelligent category search.
 * Maps user queries (store names, slang, synonyms) to category slugs.
 */

interface KeywordEntry {
  terms: string[]
  slug: string
}

const KEYWORD_MAP: KeywordEntry[] = [
  // Groceries — common supermarket chains + generic terms
  {
    slug: 'groceries',
    terms: [
      'kroger', 'heb', 'h-e-b', 'wegmans', 'safeway', 'publix', 'aldi', 'meijer',
      'giant', 'stop and shop', 'stop & shop', 'food lion', 'sprouts', 'market',
      'supermarket', 'grocery', 'groceries', 'produce', 'fresh market', 'harris teeter',
      'winn dixie', 'piggly wiggly', 'shop rite', 'shoprite', 'vons', 'ralphs',
      'fry\'s', 'frys', 'king soopers', 'trader joe', "trader joe's",
    ],
  },
  // Dining — restaurants, fast food, coffee, delivery apps
  {
    slug: 'dining',
    terms: [
      'restaurant', 'restaurants', 'eat', 'food', 'lunch', 'dinner', 'brunch',
      'coffee', 'cafe', 'starbucks', 'dunkin', 'dunkin donuts', 'mcdonald', 'mcdonalds',
      'chick fil a', 'chick-fil-a', 'chipotle', 'pizza', 'burger', 'sushi', 'taco',
      'taco bell', 'wendys', "wendy's", 'subway', 'panera', 'shake shack',
      'five guys', 'in-n-out', 'in n out', 'popeyes', 'kfc', 'dominos', "domino's",
      'papa johns', 'takeout', 'take out', 'dine out', 'fast food', 'bar', 'pub',
      'doordash', 'grubhub', 'seamless', 'postmates',
    ],
  },
  // Uber Eats — brand category (maps to dining brand child)
  {
    slug: 'uber_eats',
    terms: ['uber eats', 'ubereats'],
  },
  // Gas — stations and fuel
  {
    slug: 'gas',
    terms: [
      'gas', 'fuel', 'petrol', 'station', 'shell', 'exxon', 'bp', 'chevron',
      'citgo', 'mobil', 'sunoco', 'marathon', 'speedway', 'wawa', 'casey\'s',
      'kwik trip', 'pilot', 'love\'s', 'fill up', 'pump',
    ],
  },
  // Travel portal
  {
    slug: 'travel',
    terms: [
      'travel', 'trip', 'vacation', 'portal', 'expedia', 'kayak', 'priceline',
      'booking', 'travelocity', 'orbitz', 'google flights', 'google hotels',
    ],
  },
  // Flights
  {
    slug: 'flights',
    terms: [
      'flight', 'flights', 'fly', 'airline', 'airfare', 'plane', 'airport',
      'boarding', 'ticket', 'american airlines', 'spirit', 'frontier',
    ],
  },
  // Hotels
  {
    slug: 'hotels',
    terms: [
      'hotel', 'hotels', 'motel', 'inn', 'resort', 'lodge', 'stay',
      'accommodation', 'lodging', 'airbnb', 'vrbo',
    ],
  },
  // Streaming
  {
    slug: 'streaming',
    terms: [
      'streaming', 'stream', 'netflix', 'hulu', 'disney', 'disney+', 'hbo', 'max',
      'peacock', 'paramount', 'apple tv', 'prime video', 'amazon prime video',
      'spotify', 'apple music', 'tidal', 'youtube premium', 'subscription',
      'music', 'tv show', 'series',
    ],
  },
  // Pharmacy
  {
    slug: 'pharmacy',
    terms: [
      'pharmacy', 'drug store', 'drugstore', 'prescription', 'medicine', 'rx',
      'walgreens', 'cvs', 'rite aid', 'medicine', 'health', 'vitamins',
    ],
  },
  // Entertainment — movies, events, concerts
  {
    slug: 'entertainment',
    terms: [
      'entertainment', 'movie', 'movies', 'cinema', 'theater', 'theatre', 'film',
      'concert', 'show', 'live show', 'event', 'events', 'tickets', 'ticketmaster',
      'stubhub', 'seatgeek', 'museum', 'zoo', 'amusement', 'theme park',
      'sports', 'game', 'bowling', 'escape room', 'comedy', 'comedy club',
      'live music', 'nightclub', 'bar', 'arcade', 'imax',
    ],
  },
  // Transit — public transit, rideshare
  {
    slug: 'transit',
    terms: [
      'transit', 'bus', 'subway', 'metro', 'train', 'commute', 'lyft',
      'taxi', 'cab', 'public transport', 'mta', 'cta', 'bart', 'mbta',
      'rail', 'amtrak', 'scooter', 'bike share',
    ],
  },
  // Uber — brand category (maps to transit brand child)
  {
    slug: 'uber',
    terms: ['uber', 'uber ride'],
  },
  // Online Shopping
  {
    slug: 'online_shopping',
    terms: [
      'online shopping', 'online', 'shop', 'shopping', 'ecommerce', 'e-commerce',
      'order online', 'delivery', 'target', 'walmart', 'best buy', 'newegg',
      'chewy', 'wayfair', 'overstock', 'etsy', 'wish', 'shein', 'zara', 'h&m',
    ],
  },
  // Rent
  {
    slug: 'rent',
    terms: [
      'rent', 'rental', 'apartment', 'lease', 'landlord', 'housing', 'mortgage',
    ],
  },
  // Wholesale Clubs
  {
    slug: 'wholesale_clubs',
    terms: [
      'wholesale', 'warehouse club', 'bulk', 'bjs', "bj's", 'warehouse store',
    ],
  },
  // Car Rental
  {
    slug: 'car_rental',
    terms: [
      'car rental', 'car rent', 'rental car', 'hertz', 'enterprise', 'avis',
      'budget', 'national car', 'alamo', 'zipcar', 'turo',
    ],
  },
  // Beauty — hair, nails, spa, cosmetics
  {
    slug: 'beauty',
    terms: [
      'beauty', 'hair', 'haircut', 'hairstyle', 'barber', 'salon', 'nail',
      'nails', 'manicure', 'pedicure', 'spa', 'massage', 'facial', 'waxing',
      'wax', 'eyebrow', 'lash', 'makeup', 'cosmetics', 'skincare', 'sephora',
      'ulta', 'glossier', 'blowout', 'cut', 'color', 'highlights', 'threading',
      'tattoo', 'piercing', 'grooming',
    ],
  },
  // Utilities — electric, gas, water, internet, phone bills
  {
    slug: 'utilities',
    terms: [
      'utilities', 'utility', 'electric', 'electricity', 'power bill', 'energy',
      'water', 'water bill', 'gas bill', 'natural gas', 'sewage', 'trash',
      'internet', 'wifi', 'broadband', 'cable', 'cable bill', 'at&t', 'att',
      'verizon', 'comcast', 'xfinity', 'spectrum', 'cox', 'tmobile', 't-mobile',
      'cell phone', 'cell bill', 'phone bill', 'telecom', 'bg&e', 'pge', 'pg&e',
      'con ed', 'coned',
    ],
  },
  // Fitness — gyms, classes, equipment
  {
    slug: 'fitness',
    terms: [
      'fitness', 'gym', 'workout', 'exercise', 'health club', 'crossfit',
      'yoga', 'pilates', 'spin', 'cycling class', 'peloton', 'classpass',
      'equinox', 'planet fitness', '24 hour fitness', 'la fitness', 'anytime fitness',
      'crunch', 'blink fitness', 'orange theory', 'orangetheory', 'f45',
      'personal trainer', 'swimming', 'swim', 'tennis', 'golf',
    ],
  },
  // EV Charging
  {
    slug: 'ev_charging',
    terms: [
      'ev', 'ev charging', 'electric vehicle', 'charging', 'charge',
      'tesla', 'supercharger', 'tesla supercharger', 'chargepoint', 'electrify america',
      'blink charging', 'evgo', 'plugshare', 'level 2', 'dc fast charge',
    ],
  },
  // Foreign Spending
  {
    slug: 'foreign_spending',
    terms: [
      'foreign', 'international', 'abroad', 'overseas', 'currency', 'exchange',
      'travel fee', 'foreign transaction', 'ftf', 'foreign currency',
    ],
  },
  // Other — catch-all
  {
    slug: 'other',
    terms: [
      'other', 'everything else', 'misc', 'miscellaneous', 'general', 'catch all',
      'catch-all', 'all other', 'default',
    ],
  },
  // Brand categories
  { slug: 'amazon',      terms: ['amazon', 'amazon.com'] },
  { slug: 'whole_foods', terms: ['whole foods', 'wholefoods'] },
  { slug: 'costco',      terms: ['costco', 'costco wholesale'] },
  { slug: 'sams_club',   terms: ["sam's club", 'sams club', 'samsclub'] },
  { slug: 'united',      terms: ['united', 'united airlines'] },
  { slug: 'delta',       terms: ['delta', 'delta airlines', 'delta air lines'] },
  { slug: 'southwest',   terms: ['southwest', 'southwest airlines'] },
  { slug: 'jetblue',     terms: ['jetblue', 'jet blue'] },
  { slug: 'hilton',      terms: ['hilton', 'hampton inn', 'doubletree', 'embassy suites', 'waldorf'] },
  { slug: 'marriott',    terms: ['marriott', 'sheraton', 'westin', 'w hotel', 'ritz carlton', 'ritz-carlton', 'courtyard', 'springhill'] },
  { slug: 'hyatt',       terms: ['hyatt', 'park hyatt', 'grand hyatt', 'andaz', 'alila'] },
  { slug: 'ihg',         terms: ['ihg', 'holiday inn', 'intercontinental', 'kimpton', 'crowne plaza'] },
  { slug: 'apple',       terms: ['apple', 'apple store', 'itunes', 'app store', 'icloud'] },
  { slug: 'ebay',        terms: ['ebay'] },
]

/**
 * Search categories by query string.
 * Returns a set of slugs that match the query, ordered by relevance.
 * Supports partial prefix matching and whole-word matching.
 */
export function searchCategorySlugs(query: string): string[] {
  const q = query.toLowerCase().trim()
  if (!q) return []

  const slugScores = new Map<string, number>()

  for (const { terms, slug } of KEYWORD_MAP) {
    for (const term of terms) {
      let score = 0
      if (term === q) {
        score = 100                          // exact match
      } else if (term.startsWith(q)) {
        score = 80                           // prefix match on keyword
      } else if (term.includes(q)) {
        score = 60                           // substring match on keyword
      } else if (q.startsWith(term)) {
        score = 40                           // keyword is prefix of query
      }
      if (score > 0) {
        const prev = slugScores.get(slug) ?? 0
        if (score > prev) slugScores.set(slug, score)
      }
    }
  }

  return [...slugScores.entries()]
    .sort((a, b) => b[1] - a[1])
    .map(([slug]) => slug)
}
