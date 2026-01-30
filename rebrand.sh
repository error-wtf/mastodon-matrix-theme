#!/bin/bash
# ============================================================
# Mastodon Matrix Theme - Rebrand Script
# Changes "Errordon" branding to your custom name
# ============================================================
#
# Usage: ./rebrand.sh "YourInstanceName"
#
# Example: ./rebrand.sh "CyberNode"
#          ./rebrand.sh "MatrixHub"
#
# ============================================================

set -e

# Check argument
if [ -z "$1" ]; then
    echo "❌ Error: Please provide your instance name"
    echo ""
    echo "Usage: ./rebrand.sh \"YourInstanceName\""
    echo ""
    echo "Example: ./rebrand.sh \"CyberNode\""
    exit 1
fi

NEW_NAME="$1"
NEW_NAME_LOWER=$(echo "$NEW_NAME" | tr '[:upper:]' '[:lower:]')
NEW_NAME_UPPER=$(echo "$NEW_NAME" | tr '[:lower:]' '[:upper:]')

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🎨 Mastodon Matrix Theme - Rebrand Script"
echo "=========================================="
echo ""
echo "Rebranding from 'Errordon' to '$NEW_NAME'"
echo ""

# Function to replace in file
replace_in_file() {
    local file="$1"
    if [ -f "$file" ]; then
        # Create backup
        cp "$file" "$file.bak"
        
        # Replace variations
        sed -i "s/ERRORDON/$NEW_NAME_UPPER/g" "$file"
        sed -i "s/Errordon/$NEW_NAME/g" "$file"
        sed -i "s/errordon/$NEW_NAME_LOWER/g" "$file"
        
        echo "  ✓ $file"
    fi
}

echo "📝 Updating files..."

# JavaScript files
replace_in_file "$SCRIPT_DIR/js/matrix_rain.js"
replace_in_file "$SCRIPT_DIR/js/matrix_theme.ts"
replace_in_file "$SCRIPT_DIR/js/matrix_background.js"

# SCSS
replace_in_file "$SCRIPT_DIR/styles/matrix_theme.scss"
replace_in_file "$SCRIPT_DIR/styles/matrix_theme_standalone.scss"

# Terminal
replace_in_file "$SCRIPT_DIR/terminal/index.html"
replace_in_file "$SCRIPT_DIR/terminal/main.js"

# Rails
replace_in_file "$SCRIPT_DIR/rails/initializers/errordon_theme.rb"
replace_in_file "$SCRIPT_DIR/rails/views/application_layout_snippet.haml"
replace_in_file "$SCRIPT_DIR/rails/entrypoints/common.ts"
replace_in_file "$SCRIPT_DIR/rails/styles/common.scss.snippet"
replace_in_file "$SCRIPT_DIR/rails/config/themes.yml.example"
replace_in_file "$SCRIPT_DIR/rails/routes/matrix_routes.rb"

# Deploy
replace_in_file "$SCRIPT_DIR/deploy/nginx.conf"
replace_in_file "$SCRIPT_DIR/deploy/mastodon-matrix.service"

# Install script
replace_in_file "$SCRIPT_DIR/install.sh"

# Documentation
replace_in_file "$SCRIPT_DIR/README.md"
replace_in_file "$SCRIPT_DIR/docs/FRONTEND_MAP_MATRIX_AND_STYLES.md"

echo ""
echo "📁 Renaming files..."

# Rename initializer
if [ -f "$SCRIPT_DIR/rails/initializers/errordon_theme.rb" ]; then
    mv "$SCRIPT_DIR/rails/initializers/errordon_theme.rb" \
       "$SCRIPT_DIR/rails/initializers/${NEW_NAME_LOWER}_theme.rb"
    echo "  ✓ errordon_theme.rb → ${NEW_NAME_LOWER}_theme.rb"
fi

echo ""
echo "🧹 Cleaning up backups..."
find "$SCRIPT_DIR" -name "*.bak" -delete

echo ""
echo "✅ Rebranding complete!"
echo ""
echo "Next steps:"
echo "1. Review changes: grep -ri \"$NEW_NAME_LOWER\" ."
echo "2. Update install.sh paths if needed"
echo "3. Run ./install.sh /path/to/mastodon"
echo ""
echo "Remember to update your .env.production:"
echo "  ${NEW_NAME_UPPER}_MATRIX_THEME_ENABLED=true"
echo "  ${NEW_NAME_UPPER}_THEME=matrix"
