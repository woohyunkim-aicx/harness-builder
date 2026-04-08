# Interview Question Bank

## Overview

The interview is adaptive — questions change based on Phase 1 analysis results. Questions are asked via AskUserQuestion (max 4 per call). Conducted in Korean with clear, natural phrasing.

**Design principles**:
- Questions go from broad context to specific preferences
- Each answer unlocks follow-up questions (branching tree)
- Extract pain points and workflow patterns, not just settings
- Free-text "Other" option always available for nuance
- Total: 6 rounds, 15-25 questions depending on project complexity

---

## Round 1: Project Context (4 questions)

### Q1: Project Description
- Question: "이 프로젝트를 한 줄로 설명해주세요."
- Header: "프로젝트 설명"
- Type: Free text (no options — use AskUserQuestion with generic options that prompt "Other")
- Options:
  - "내부 도구 / 어드민" — Internal tool
  - "사용자 서비스 / SaaS" — User-facing product
  - "데이터 파이프라인 / 배치" — Data processing
  - "라이브러리 / SDK" — Library or package
- Impact: Determines entire skill/agent composition. Internal tool → ops focus. SaaS → security focus. Data → pipeline skills. Library → testing focus.

### Q2: Project Phase
- Question: "프로젝트의 현재 단계는 어떻게 되나요?"
- Header: "프로젝트 단계"
- Options:
  - "프로토타입/PoC" — Rapid iteration, minimal guardrails
  - "MVP 개발 중" — Core features, some structure
  - "프로덕션 운영 중" — Live users, stability critical
  - "유지보수/레거시" — Bug fixes, careful changes
- Impact: prototype → aggressive automation, minimal security. production → conservative automation, full security.

### Q3: Team Structure
- Question: "이 프로젝트에서 Claude Code를 사용하는 사람이 몇 명인가요?"
- Header: "팀 규모"
- Options:
  - "나 혼자" — Solo developer
  - "2-3명 소규모" — Small team
  - "4명 이상 팀" — Larger team
  - "여러 팀이 협업" — Cross-team
- Impact: Solo → no commit blocking, simple workflow. Team → PR required, code review agents, shared conventions.

### Q4: Claude Code Experience
- Question: "Claude Code를 얼마나 사용해보셨나요?"
- Header: "경험 수준"
- Options:
  - "처음 사용" — Need onboarding guide, conservative defaults
  - "기본 사용 중" — Using but no custom harness
  - "커스텀 설정 있음" — Has some .claude/ config already
  - "하네스 운영 경험" — Advanced user, wants fine control
- Impact: Beginner → detailed guide, safe defaults, less automation. Advanced → trust user, more options, full features.

---

## Round 2: Workflow & Process (4 questions)

### Q5: Primary Work Pattern
- Question: "주로 어떤 작업을 Claude Code로 하시나요? (복수 선택)"
- Header: "주요 작업"
- multiSelect: true
- Options:
  - "새 기능 개발" — Feature development → planner agent, TDD
  - "버그 수정" — Bug fixes → debugging skills, systematic approach
  - "리팩토링" — Refactoring → architect agent, code review
  - "코드 리뷰 / PR" — Reviews → code-review plugin, PR tools
- Impact: Directly determines which agents and skills to prioritize.

### Q6: Git Workflow
- Question: "Git 워크플로우는 어떻게 사용하시나요?"
- Header: "Git 전략"
- Options:
  - "PR 필수 (팀 리뷰)" — block-commits-to-main, PR commands
  - "trunk-based (직접 push)" — No commit blocking
  - "혼자 작업 (solo)" — Minimal git hooks
  - "gitflow (feature/develop/release)" — Branch naming conventions
- Impact: Hookify rules, commit commands, branch protection.

### Q7: Testing Philosophy
- Question: "테스트는 어떤 방식을 선호하시나요?"
- Header: "테스트 방식"
- Options:
  - "TDD (테스트 먼저 작성)" — TDD agent, coverage hooks, test-first workflow
  - "구현 후 테스트 추가" — Standard test patterns
  - "E2E 위주 (Playwright/Cypress)" — E2E agent, browser testing
  - "최소한만 / 아직 없음" — No test enforcement
- Impact: Test skills, TDD agent inclusion, coverage hooks.

### Q8: Code Review Expectations
- Question: "코드 리뷰를 어떻게 하고 싶으세요?"
- Header: "코드 리뷰"
- Options:
  - "자동 리뷰 (커밋마다)" — Auto-trigger code-reviewer on changes
  - "수동 호출 (/review)" — Manual trigger only
  - "PR 생성 시만" — Review only at PR time
  - "필요 없음" — No code review
- Impact: code-review plugin inclusion, automation tier for reviews.

---

## Round 3: Cost & Automation (4 questions)

### Q9: Cost Tier
- Skip condition: `--cost-tier` passed in arguments
- Question: "Claude Code 사용 비용을 어떻게 관리하고 싶으세요?"
- Header: "비용 관리"
- Options:
  - "최소 비용 (~$0.5/hr) — sonnet only" — 2 agents, basic hooks
  - "균형 구성 (~$2/hr) — opus 설계 + sonnet 실행 (추천)" — 4 agents, full hooks
  - "풀 구성 (~$5/hr) — 멀티모델 + 교차검증" — 6+ agents, adversarial review
- Impact: Model selection, agent count, parallel ops.

### Q10: Automation Philosophy
- Question: "Claude Code가 실수했을 때 어떻게 대응하고 싶으세요?"
- Header: "실수 대응"
- Options:
  - "내가 직접 확인하고 수정" — Conservative, manual control
  - "자동 검사하되 수정은 물어보고 (추천)" — Moderate, hooks check + ask
  - "가능한 자동으로 해결" — Aggressive, auto-fix builds/types
- Impact: Stop hook behavior, build-error-resolver triggering.

### Q11: Parallel Work
- Question: "여러 에이전트를 동시에 실행하는 것에 대해 어떻게 생각하세요?"
- Header: "병렬 작업"
- Options:
  - "한 번에 하나씩" — Sequential only, lowest cost
  - "독립적인 작업은 병렬로 (추천)" — Parallel for independent tasks
  - "적극적으로 병렬 활용" — Multi-agent orchestration
- Impact: Parallel agent limits, orchestration patterns.

### Q12: Context Management
- Question: "작업 중 컨텍스트가 길어지면 어떻게 하시나요?"
- Header: "컨텍스트 관리"
- Options:
  - "/clear 자주 사용" — Recommends frequent clearing
  - "자연스럽게 계속 진행" — No special handling
  - "잘 모르겠음" — Will suggest best practices in guide
- Impact: Memory plugin recommendation, session tracking hooks.

---

## Round 4: Security & Safety (3-4 questions)

### Q13: Sensitive Data
- Question: "이 프로젝트에서 다루는 민감 데이터가 있나요? (복수 선택)"
- Header: "민감 데이터"
- multiSelect: true
- Options:
  - "개인정보 (PII)" — PII masking skill, strict deny-list
  - "API 키 / 시크릿" — Secret detection hookify rules
  - "결제 / 금융 데이터" — Extra security review agent
  - "없음 / 해당 없음" — Basic security only
- Impact: Security agent inclusion, hookify rules depth.

### Q14: Database Security (conditional: DB detected)
- Skip condition: No database in analysis
- Question: "데이터베이스 보안 설정이 필요한가요?"
- Header: "DB 보안"
- Options:
  - "읽기전용 스키마 있음 (보호 필요)" — Full DB protection hooks, migration blocking
  - "단일 DB (기본 보호)" — Block destructive ops only
  - "개발 DB만 사용 (보호 불필요)" — No DB hooks
- Impact: Hook matchers, database-protection.json, deny patterns.

### Q15: Deployment Safety (conditional: deployment detected)
- Skip condition: No deployment config in analysis
- Question: "배포 관련 안전장치가 필요한가요?"
- Header: "배포 안전"
- Options:
  - "프로덕션 직접 배포 차단" — Block prod deploy commands
  - "--dry-run 강제" — Require dry-run for scripts
  - "CI/CD가 처리 (별도 불필요)" — No deploy hooks
- Impact: Deploy-related hookify rules, script protection.

### Q16: Secret Management
- Skip condition: Q13 answered "없음"
- Question: "시크릿은 어떻게 관리하나요?"
- Header: "시크릿 관리"
- Options:
  - "환경변수 (.env)" — .env deny patterns, .gitignore check
  - "AWS SSM / Vault / 클라우드" — Cloud-specific deny patterns
  - "직접 관리" — Basic secret detection only
- Impact: Deny pattern specificity, secret rotation guidance.

---

## Round 5: Development Experience (3-4 questions)

### Q17: Communication Language
- Question: "CLAUDE.md와 터미널 소통 언어는?"
- Header: "소통 언어"
- Options:
  - "한국어" — Korean CLAUDE.md, Korean commit messages, Korean guide
  - "영어" — English everything
  - "혼합 (한국어 UI + 영어 코드)" — Mixed mode
- Impact: CLAUDE.md language, commit format, guide language.

### Q18: Pain Points
- Question: "Claude Code 사용 중 가장 불편했던 점이 있나요? (복수 선택)"
- Header: "페인포인트"
- multiSelect: true
- Options:
  - "같은 실수 반복" — Hookify rules to prevent recurrence
  - "컨텍스트 날아감" — Memory plugin, session tracking
  - "빌드/타입 에러 반복" — Auto tsc-check, build-resolver
  - "특별히 없음" — Default configuration
- Impact: Directly maps to specific hooks, plugins, and rules. This is the most actionable question.

### Q19: Commit Style
- Question: "커밋 메시지 스타일은?"
- Header: "커밋 스타일"
- Options:
  - "Conventional Commits (feat/fix/refactor)" — Add commit conventions to CLAUDE.md
  - "자유 형식" — No commit format enforcement
  - "이슈 번호 포함 (T-001)" — Issue tracker integration
- Impact: CLAUDE.md commit section, commit-commands plugin config.

### Q20: Design System (conditional: frontend detected)
- Skip condition: No frontend framework
- Question: "디자인 시스템이나 UI 컨벤션이 있나요?"
- Header: "디자인 시스템"
- Options:
  - "있음 (DESIGN.md, Figma, Storybook 등)" — Create UI skill with design reference
  - "컴포넌트 라이브러리 사용 (shadcn, MUI 등)" — Add component library skill
  - "없음, 자유롭게" — Skip UI-specific skill
- Impact: UI patterns skill, frontend-design plugin recommendation.

---

## Round 6: Advanced Preferences (conditional, 2-4 questions)

### Q21: Existing Plugins (conditional: user has Claude Code experience)
- Skip condition: Q4 answered "처음 사용"
- Question: "현재 사용 중인 Claude Code 플러그인이 있나요? (복수 선택)"
- Header: "기존 플러그인"
- multiSelect: true
- Options:
  - "Superpowers" — Skip recommending, ensure coexistence
  - "Everything Claude Code (ECC)" — Careful namespace collision avoidance
  - "GSD" — Complementary, skip phase management features
  - "없음 / 기억 안 남" — Full recommendation
- Impact: Plugin recommendation deduplication, conflict prevention.

### Q22: Existing Config (conditional: existing harness detected)
- Skip condition: No existing .claude/ config
- Question: "기존 Claude Code 설정을 어떻게 할까요?"
- Header: "기존 설정"
- Options:
  - "유지하고 병합 (추천)" — Deep merge, preserve user files
  - "새로 생성 (백업 후)" — Full regeneration
  - "선택적으로 확인" — Ask per-file before overwriting
- Impact: Merge strategy in config-generator.

### Q23: Custom Rules (conditional: advanced user)
- Skip condition: Q4 NOT "하네스 운영 경험"
- Question: "특별히 추가하고 싶은 규칙이 있나요?"
- Header: "커스텀 규칙"
- Options:
  - "console.log 경고" — warn-console-log hookify rule
  - "SQL injection 경고" — warn-sql-injection hookify rule
  - "특정 파일 보호" — Custom file protection
  - "없음" — Default rules only
- multiSelect: true
- Impact: Additional hookify rules beyond defaults.

### Q24: Documentation (conditional: team > 1)
- Skip condition: Q3 answered "나 혼자"
- Question: "팀원들을 위한 문서가 필요한가요?"
- Header: "팀 문서"
- Options:
  - "상세 가이드 필요 (추천)" — Full HARNESS-GUIDE.md with examples
  - "간단한 요약만" — Compact guide
  - "불필요 (구두 전달)" — Skip guide generation
- Impact: Guide generation depth, onboarding content.

---

## Branching Logic Summary

```
ALWAYS ASK (all users):
  Round 1: Q1, Q2, Q3, Q4                          (4 questions)
  Round 2: Q5, Q6, Q7, Q8                          (4 questions)
  Round 3: Q9*, Q10, Q11, Q12                      (3-4 questions)
  Round 5: Q17, Q18, Q19                           (3 questions)

CONDITIONAL:
  Round 4 (Security):
    Q13: Always                                     (+1)
    Q14: If database detected                       (+0-1)
    Q15: If deployment detected                     (+0-1)
    Q16: If Q13 != "없음"                           (+0-1)
  
  Round 5 (continued):
    Q20: If frontend detected                       (+0-1)
  
  Round 6 (Advanced):
    Q21: If Q4 != "처음 사용"                       (+0-1)
    Q22: If existing .claude/ detected              (+0-1)
    Q23: If Q4 == "하네스 운영 경험"                (+0-1)
    Q24: If Q3 != "나 혼자"                         (+0-1)

SKIP:
  Q9: If --cost-tier argument provided

MINIMUM: 15 questions (solo beginner, no DB, no frontend, no deploy, --cost-tier set)
MAXIMUM: 24 questions (experienced team user, DB + frontend + deploy, all conditions met)
TYPICAL: 18-20 questions
```

## AskUserQuestion Batching (max 4 per call)

```
Call 1: Q1, Q2, Q3, Q4         (Round 1)
Call 2: Q5, Q6, Q7, Q8         (Round 2)
Call 3: Q9, Q10, Q11, Q12      (Round 3)
Call 4: Q13, Q14*, Q15*, Q16*  (Round 4 — conditional questions)
Call 5: Q17, Q18, Q19, Q20*    (Round 5)
Call 6: Q21*, Q22*, Q23*, Q24* (Round 6 — all conditional)

* = conditional, skip if condition not met
If a round has <2 questions after skipping, merge with next round.
```

---

## Output Schema

Save to `.claude/harness-builder/interview.json`:

```json
{
  "timestamp": "ISO-8601",
  "project": {
    "description": "User's description",
    "type": "internal-tool",
    "phase": "mvp",
    "teamSize": "small-team",
    "claudeExperience": "basic"
  },
  "workflow": {
    "primaryTasks": ["feature-dev", "bug-fix"],
    "gitStrategy": "pr-required",
    "testPhilosophy": "tdd",
    "codeReview": "auto-on-commit",
    "commitStyle": "conventional"
  },
  "cost": {
    "tier": "balanced",
    "automationPhilosophy": "moderate",
    "parallelWork": "independent-parallel",
    "contextManagement": "frequent-clear"
  },
  "security": {
    "sensitiveData": ["pii", "api-keys"],
    "dbSecurity": "read-only-schemas",
    "deploymentSafety": "block-prod",
    "secretManagement": "env-vars"
  },
  "experience": {
    "language": "mixed",
    "painPoints": ["repeated-mistakes", "build-errors"],
    "designSystem": "component-library",
    "existingPlugins": ["superpowers"],
    "existingConfigStrategy": "merge",
    "customRules": ["warn-console-log"],
    "documentationDepth": "detailed"
  }
}
```

## Question → Configuration Mapping

This table shows how each answer directly drives harness generation:

| Answer | Generated Config |
|--------|-----------------|
| type=internal-tool | Ops-focused skills, admin UI patterns |
| type=saas | Security-first, user-facing patterns |
| type=data-pipeline | Pipeline runner skill, --dry-run hooks |
| type=library | Testing focus, API documentation skill |
| phase=prototype | Minimal hooks, aggressive automation |
| phase=production | Full hooks, conservative automation |
| teamSize=solo | No commit blocking, simple workflow |
| teamSize=team | PR hooks, shared conventions, code review |
| claudeExperience=beginner | Detailed guide, safe defaults, more guardrails |
| claudeExperience=advanced | Trust user, expose more options |
| primaryTasks=feature-dev | Planner agent, TDD workflow |
| primaryTasks=bug-fix | Debugging skills, systematic approach |
| primaryTasks=refactoring | Architect agent, dead code detection |
| primaryTasks=code-review | Code-review plugin, PR tools |
| painPoints=repeated-mistakes | Hookify rules to prevent recurrence |
| painPoints=context-lost | claude-mem plugin, session tracking |
| painPoints=build-errors | Auto tsc-check, build-resolver |
| sensitiveData=pii | PII masking patterns, strict deny |
| sensitiveData=api-keys | Secret detection, .env protection |
| existingPlugins=superpowers | Don't recommend, ensure coexistence |
| existingPlugins=ecc | Namespace carefully, skip duplicate skills |
