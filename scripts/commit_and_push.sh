#!/bin/bash

# FlyerBuddy Auto-Commit & Push Script (LaunchAgent optimized)
# This script handles staging, committing, and pushing changes to GitHub autonomously.

PROJECT_DIR="/Users/mike/Projects/FlyerBuddy"
TRIGGER_FILE="$PROJECT_DIR/scripts/push_trigger.txt"
cd "$PROJECT_DIR"

# 1. Initialize Git if not present
if [ ! -d ".git" ]; then
    git init
    git branch -M main
fi

# 2. Check for Remote 'origin'
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")

if [ -z "$REMOTE_URL" ]; then
    echo "⚠️  Error: No remote origin set. Run git remote add origin <url> first."
    exit 1
fi

# 3. Determine Commit Message
COMMIT_MSG=""

# Check if there is a message in the trigger file
if [ -f "$TRIGGER_FILE" ] && [ -s "$TRIGGER_FILE" ]; then
    COMMIT_MSG=$(cat "$TRIGGER_FILE")
    echo "🎯 Trigger detected with message: $COMMIT_MSG"
elif [ -n "$1" ]; then
    COMMIT_MSG="$1"
fi

# Fallback to default if still empty
if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="Auto-commit $(date '+%Y-%m-%d %H:%M:%S') [FlyerBuddy]"
fi

# 4. Stage and Commit
git add -A

# Only commit if there are changes
if ! git diff-index --quiet HEAD --; then
    echo "📝 Committing: $COMMIT_MSG"
    git commit -m "$COMMIT_MSG"
else
    echo "✨ No changes to commit."
    # Clear trigger file even if no changes, to prevent loops
    > "$TRIGGER_FILE"
    exit 0
fi

# 5. Push to Origin
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "🚀 Pushing to origin $CURRENT_BRANCH..."

if git push -u origin "$CURRENT_BRANCH"; then
    HASH=$(git rev-parse --short HEAD)
    echo "✅ Success! Latest Commit: $HASH"
    
    # Clear the trigger file on success
    > "$TRIGGER_FILE"
    
    # Show notification for the user
    osascript -e "display notification \"Pushed to $CURRENT_BRANCH (Commit: $HASH)\" with title \"FlyerBuddy: Git Push Success\""
else
    echo "❌ Push failed. Check logs."
    osascript -e "display notification \"Check scripts/gitbridge.err.log\" with title \"FlyerBuddy: Git Push Failed\""
    exit 1
fi
