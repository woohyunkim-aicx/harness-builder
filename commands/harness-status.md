---
description: Show current harness configuration summary
argument-hint: ""
allowed-tools: Read, Bash, Glob, Grep
---

# /harness-status

Display a summary of the current Claude Code harness configuration.

---

## Steps

1. Check if `.claude/harness-builder/harness-lock.json` exists
   - If not: "⚠ 하네스가 설정되지 않았습니다. `/harness-setup`을 실행해주세요."

2. Read `harness-lock.json`, `analysis.json`, `interview.json`

3. Count generated artifacts:
   - Skills: count directories in `.claude/skills/`
   - Agents: count `.md` files in `.claude/agents/`
   - Hook scripts: count `.sh` files in `.claude/scripts/`
   - Hookify rules: count `.claude/hookify.*.local.md` files

4. Display summary in Korean:

```
📊 하네스 상태
================

🔧 설정
  비용 티어: {balanced/minimal/full}
  자동화 수준: {conservative/moderate/aggressive}
  생성일: {date}

📁 구성 요소
  스킬: {N}개
  에이전트: {N}개
  훅 스크립트: {N}개
  보안 규칙: {N}개 deny 패턴

🛡 보안
  DB 보호: {활성/비활성}
  시크릿 차단: {활성/비활성}

📐 CLAUDE.md
  라인 수: {N}
  관리 섹션: {N}개

🔗 관련 커맨드
  /harness-update — 하네스 업데이트
  /harness-guide — 사용 가이드 보기
```
