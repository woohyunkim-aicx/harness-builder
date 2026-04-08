#!/bin/bash
# harness-builder: SessionStart hook — suggest /harness-setup if no harness detected
# This runs on every session start when the plugin is installed

# Quick check: does a harness exist?
if [ ! -f ".claude/harness-builder/harness-lock.json" ]; then
  # Check if there's at least a CLAUDE.md
  if [ -f "CLAUDE.md" ] || [ -f ".claude/settings.json" ]; then
    # Partial setup exists — don't nag
    exit 0
  fi

  echo "💡 이 프로젝트에 Claude Code 하네스가 설정되지 않았습니다."
  echo "   /harness-setup 으로 자동 구성할 수 있습니다."
fi

exit 0
