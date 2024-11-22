#!/bin/bash

# test_mobile_frontmatter.sh
# Usage: ./test_mobile_frontmatter.sh

# Define target directory
MOBILE_DIR="Cheat Sheets/Mobile"

# Function to clean filename for title
cleanTitle() {
    local file="$1"
    # Remove emoji and file extension, clean up spaces
    echo "$file" | sed 's/[📱⚡🚀🧟‍♂️]//g' | sed 's/.md$//' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//'
}

updateMobileFrontmatter() {
    local file="$1"
    local clean_title=$(cleanTitle "$(basename "$file")")
    local date=$(date +%Y-%m-%d)
    
    echo "Processing: $file"
    echo "Clean title: $clean_title"

    # Create backup
    cp "$file" "${file}.backup"
    
    # Create temporary file
    temp_file=$(mktemp)
    
    # Create new frontmatter
    cat > "$temp_file" << EOF
---
title: "$clean_title"
description: "Quick access mobile reference"
type: quick-access
mobile: true
date: $date
lastmod: $date
tags:
  - efSystem
  - quickAccess
  - mobile
aliases:
  - "$(basename "$file" .md)"  # Preserves emoji in alias
enableToc: false
showNav: true
mobileNav:
  - text: "🏠 Home"
    link: "index"
  - text: "🆘 Emergency"
    link: "emergency-task-start-protocol"
  - text: "⚡ Energy"
    link: "current-energy-state"
mobileFirst: true
cssClass: mobile-optimized quick-access
---
EOF
    
    # Get existing content (excluding any existing frontmatter)
    if grep -q "^---" "$file"; then
        sed -n '/^---$/,/^---$/!p' "$file" > "${temp_file}.content"
    else
        cat "$file" > "${temp_file}.content"
    fi
    
    # Combine updated frontmatter with content
    cat "$temp_file" > "$file"
    echo "" >> "$file"  # Add blank line after frontmatter
    cat "${temp_file}.content" >> "$file"
    
    # Cleanup
    rm "$temp_file" "${temp_file}.content"
    
    echo "Updated: $file"
    echo "Backup created: ${file}.backup"
    echo "-------------------"
}

# Main script
echo "Starting mobile frontmatter update..."
echo "Target directory: $MOBILE_DIR"
echo "-------------------"

# Find markdown files in mobile directory and update frontmatter
find "$MOBILE_DIR" -name "*.md" -type f | while read -r file; do
    updateMobileFrontmatter "$file"
done

echo "Complete! Please check the updated files and their backups."
