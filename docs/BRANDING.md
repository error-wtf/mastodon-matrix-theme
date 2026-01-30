# 🎨 Branding Guide - Customize Your Instance Name

This guide explains how to rebrand the Matrix theme from "Matrix" to your own instance name.

## Quick Start

Use the automated rebrand script:

```bash
# Linux/macOS
./rebrand.sh "YourInstanceName"

# Windows PowerShell
.\rebrand.ps1 -NewName "YourInstanceName"
```

## What Gets Changed

| Category | Examples |
|----------|----------|
| **Display Names** | "MATRIX TERMINAL" → "YOURNAME TERMINAL" |
| **Terminal Prompts** | `guest@matrix:~$` → `guest@yourname:~$` |
| **Environment Variables** | `MATRIX_THEME` → `YOURNAME_THEME` |
| **Ruby Namespace** | `Matrix::` → `Yourname::` |
| **LocalStorage Keys** | `matrix_matrix_theme` → `yourname_matrix_theme` |
| **Console Logs** | `[Matrix]` → `[Yourname]` |
| **File Names** | `matrix_theme.rb` → `yourname_theme.rb` |

**Note:** CSS class names like `.matrix-splash`, `.theme-matrix` are NOT changed (they're internal identifiers).

---

## Manual Branding Steps

If you prefer to change branding manually:

### 1. SCSS Theme File

Rename and update `styles/matrix_theme.scss`:

```scss
// Line 1-3: Change header comment
// MATRIX THEME  →  YOURNAME THEME
```

After installation, rename the file:
```bash
mv app/javascript/styles/errordon_matrix.scss \
   app/javascript/styles/yourname_matrix.scss
```

Update `common.scss`:
```scss
@use 'yourname_matrix';  // was: errordon_matrix
```

### 2. JavaScript Files

**js/matrix_rain.js:**
```javascript
// Change all occurrences:
// - 'matrix_matrix_color' → 'yourname_matrix_color'
// - 'matrix_matrix_theme' → 'yourname_matrix_theme'
// - 'matrix:color-change' → 'yourname:color-change'
// - '[Matrix]' → '[Yourname]'
// - 'MATRIX TERMINAL' → 'YOURNAME TERMINAL'
```

**js/matrix_theme.ts:**
```typescript
const THEME_KEY = 'yourname_matrix_theme';  // was: errordon_matrix_theme
// Change 'errordon:theme-change' → 'yourname:theme-change'
```

### 3. Terminal Landing Page

**terminal/index.html:**
```html
<!-- Change display text -->
<title>YOURNAME - Enter The Matrix</title>
<h1 class="matrix-title">YOURNAME</h1>
<span class="terminal-title">YOURNAME TERMINAL v1.0</span>
<span class="prompt">guest@yourname:~$</span>
```

**terminal/main.js:**
```javascript
promptEl.textContent = username + '@yourname:~$';
printLine('WELCOME TO YOURNAME');
// ... update all "MATRIX TERMINAL" references
```

### 4. Rails Initializer

**rails/initializers/errordon_theme.rb:**

Rename to `yourname_theme.rb` and update:

```ruby
# frozen_string_literal: true

# Yourname Theme Configuration
Rails.application.config.to_prepare do
  Yourname::THEME = ENV.fetch('YOURNAME_THEME', 'matrix').freeze
  Yourname::MATRIX_COLOR = ENV.fetch('MATRIX_COLOR', 'green').freeze
  # ... etc
end
```

### 5. Environment Variables

Update `.env.production`:
```bash
# Old (Matrix default)
MATRIX_THEME_ENABLED=true
MATRIX_THEME=matrix

# New (your instance)
YOURNAME_MATRIX_THEME_ENABLED=true
YOURNAME_THEME=matrix
```

### 6. Layout Snippet

**rails/views/application_layout_snippet.haml:**
```haml
-# Change all Matrix:: to Yourname::
- matrix_color = defined?(Yourname::MATRIX_COLOR) ? Yourname::MATRIX_COLOR : 'green'
%meta{ name: 'yourname-matrix-color', content: matrix_color }/
```

### 7. Deployment Files

**deploy/mastodon-matrix.service:**
```ini
Description=Yourname (Mastodon Fork)
User=yourname
Group=yourname
WorkingDirectory=/home/yourname/yourname
```

**deploy/nginx.conf:**
```nginx
# Yourname nginx Configuration
# Copy to /etc/nginx/sites-available/yourname
```

### 8. Directory Structure

After installation, rename directories:
```bash
mv app/javascript/errordon app/javascript/yourname
mv app/javascript/mastodon/features/errordon \
   app/javascript/mastodon/features/yourname
```

Update imports in `entrypoints/common.ts`:
```typescript
import { initMatrixTheme } from 'mastodon/features/yourname/matrix_theme';
import '@/yourname/matrix/index.js';
```

---

## Files to Update (Complete List)

| File | Changes Needed |
|------|----------------|
| `styles/matrix_theme.scss` | Header comment |
| `js/matrix_rain.js` | ~20 occurrences |
| `js/matrix_theme.ts` | ~5 occurrences |
| `js/matrix_background.js` | ~3 occurrences |
| `terminal/index.html` | Title, headings, prompts |
| `terminal/main.js` | Prompts, messages |
| `rails/initializers/errordon_theme.rb` | Filename + all content |
| `rails/views/application_layout_snippet.haml` | Ruby namespace, meta tags |
| `rails/entrypoints/common.ts` | Import paths |
| `rails/styles/common.scss.snippet` | Import statement |
| `rails/config/themes.yml.example` | Comment |
| `deploy/mastodon-matrix.service` | Description, user, paths |
| `deploy/nginx.conf` | Comments |
| `install.sh` | Paths, messages |
| `README.md` | Documentation |
| `docs/FRONTEND_MAP_MATRIX_AND_STYLES.md` | Documentation |

---

## Testing Your Rebrand

After rebranding:

1. **Search for remaining references:**
   ```bash
   grep -ri "errordon" --include="*.{js,ts,scss,rb,html,haml,sh,md}"
   ```

2. **Check localStorage keys in browser console:**
   ```javascript
   Object.keys(localStorage).filter(k => k.includes('matrix'))
   ```

3. **Verify environment variables:**
   ```bash
   env | grep -i yourname
   ```

4. **Test theme toggle:** Press `Ctrl+Shift+M`

5. **Check terminal landing page:** Visit `/matrix`

---

## Keep Original Attribution

While you can change the branding, please keep attribution to the original project:

```
Matrix Theme originally developed by the Errordon team
https://github.com/error-wtf/mastodon-matrix-theme
```
