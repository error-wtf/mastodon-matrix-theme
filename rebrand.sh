#!/bin/bash
# ============================================================
# Mastodon Matrix Theme - Rebrand Script
# Changes "Matrix" branding to your custom instance name
# ============================================================
#
# Usage: ./rebrand.sh "YourInstanceName"
#
# Example: ./rebrand.sh "CyberNode"
#          ./rebrand.sh "Errordon"
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
echo "Rebranding from 'Matrix' to '$NEW_NAME'"
echo ""

# Function to replace in file
replace_in_file() {
    local file="$1"
    if [ -f "$file" ]; then
        # Create backup
        cp "$file" "$file.bak"
        
        # Replace variations (but not CSS class names like .matrix-*)
        # Replace display text only
        sed -i "s/MATRIX TERMINAL/${NEW_NAME_UPPER} TERMINAL/g" "$file"
        sed -i "s/MATRIX - /${NEW_NAME_UPPER} - /g" "$file"
        sed -i "s/>MATRIX</>$NEW_NAME_UPPER</g" "$file"
        sed -i "s/WELCOME TO MATRIX/WELCOME TO $NEW_NAME_UPPER/g" "$file"
        sed -i "s/@matrix:/@$NEW_NAME_LOWER:/g" "$file"
        sed -i "s/guest@matrix/guest@$NEW_NAME_LOWER/g" "$file"
        sed -i "s/root@matrix/root@$NEW_NAME_LOWER/g" "$file"
        
        # Replace namespace/module names
        sed -i "s/Matrix::/${NEW_NAME}::/g" "$file"
        sed -i "s/MATRIX_THEME/${NEW_NAME_UPPER}_THEME/g" "$file"
        sed -i "s/MATRIX_MATRIX_THEME_ENABLED/${NEW_NAME_UPPER}_MATRIX_THEME_ENABLED/g" "$file"
        
        # Replace localStorage keys  
        sed -i "s/matrix_matrix_theme/${NEW_NAME_LOWER}_matrix_theme/g" "$file"
        sed -i "s/matrix_matrix_color/${NEW_NAME_LOWER}_matrix_color/g" "$file"
        sed -i "s/matrix_matrix_intensity/${NEW_NAME_LOWER}_matrix_intensity/g" "$file"
        
        # Replace meta tag names
        sed -i "s/matrix-matrix-color/${NEW_NAME_LOWER}-matrix-color/g" "$file"
        
        # Replace console log prefix
        sed -i "s/\[Matrix\]/[${NEW_NAME}]/g" "$file"
        
        # Replace event names
        sed -i "s/matrix:theme-change/${NEW_NAME_LOWER}:theme-change/g" "$file"
        sed -i "s/matrix:color-change/${NEW_NAME_LOWER}:color-change/g" "$file"
        
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
replace_in_file "$SCRIPT_DIR/rails/initializers/matrix_theme.rb"
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

echo ""
echo "📁 Renaming files..."

# Rename initializer
if [ -f "$SCRIPT_DIR/rails/initializers/matrix_theme.rb" ]; then
    mv "$SCRIPT_DIR/rails/initializers/matrix_theme.rb" \
       "$SCRIPT_DIR/rails/initializers/${NEW_NAME_LOWER}_theme.rb"
    echo "  ✓ matrix_theme.rb → ${NEW_NAME_LOWER}_theme.rb"
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
