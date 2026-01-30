# Mastodon Matrix Theme

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
[![Mastodon Compatible](https://img.shields.io/badge/Mastodon-4.x-blueviolet)](https://joinmastodon.org/)

A cyberpunk Matrix-style theme for Mastodon instances.

---

<div align="center">

![Matrix Theme Preview](screenshots/preview.png)

**🟢 Green neon aesthetics • 💻 Hacker fonts • 🌧️ Matrix rain animation**

</div>

---

## Features

- **Matrix Green Color Palette** (`#00ff00`)
- **VT323 Hacker Font** for headings (UTF-8 compatible)
- **Matrix Rain Animation** background
- **Glitch Effects** on hover
- **Dark Background** with high contrast text
- **100% Fediverse Compatible** (no structural changes)

## Installation

### Method 1: Manual Installation

1. **Copy the SCSS file** to your Mastodon instance:

```bash
cp styles/matrix_theme.scss /path/to/mastodon/app/javascript/styles/
```

2. **Copy the Matrix rain JS** (optional):

```bash
cp js/matrix_rain.js /path/to/mastodon/app/javascript/
```

3. **Import in your application.scss**:

```scss
// At the end of app/javascript/styles/application.scss
@import 'matrix_theme';
```

4. **Rebuild assets**:

```bash
RAILS_ENV=production bundle exec rails assets:precompile
```

5. **Restart Mastodon**:

```bash
systemctl restart mastodon-web mastodon-sidekiq
```

### Method 2: As Mastodon Skin

1. Create a new skin file:

```bash
# app/javascript/styles/mastodon/matrix.scss
@import 'application';
@import '../matrix_theme';
```

2. Register the skin in `config/themes.yml`:

```yaml
default: styles/mastodon/default.scss
matrix: styles/mastodon/matrix.scss
contrast: styles/mastodon/contrast.scss
```

3. Rebuild and restart.

Users can then select "Matrix" in their appearance settings.

## Configuration

### Environment Variables

```bash
# Enable Matrix theme as default
ERRORDON_THEME=matrix

# Color variants (green, red, blue, purple)
ERRORDON_THEME_COLOR=green

# Enable/disable Matrix rain animation
ERRORDON_MATRIX_RAIN=true
```

### Customizing Colors

Edit the variables at the top of `matrix_theme.scss`:

```scss
// Core Matrix colors
$matrix-primary: #00ff00;        // Main green
$matrix-secondary: #003300;      // Dark green
$matrix-background: #0a0a0a;     // Near black
$matrix-surface: #0d0d0d;        // Slightly lighter
$matrix-text: #ffffff;           // White text
$matrix-text-secondary: #b0b0b0; // Gray text
```

### Color Variants

The theme supports multiple color variants:

| Variant | Primary Color | CSS Variable |
|---------|---------------|--------------|
| Green (default) | `#00ff00` | `--matrix-primary: #00ff00` |
| Red | `#ff0040` | `--matrix-primary: #ff0040` |
| Blue | `#00ffff` | `--matrix-primary: #00ffff` |
| Purple | `#bf00ff` | `--matrix-primary: #bf00ff` |

## Files Included

```
mastodon-matrix-theme/
├── README.md                    # This file
├── LICENSE                      # AGPLv3 License
├── styles/
│   └── matrix_theme.scss        # Main theme stylesheet
├── js/
│   └── matrix_rain.js           # Matrix rain animation
├── screenshots/
│   └── preview.png              # Theme preview
└── install.sh                   # Installation script
```

## Browser Support

- Chrome/Chromium 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## Compatibility

Tested with:
- Mastodon 4.0.x
- Mastodon 4.1.x
- Mastodon 4.2.x
- Mastodon 4.3.x

## Credits

- Inspired by "The Matrix" film series
- VT323 font by Peter Hull
- Based on Mastodon's default theme

## License

AGPLv3 - Compatible with Mastodon's license.

## Contributing

Pull requests welcome! Please follow the existing code style.

## Links

- [Mastodon](https://github.com/mastodon/mastodon)
- [Errordon](https://github.com/error-wtf/errordon) - Full fork with this theme included
- [VT323 Font](https://fonts.google.com/specimen/VT323)

---

<div align="center">

**Matrix Theme** — *See the code* 🟢

</div>
