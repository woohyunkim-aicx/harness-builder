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

## Phase 2 — Deep User Interview

Conduct an adaptive deep interview using AskUserQuestion. Questions are batched in rounds of 4 (AskUserQuestion limit). The interview adapts based on Phase 1 results and previous answers. Total 15-24 questions across 6 rounds.

Read the full question bank at `${CLAUDE_PLUGIN_ROOT}/skills/harness-builder/references/interview-bank.md` for detailed options and branching logic.

### Round 1: Project Context (4 questions)
- Q1: 프로젝트 유형 (내부 도구/SaaS/데이터 파이프라인/라이브러리)
- Q2: 프로젝트 단계 (프로토타입/MVP/프로덕션/유지보수)
- Q3: 팀 규모 (혼자/소규모/팀/여러 팀)
- Q4: Claude Code 경험 수준 (처음/기본/커스텀 있음/하네스 경험)

### Round 2: Workflow & Process (4 questions)
- Q5: 주요 작업 패턴 (복수 선택: 기능 개발/버그 수정/리팩토링/코드 리뷰)
- Q6: Git 워크플로우 (PR 필수/trunk-based/solo/gitflow)
- Q7: 테스트 방식 (TDD/구현 후/E2E/최소한)
- Q8: 코드 리뷰 기대 (자동/수동/PR 시만/불필요)

### Round 3: Cost & Automation (3-4 questions)
- Q9: 비용 티어 (skip if --cost-tier passed)
- Q10: 실수 대응 방식 (직접 수정/자동 검사+물어보기/자동 해결)
- Q11: 병렬 작업 선호도 (하나씩/독립 작업 병렬/적극 병렬)
- Q12: 컨텍스트 관리 (/clear 자주/자연스럽게/모르겠음)

### Round 4: Security & Safety (conditional, 1-4 questions)
- Q13: 민감 데이터 종류 (복수 선택: PII/API키/금융/없음)
- Q14: DB 보안 (if DB detected)
- Q15: 배포 안전장치 (if deployment detected)
- Q16: 시크릿 관리 (if Q13 != "없음")

### Round 5: Development Experience (3-4 questions)
- Q17: 소통 언어 (한국어/영어/혼합)
- Q18: 페인포인트 (복수 선택: 같은 실수 반복/컨텍스트 날아감/빌드 에러/없음)
- Q19: 커밋 스타일 (Conventional/자유/이슈 번호)
- Q20: 디자인 시스템 (if frontend detected)

### Round 6: Advanced (conditional, 0-4 questions)
- Q21: 기존 플러그인 (if experienced user)
- Q22: 기존 설정 처리 (if existing .claude/)
- Q23: 커스텀 규칙 (if advanced user)
- Q24: 팀 문서 필요성 (if team > 1)

Save all answers to `.claude/harness-builder/interview.json`.

---

## Phase 2.5 — Plugin Discovery & Recommendation

Search for plugins and skills that match the detected stack and user preferences.

### Step 1: Web Search (parallel, 3 searches)

Run these WebSearch queries in parallel:

1. `"Claude Code plugin" {framework} {language} 2026 github` — stack-specific plugins
2. `"Claude Code skills" best {category} 2026` — where category = workflow/testing/security based on interview
3. `site:github.com claude-code plugin marketplace {language}` — marketplace repos

### Step 2: Known Marketplace Scan

Read `${CLAUDE_PLUGIN_ROOT}/skills/harness-builder/references/plugin-catalog.md` for the pre-vetted plugin catalog. Score each plugin using the formula:

```
score = (stack_match × 0.4) + (workflow_match × 0.3) + (popularity × 0.1) + (cost_fit × 0.2)
```

### Step 3: Merge & Deduplicate

Combine web search results with the known catalog:
- Deduplicate by plugin name
- Flag web-discovered plugins as "unvetted" (not in catalog)
- Sort by score descending

### Step 4: Present to User

Present recommendations in 3 tiers using AskUserQuestion (multiSelect: true):

**필수 (자동 선택)**:
- hookify (모든 프로젝트)
- LSP plugin (스택에 맞는 것: typescript-lsp, pyright-lsp, etc.)

**추천 (score > 0.7)**:
- List recommended plugins with brief Korean descriptions
- Pre-select recommended ones

**선택 / 웹에서 발견**:
- Lower-scored plugins and web-discovered ones
- Mark unvetted ones with "(미검증)" label

Let user check/uncheck selections.

### Step 5: Install Selected Plugins

For each selected plugin, note the install command in the output. Do NOT auto-install — instead, list commands the user should run after harness setup:

```bash
claude plugin marketplace add {marketplace-url}
claude plugin install {plugin-name}
```

Save selections to `.claude/harness-builder/plugin-selection.json`.

---

## Phase 3 — Configuration Generation

Read `analysis.json`, `interview.json`, and `plugin-selection.json`. Then spawn a `config-generator` agent with this prompt:

> Generate a complete Claude Code harness for this project. Here is the analysis: {analysis.json content}. Here are the interview results: {interview.json content}. Here are the selected plugins: {plugin-selection.json content}.
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

🔌 추천 플러그인 설치:
  {for each selected plugin:}
  - claude plugin install {plugin-name}

💡 다음 단계:
  - /harness-guide 로 한국어 가이드 확인
  - /harness-status 로 현재 구성 확인
  - /harness-update 로 나중에 업데이트
```
