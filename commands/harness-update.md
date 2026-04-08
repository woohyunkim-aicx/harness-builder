---
description: Update an existing harness — re-analyze codebase and regenerate managed sections only
argument-hint: "[--force]"
allowed-tools: Agent, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# /harness-update

Update an existing Claude Code harness by re-analyzing the codebase and regenerating only managed sections.

**Input**: $ARGUMENTS (optional: `--force` to skip confirmation)

---

## Pre-flight

1. Check `.claude/harness-builder/harness-lock.json` exists
   - If not: "하네스가 설정되지 않았습니다. `/harness-setup`을 먼저 실행해주세요." → exit
2. Read `harness-lock.json` to understand current managed files

---

## Phase 1 — Re-analyze

Spawn `codebase-analyzer` agent to re-detect the tech stack. Compare with previous `analysis.json`:

- If stack changed: warn user in Korean, ask if they want to proceed
- If no changes: skip to Phase 2

Update `.claude/harness-builder/analysis.json` with new results.

---

## Phase 2 — Selective Regeneration

For each file in `harness-lock.json.managedFiles`:

### Strategy: "full"
- Regenerate the entire file from templates using current analysis + interview data

### Strategy: "merge"
- Read current file
- Only update the sections listed in `harness-lock.json` (e.g., `permissions.deny`)
- Preserve all other content

### Strategy: "sections"
- Read current file
- Only regenerate content between `<!-- harness-builder:start:X -->` and `<!-- harness-builder:end:X -->` markers
- Preserve everything outside markers

### Strategy: "none"
- Skip — user-managed file

---

## Phase 3 — Verify

Spawn `harness-verifier` agent to validate all changes.

---

## Completion

```
✅ 하네스 업데이트 완료!

변경 사항:
  - {list of files updated}
  - {list of files unchanged}

사용자 파일 보존됨: {count}개
```
