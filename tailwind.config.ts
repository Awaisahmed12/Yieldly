import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './index.html',
    './src/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        bg: '#0a0a08',
        surface: '#111110',
        border: '#2a2a26',
        accent: '#c8f542',
        accent2: '#f5a623',
        'text-primary': '#e8e8e0',
        muted: '#6b6b60',
      },
      fontFamily: {
        mono: ['DM Mono', 'monospace'],
        serif: ['Fraunces', 'serif'],
      },
    },
  },
  plugins: [],
}

export default config
