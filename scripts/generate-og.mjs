import sharp from 'sharp';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));

const svg = `<svg width="1200" height="630" viewBox="0 0 1200 630" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="1200" height="630" fill="#0a0a08"/>

  <!-- Lime accent bar at top -->
  <rect x="0" y="0" width="1200" height="6" fill="#c8f542"/>

  <!-- Centered content -->
  <!-- Brand name -->
  <text x="600" y="230" font-family="Georgia, serif" font-size="80" font-weight="700" fill="#ffffff" text-anchor="middle" letter-spacing="-1">Yieldly</text>

  <!-- Divider line -->
  <rect x="480" y="262" width="240" height="2" fill="#c8f542" opacity="0.4" rx="1"/>

  <!-- Tagline -->
  <text x="600" y="340" font-family="monospace" font-size="26" fill="#ffffff" opacity="0.55" text-anchor="middle" letter-spacing="1">Instantly know which</text>
  <text x="600" y="378" font-family="monospace" font-size="26" fill="#c8f542" text-anchor="middle" letter-spacing="1">credit card to use.</text>

  <!-- URL -->
  <text x="600" y="530" font-family="monospace" font-size="18" fill="#ffffff" opacity="0.3" text-anchor="middle" letter-spacing="2">yieldly.app</text>
</svg>`;

const outPath = resolve(__dirname, '../public/og-image.png');

await sharp(Buffer.from(svg))
  .png()
  .toFile(outPath);

console.log('Generated public/og-image.png');
