#!/bin/bash
# Mastodon Matrix Theme Installer

set -e

echo "=== Mastodon Matrix Theme Installer ==="
echo ""

# Check if we're in a Mastodon directory
if [ ! -f "config/application.rb" ]; then
    echo "Error: Please run this script from your Mastodon root directory"
    exit 1
fi

echo "Installing Matrix Theme..."

# Copy SCSS
cp styles/matrix_theme.scss app/javascript/styles/
echo "✓ Copied matrix_theme.scss"

# Copy Matrix Rain JS (optional)
if [ -d "app/javascript/mastodon" ]; then
    mkdir -p app/javascript/mastodon/features/matrix
    cp js/matrix_rain.js app/javascript/mastodon/features/matrix/
    echo "✓ Copied matrix_rain.js"
fi

echo ""
echo "=== Manual Steps Required ==="
echo ""
echo "1. Add to app/javascript/styles/application.scss:"
echo "   @import 'matrix_theme';"
echo ""
echo "2. Rebuild assets:"
echo "   RAILS_ENV=production bundle exec rails assets:precompile"
echo ""
echo "3. Restart Mastodon:"
echo "   systemctl restart mastodon-web mastodon-sidekiq"
echo ""
echo "Done! Enjoy the Matrix theme."
