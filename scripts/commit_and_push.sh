#!/bin/bash

# FlyerBuddy Auto-Commit & Push Script (LaunchAgent optimized)
# This script handles staging, committing, and pushing changes to GitHub autonomously.

PROJECT_DIR="/Users/mike/Projects/FlyerBuddy"
cd "$PROJECT_DIR"

# 1. Initialize Git if not present
if [ ! -d ".git" ]; then
    git init
    git branch -M main
fi

# 2. Check for Remote 'origin'
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")

if [ -z "$REMOTE_URL" ]; then
    # Fallback if remote is missing - do not prompt, just log
    echo "⚠️  Error: No remote origin set. Run git remote add origin <url> first."
    exit 1
fi

# 3. Stage and Commit
git add -A

# Only commit if there are changes
if ! git diff-index --quiet HEAD --; then
    # Use first argument as commit message if provided, else use default
    if [ -n "$1" ]; then
        COMMIT_MSG="$1"
    else
        COMMIT_MSG="Auto-commit $(date '+%Y-%m-%d %H:%M:%S') [FlyerBuddy]"
    fi
    echo "📝 Committing: $COMMIT_MSG"
    git commit -m "$COMMIT_MSG"
else
    echo "✨ No changes to commit."
    exit 0
fi

# 4. Push to Origin
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "🚀 Pushing to origin $CURRENT_BRANCH..."

if git push -u origin "$CURRENT_BRANCH"; then
    HASH=$(git rev-parse --short HEAD)
    echo "✅ Success! Latest Commit: $HASH"
    # Show notification for the user to see the hash
    osascript -e "display notification \"Pushed to $CURRENT_BRANCH (Commit: $HASH)\" with title \"FlyerBuddy: Git Push Success\""
else
    echo "❌ Push failed. Check logs."
    osascript -e "display notification \"Check scripts/gitbridge.err.log\" with title \"FlyerBuddy: Git Push Failed\""
    exit 1
fi
