#!/bin/bash
# ============================================================
# Mastodon Matrix Theme - Installation Script
# ============================================================
#
# Usage: ./install.sh /path/to/mastodon
#
# This script installs the complete Matrix theme package.
# Run from the mastodon-matrix-theme directory.
#
# ============================================================

set -e

MASTODON_PATH="${1:-/home/mastodon/live}"
THEME_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🟢 Mastodon Matrix Theme Installer"
echo "==================================="
echo ""
echo "Mastodon path: $MASTODON_PATH"
echo "Theme source:  $THEME_DIR"
echo ""

# Check if Mastodon path exists
if [ ! -d "$MASTODON_PATH" ]; then
    echo "❌ Error: Mastodon directory not found: $MASTODON_PATH"
    echo "   Usage: ./install.sh /path/to/mastodon"
    exit 1
fi

# Check for app directory
if [ ! -d "$MASTODON_PATH/app" ]; then
    echo "❌ Error: Not a valid Mastodon installation (no app/ directory)"
    exit 1
fi

echo "📁 Creating directories..."
mkdir -p "$MASTODON_PATH/app/javascript/styles"
mkdir -p "$MASTODON_PATH/app/javascript/mastodon/features/MATRIX"
mkdir -p "$MASTODON_PATH/app/javascript/MATRIX/matrix"
mkdir -p "$MASTODON_PATH/public/matrix"
mkdir -p "$MASTODON_PATH/public/emoji/custom"

echo "🎨 Installing theme SCSS..."
cp "$THEME_DIR/styles/matrix_theme.scss" "$MASTODON_PATH/app/javascript/styles/MATRIX_matrix.scss"

echo "💻 Installing JavaScript..."
cp "$THEME_DIR/js/matrix_theme.ts" "$MASTODON_PATH/app/javascript/mastodon/features/MATRIX/"
cp "$THEME_DIR/js/matrix_rain.js" "$MASTODON_PATH/app/javascript/MATRIX/matrix/index.js"
cp "$THEME_DIR/js/matrix_background.js" "$MASTODON_PATH/app/javascript/MATRIX/matrix/"

echo "🖥️ Installing Terminal..."
cp -r "$THEME_DIR/terminal/"* "$MASTODON_PATH/public/matrix/"

echo "😀 Installing Emojis..."
cp "$THEME_DIR/emojis/"*.svg "$MASTODON_PATH/public/emoji/custom/"

echo "🛤️ Installing Rails files..."
cp "$THEME_DIR/rails/matrix_controller.rb" "$MASTODON_PATH/app/controllers/"
cp "$THEME_DIR/rails/initializers/MATRIX_theme.rb" "$MASTODON_PATH/config/initializers/"

echo ""
echo "✅ Files installed successfully!"
echo ""
echo "⚠️  MANUAL STEPS REQUIRED:"
echo ""
echo "1. Add to config/routes.rb (inside Rails.application.routes.draw):"
echo "   get 'matrix', to: 'matrix#index', as: :matrix"
echo "   post 'matrix/pass', to: 'matrix#pass'"
echo ""
echo "2. Add to app/javascript/styles/common.scss:"
echo "   @use 'MATRIX_matrix';"
echo ""
echo "3. Add to app/javascript/entrypoints/common.ts:"
echo "   import { initMatrixTheme } from 'mastodon/features/MATRIX/matrix_theme';"
echo "   import '@/MATRIX/matrix/index.js';"
echo "   initMatrixTheme();"
echo ""
echo "4. Add to .env.production:"
echo "   MATRIX_MATRIX_THEME_ENABLED=true"
echo "   MATRIX_COLOR=green"
echo ""
echo "5. Edit app/views/layouts/application.html.haml"
echo "   (See rails/views/application_layout_snippet.haml for code)"
echo ""
echo "6. Rebuild assets:"
echo "   RAILS_ENV=production bundle exec rails assets:precompile"
echo ""
echo "7. Restart Mastodon:"
echo "   systemctl restart mastodon-web mastodon-sidekiq"
echo ""
echo "🎉 Done! Visit /matrix to see the terminal."
