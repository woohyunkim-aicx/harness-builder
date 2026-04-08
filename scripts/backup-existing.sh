#!/bin/bash
# harness-builder: Backup existing .claude/ directory before generation
# Usage: bash scripts/backup-existing.sh [project-root]

PROJECT_ROOT="${1:-.}"
CLAUDE_DIR="$PROJECT_ROOT/.claude"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="$CLAUDE_DIR/harness-builder/backups/$TIMESTAMP"

if [ ! -d "$CLAUDE_DIR" ]; then
  echo "No .claude/ directory found — skipping backup"
  exit 0
fi

echo "Backing up .claude/ to $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Copy everything except harness-builder subdirectory and backups
for item in "$CLAUDE_DIR"/*; do
  basename=$(basename "$item")
  if [ "$basename" = "harness-builder" ]; then
    continue
  fi
  cp -r "$item" "$BACKUP_DIR/" 2>/dev/null || true
done

# Also backup root CLAUDE.md if it exists
if [ -f "$PROJECT_ROOT/CLAUDE.md" ]; then
  cp "$PROJECT_ROOT/CLAUDE.md" "$BACKUP_DIR/CLAUDE.md.root"
fi

echo "Backup complete: $BACKUP_DIR"
ls -la "$BACKUP_DIR"
