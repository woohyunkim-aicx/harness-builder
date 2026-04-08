---
description: Auto-configure a production-grade Claude Code harness for your project
argument-hint: "[--cost-tier minimal|balanced|full]"
allowed-tools: Agent, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion, WebSearch
---

# /harness-setup

Auto-configure a fully customized Claude Code harness by analyzing your codebase, interviewing you, and generating optimized configuration files.

**Input**: $ARGUMENTS (optional: `--cost-tier minimal|balanced|full`)

---

## Pre-flight Check

1. Check if `.claude/harness-builder/harness-lock.json` exists
   - If yes: warn that a harness already exists, ask if user wants to update (suggest `/harness-update` instead) or regenerate from scratch
2. Check if `.claude/` directory exists with any configuration
   - If yes: note existing files — they will be backed up before generation

---

## Phase 1 — Codebase Analysis

Spawn a `codebase-analyzer` agent with this prompt:

> Analyze the codebase in the current working directory. Detect the tech stack, frameworks, database, testing, deployment, CI/CD, package manager, and any existing Claude Code configuration. Write your findings as structured JSON to `.claude/harness-builder/analysis.json`. See your agent instructions for the full detection matrix.

Wait for the agent to complete. Read the resulting `analysis.json` and summarize findings to the user in Korean:
- 탐지된 스택: {language} + {framework}
- 데이터베이스: {database} ({orm})
- 테스트: {testFramework}
- 배포: {deployTarget}
- 기존 하네스: {있음/없음}

---

## Phase 2 — User Interview

Conduct an adaptive interview using AskUserQuestion. The questions adapt based on Phase 1 results. Ask up to 4 questions at a time (AskUserQuestion limit).

### Round 1 (3 questions):

**Q1: 프로젝트 정보**
- Question: "프로젝트를 한 줄로 설명해주세요. 현재 어떤 단계인가요?"
- Options: "프로토타입 단계", "MVP 개발 중", "프로덕션 운영 중", "유지보수 모드"

**Q2: 비용 티어** (skip if --cost-tier was passed in $ARGUMENTS)
- Question: "Claude Code 사용 비용을 어떻게 관리하고 싶으세요?"
- Options:
  - "최소 비용 (sonnet only, ~$0.5/hr)" — minimal
  - "균형잡힌 구성 (opus 설계 + sonnet 실행, ~$2/hr) (추천)" — balanced
  - "풀 구성 (멀티모델 + 교차검증, ~$5/hr)" — full

**Q3: 자동화 수준**
- Question: "자동화를 얼마나 적극적으로 적용할까요?"
- Options:
  - "보수적 (수동 제어 선호)" — conservative
  - "적당한 자동화 (추천)" — moderate
  - "적극적 자동화 (가능한 모든 것 자동)" — aggressive

### Round 2 (3-4 questions, adaptive):

**Q4: 워크플로우**
- Question: "Git 워크플로우는 어떻게 사용하시나요?"
- Options: "PR 필수", "trunk-based (직접 push)", "혼자 작업 (solo)", "gitflow"

**Q5: 테스트 철학**
- Question: "테스트는 어떤 방식을 선호하시나요?"
- Options: "TDD (테스트 먼저)", "구현 후 테스트", "E2E 위주", "최소한만"

**Q6: 보안** (only if database detected)
- Question: "데이터베이스 보안 정책이 필요한가요?"
- Options: "읽기전용 스키마 있음 (보호 필요)", "단일 DB (기본 보호)", "보안 불필요"

**Q7: 언어**
- Question: "CLAUDE.md와 터미널 소통 언어는?"
- Options: "한국어", "영어", "혼합 (한국어 UI + 영어 코드)"

### Round 3 (conditional, 1-2 questions):

**Q8**: If frontend detected — "디자인 시스템이 있나요?" (있음/없음/만들 예정)
**Q9**: If existing harness detected — "기존 설정을 어떻게 할까요?" (유지하고 병합/새로 생성/선택적 유지)

Save all answers to `.claude/harness-builder/interview.json`.

---

## Phase 3 — Configuration Generation

Read both `analysis.json` and `interview.json`. Then spawn a `config-generator` agent with this prompt:

> Generate a complete Claude Code harness for this project. Here is the analysis: {analysis.json content}. Here are the interview results: {interview.json content}.
>
> Follow your agent instructions for the full generation sequence. Key requirements:
> 1. Backup existing .claude/ first
> 2. Generate settings.json, hooks, skills, agents, CLAUDE.md
> 3. Use section markers in CLAUDE.md for managed blocks
> 4. Create harness-lock.json tracking all managed files
> 5. Agent count and model assignments must match the cost tier: {tier}
> 6. Automation level: {level}
>
> Reference templates are in: ${CLAUDE_PLUGIN_ROOT}/templates/

Wait for the agent to complete. Summarize what was generated to the user in Korean.

---

## Phase 4 — Verification & Guide

Spawn a `harness-verifier` agent with this prompt:

> Verify the generated harness in .claude/ directory. Check JSON validity, script permissions, CLAUDE.md line count, frontmatter validity, and no leaked secrets. Then generate a Korean usage guide at .claude/docs/HARNESS-GUIDE.md. See your agent instructions for the full checklist.

Wait for the agent to complete. Display the verification results.

---

## Completion

Print a summary in Korean:

```
✅ 하네스 구성 완료!

📁 생성된 파일:
  - .claude/settings.json (권한 설정)
  - .claude/hooks/hooks.json (라이프사이클 훅)
  - .claude/skills/ ({N}개 프로젝트 스킬)
  - .claude/agents/ ({N}개 에이전트 프로필)
  - CLAUDE.md (에이전트 라우팅 + 모델 정책)
  - .claude/docs/HARNESS-GUIDE.md (사용 가이드)

💡 다음 단계:
  - /harness-guide 로 한국어 가이드 확인
  - /harness-status 로 현재 구성 확인
  - /harness-update 로 나중에 업데이트
```
