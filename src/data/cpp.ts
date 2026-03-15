export const CPP: Record<string, { low: number; default: number; high: number }> = {
  UR:     { low: 1.00, default: 1.50, high: 2.00 },  // Chase Ultimate Rewards
  MR:     { low: 1.00, default: 1.40, high: 2.00 },  // Amex Membership Rewards
  TYP:    { low: 1.00, default: 1.30, high: 1.70 },  // Citi ThankYou Points
  C1:     { low: 1.00, default: 1.50, high: 1.85 },  // Capital One Miles
  CB:     { low: 1.00, default: 1.00, high: 1.00 },  // Cash Back (always 1:1)
  SW:     { low: 1.30, default: 1.50, high: 1.80 },  // Southwest Rapid Rewards
  UA:     { low: 1.10, default: 1.35, high: 1.80 },  // United MileagePlus
  DL:     { low: 1.00, default: 1.20, high: 1.60 },  // Delta SkyMiles
  HH:     { low: 0.40, default: 0.55, high: 0.70 },  // Hilton Honors
  Bonvoy: { low: 0.60, default: 0.80, high: 1.10 },  // Marriott Bonvoy
  Alaska: { low: 1.00, default: 1.40, high: 1.80 },  // Alaska Airlines
  Hyatt:  { low: 1.20, default: 1.70, high: 2.20 },  // World of Hyatt
  Points: { low: 1.50, default: 1.50, high: 1.50 },  // US Bank fixed-value points
  AA:     { low: 1.10, default: 1.40, high: 1.80 },  // American Airlines AAdvantage
  TB:     { low: 1.00, default: 1.30, high: 1.60 },  // JetBlue TrueBlue
  Wyndham:  { low: 0.40, default: 0.60, high: 0.90 },  // Wyndham Rewards
  IHG:      { low: 0.40, default: 0.50, high: 0.70 },  // IHG One Rewards
  Avios:    { low: 1.00, default: 1.40, high: 2.00 },  // British Airways Avios
  Bilt:     { low: 1.25, default: 1.50, high: 2.00 },  // Bilt Rewards
  Aeroplan: { low: 1.20, default: 1.50, high: 2.00 },  // Air Canada Aeroplan
}
