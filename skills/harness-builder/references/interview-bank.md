# Interview Question Bank

## Overview

The interview is adaptive — questions change based on Phase 1 analysis results. Questions are asked via AskUserQuestion (max 4 per call). Conducted in Korean with clear, natural phrasing.

## Round 1: Core Preferences (3 questions)

### Q1: Project Phase
- Question: "프로젝트의 현재 단계는 어떻게 되나요?"
- Header: "프로젝트 단계"
- Options:
  - "프로토타입/PoC" — Early stage, rapid iteration
  - "MVP 개발 중" — Building core features
  - "프로덕션 운영 중" — Live users, stability matters
  - "유지보수 모드" — Bug fixes, minor improvements
- Impact: Affects hook aggressiveness, security level

### Q2: Cost Tier
- Skip condition: `--cost-tier` passed in arguments
- Question: "Claude Code 사용 비용을 어떻게 관리하고 싶으세요?"
- Header: "비용 관리"
- Options:
  - "최소 비용 (~$0.5/hr)" — sonnet only, 2 agents
  - "균형 구성 (~$2/hr) (추천)" — opus + sonnet, 4 agents
  - "풀 구성 (~$5/hr)" — multi-model, 6+ agents
- Impact: Model selection, agent count, parallel ops

### Q3: Automation Level
- Question: "자동화를 얼마나 적극적으로 적용할까요?"
- Header: "자동화 수준"
- Options:
  - "보수적 (수동 제어)" — Minimal hooks, no auto-resolve
  - "적당한 자동화 (추천)" — Build hooks, context-based agents
  - "적극적 자동화" — Auto-resolve builds, full lifecycle hooks
- Impact: Hook count, automation tier assignments

## Round 2: Workflow (3-4 questions)

### Q4: Git Workflow
- Question: "Git 워크플로우는 어떻게 사용하시나요?"
- Header: "Git 전략"
- Options:
  - "PR 필수 (팀 리뷰)" — Add block-commits-to-main hookify
  - "trunk-based (직접 push)" — No commit blocking
  - "혼자 작업" — Minimal git hooks
  - "gitflow" — Feature/develop/release branches
- Impact: Hookify rules, commit commands

### Q5: Testing Philosophy
- Question: "테스트는 어떤 방식을 선호하시나요?"
- Header: "테스트 방식"
- Options:
  - "TDD (테스트 먼저)" — Add TDD agent, coverage hooks
  - "구현 후 테스트" — Standard test patterns
  - "E2E 위주" — Playwright/Cypress focus
  - "최소한만" — No test enforcement
- Impact: Test skills, TDD agent inclusion

### Q6: Database Security (conditional: DB detected)
- Skip condition: No database in analysis
- Question: "데이터베이스 보안이 필요한가요?"
- Header: "DB 보안"
- Options:
  - "읽기전용 스키마 있음" — Full DB protection hooks
  - "단일 DB (기본 보호)" — Basic destructive op blocking
  - "보안 불필요" — No DB hooks
- Impact: Hook matchers, database-protection.json

### Q7: Communication Language
- Question: "CLAUDE.md와 터미널 소통 언어는?"
- Header: "소통 언어"
- Options:
  - "한국어" — Korean CLAUDE.md, Korean commit messages
  - "영어" — English everything
  - "혼합 (한국어 UI + 영어 코드)" — Mixed mode
- Impact: CLAUDE.md language, commit format

## Round 3: Domain-Specific (conditional, 1-2 questions)

### Q8: Design System (conditional: frontend detected)
- Skip condition: No frontend framework
- Question: "디자인 시스템이 있나요?"
- Header: "디자인 시스템"
- Options:
  - "있음 (DESIGN.md 또는 Figma)" — Create UI skill with design token reference
  - "없음, 만들 예정" — Create placeholder design skill
  - "없음, 불필요" — Skip UI-specific skill
- Impact: UI patterns skill content

### Q9: Existing Config (conditional: existing harness detected)
- Skip condition: No existing .claude/ config
- Question: "기존 Claude Code 설정을 어떻게 할까요?"
- Header: "기존 설정"
- Options:
  - "유지하고 병합" — Deep merge, preserve user files
  - "새로 생성 (백업 후)" — Full regeneration
  - "선택적 유지" — Ask per-file
- Impact: Merge strategy in config-generator

## Branching Logic Summary

```
Always ask: Q1, Q3, Q7
Skip Q2 if: --cost-tier argument provided
Skip Q6 if: No database detected
Skip Q8 if: No frontend framework detected
Skip Q9 if: No existing .claude/ directory

Minimum questions: 4 (no DB, no frontend, no existing config, --cost-tier set)
Maximum questions: 9 (all conditions met)
```

## Output Schema

Save to `.claude/harness-builder/interview.json`:

```json
{
  "timestamp": "ISO-8601",
  "projectPhase": "mvp",
  "costTier": "balanced",
  "automationLevel": "moderate",
  "gitWorkflow": "pr-required",
  "testPhilosophy": "tdd",
  "dbSecurity": "read-only-schemas",
  "language": "mixed",
  "designSystem": "exists",
  "existingConfigStrategy": "merge",
  "projectDescription": "User's one-line description"
}
```
