# harness-builder

[English](./README.md) | [한국어](./README-KR.md)

프로젝트에 맞는 프로덕션 수준의 Claude Code 하네스를 4분 안에 자동 구성합니다.

![Version](https://img.shields.io/badge/version-0.1.0-blue) ![License](https://img.shields.io/badge/license-MIT-green) ![Stars](https://img.shields.io/github/stars/woohyunkim-aicx/harness-builder?style=social)

코드베이스를 분석하고, 적응형 인터뷰를 진행한 뒤, 실제 기술 스택과 워크플로우에 최적화된 스킬, 에이전트, 훅, 보안 규칙을 생성합니다. 범용 템플릿이 아닌 프로젝트 맞춤 설정입니다.

---

## 왜 harness-builder인가?

- **수 시간 → 4분.** `.claude/`를 처음부터 설정하면 반나절이 걸립니다. harness-builder는 커맨드 하나로 끝냅니다.
- **증거 기반.** 실제 코드를 읽습니다 — import, 설정 파일, CI 파이프라인 — 그 다음에 생성합니다. 템플릿이 아니라 프로젝트를 반영합니다.
- **비파괴 설계.** 매 실행마다 기존 파일을 백업합니다. 섹션 마커와 lock 파일로 커스텀 설정을 건드리지 않고 정밀하게 업데이트합니다.
- **비용 인식.** 판단이 필요한 곳(설계, 아키텍처)에만 opus를 사용하고, 실행은 sonnet으로. `--cost-tier`로 직접 설정 가능합니다.
- **초보자 친화 인터뷰.** 6라운드 적응형 인터뷰(15-24개 질문)가 경험 수준에 맞춰 깊이를 조절합니다. 초보자에겐 안전한 기본값을, 숙련자에겐 전체 옵션을 제공합니다.

---

## 목차

- [빠른 시작](#빠른-시작)
- [동작 방식](#동작-방식)
- [심층 인터뷰 시스템](#심층-인터뷰-시스템)
- [비용 티어](#비용-티어)
- [지원 스택](#지원-스택)
- [생성되는 파일](#생성되는-파일)
- [커맨드](#커맨드)
- [공존성과 안전성](#공존성과-안전성)
- [출력 예시](#출력-예시)
- [설계 원칙](#설계-원칙)
- [문제 해결](#문제-해결)
- [FAQ](#faq)
- [기여 방법](#기여-방법)
- [라이선스](#라이선스)

---

## 빠른 시작

```bash
# 1. 마켓플레이스 추가
claude plugin marketplace add woohyunkim/harness-builder

# 2. 설치
claude plugin install harness-builder

# 3. 설정 실행
/harness-setup
```

**설치 확인:**

```bash
/harness-status
# 예상 출력: "harness-builder v0.1.0 — active"
```

---

## 동작 방식

```
/harness-setup
│
├── Phase 1: 코드베이스 분석
│   탐지: 언어, 프레임워크, DB, 테스트, 배포,
│   CI/CD, 패키지 매니저, 기존 설정
│   출력: .claude/harness-builder/analysis.json
│
├── Phase 2: 유저 인터뷰
│   질문: 프로젝트 단계, 비용 티어, 자동화 수준,
│   Git 전략, 테스트 방식, 보안 요구사항
│   출력: .claude/harness-builder/interview.json
│
├── Phase 3: 설정 파일 생성
│   생성: settings.json, 훅, 스킬, 에이전트,
│   CLAUDE.md, 스크립트, 보안 규칙
│   출력: .claude/* (전체 하네스)
│
└── Phase 4: 검증 + 가이드
    검증: JSON, 권한, frontmatter, 시크릿
    생성: .claude/docs/HARNESS-GUIDE.md
```

### 수동 설정 vs 자동 설정 — 시간 비교

| 작업 | 수동 | harness-builder |
|------|------|-----------------|
| CLAUDE.md 처음부터 작성 | 45-90분 | 설정에 포함 |
| hooks.json 구성 | 30-60분 | 설정에 포함 |
| 에이전트 프로필 정의 | 60-120분 | 설정에 포함 |
| 도메인 스킬 작성 | 60-90분 | 설정에 포함 |
| 보안 deny-list 설정 | 20-30분 | 설정에 포함 |
| 스택 변경 후 재동기화 | 30-60분 | `/harness-update` (~1분) |
| **합계** | **4-7시간** | **~4분** |

---

## 심층 인터뷰 시스템

harness-builder는 뻔한 질문을 하지 않습니다. 6라운드에 걸쳐 15-24개의 질문을 하며, 이전 답변에 따라 적응합니다.

| 라운드 | 주제 | 질문 예시 |
|--------|------|----------|
| 1 | 프로젝트 맥락 | 단계 (PoC / 성장 / 안정), 팀 규모, 마감 압박 |
| 2 | 비용과 모델 정책 | 시간당 예산, opus vs sonnet 사용 기준 |
| 3 | 자동화 선호도 | 자동 트리거할 것 vs 명시적 승인이 필요한 것 |
| 4 | Git과 리뷰 워크플로우 | 브랜치 전략, PR 리뷰 요구사항, 커밋 스타일 |
| 5 | 테스트 철학 | 커버리지 목표, TDD 선호도, E2E 도구 |
| 6 | 보안 태세 | 데이터 민감도, 시크릿 관리, 감사 요구사항 |

**적응형 깊이:** 1라운드에서 "Claude Code 처음 사용"이라고 답하면, 2-6라운드는 안전한 추천값으로 기본 설정하고 고급 옵션을 생략합니다. 경험이 있다고 답하면 모든 옵션을 보여줍니다.

각 답변은 하나 이상의 생성 설정값에 직접 매핑됩니다. 템플릿에서 추론하는 것이 아니라, 인터뷰 응답과 코드베이스 분석에서 모든 출력이 도출됩니다.

---

## 비용 티어

| 티어 | 모델 | 에이전트 | 훅 | 예상 비용/hr | 적합한 프로젝트 |
|------|------|---------|-----|-------------|----------------|
| **minimal** | sonnet only | 2개 | 기본 | ~$0.5 | 사이드 프로젝트, 학습, 빠듯한 예산 |
| **balanced** | opus + sonnet | 4개 | 전체 | ~$2 | 대부분의 실무 프로젝트 |
| **full** | opus + sonnet + 멀티모델 | 6+개 | 전체 + 자동 | ~$5 | 고위험 프로덕션, 팀 사용 |

```bash
# 인터뷰에서 비용 질문 건너뛰기
/harness-setup --cost-tier balanced
```

---

## 지원 스택

**언어:** TypeScript, JavaScript, Python, Go, Rust, Java, Kotlin, Ruby, C#, Swift, Dart, Elixir

**프레임워크:** Next.js, Nuxt, Angular, Vite, Remix, Astro, SvelteKit, Express, NestJS, Hono, Django, Flask, FastAPI, Spring Boot, Ktor, Gin, Echo, Fiber, Vapor

**데이터베이스 & ORM:** Prisma, Drizzle, Knex, Sequelize, TypeORM, SQLAlchemy, Django ORM, Diesel, Ent, Mongoose

**배포:** Docker, Kubernetes, Vercel, Netlify, Fly.io, Railway, AWS SAM, CDK, Terraform, Heroku

---

## 생성되는 파일

```
.claude/
├── settings.json            # 전역 권한 차단 목록
├── settings.local.json      # 개인 허용 목록 (gitignore 대상)
├── hooks/hooks.json         # 라이프사이클 훅 (pre-commit, post-tool 등)
├── skills/                  # 스택에 맞는 도메인 스킬
├── agents/                  # 실행 프로필 에이전트 (backend, frontend 등)
├── scripts/                 # 훅 스크립트 (tsc-check, db-protection, whitelist)
├── docs/HARNESS-GUIDE.md    # 사용 가이드 (선호 언어에 맞춤)
└── harness-builder/
    ├── analysis.json        # 코드베이스 분석 스냅샷
    ├── interview.json       # 인터뷰 응답 기록
    ├── harness-lock.json    # 관리 파일 vs 사용자 파일 추적
    └── backups/             # 매 실행 전 타임스탬프 백업
```

---

## 커맨드

| 커맨드 | 설명 |
|--------|------|
| `/harness-setup` | 전체 설정: 분석, 인터뷰, 생성, 검증 |
| `/harness-update` | 코드베이스 재분석 후 관리 영역만 갱신 |
| `/harness-status` | 현재 하네스 버전, 티어, 관리 파일 목록 표시 |
| `/harness-uninstall` | 관리 파일만 정확히 제거 (lock 파일 기반, 잔여물 없음) |

### 옵션

| 옵션 | 적용 커맨드 | 설명 |
|------|------------|------|
| `--cost-tier <minimal\|balanced\|full>` | setup, update | 비용 질문 건너뛰고 지정 티어 사용 |
| `--dry-run` | setup, update, uninstall | 파일 변경 없이 미리보기 |
| `--force` | setup | 사용자 커스텀 섹션도 덮어쓰기 (주의 필요) |

---

## 공존성과 안전성

### 기존 설정과 함께 사용

harness-builder는 기존 `.claude/` 내용을 절대 덮어쓰지 않습니다:

1. **먼저 백업.** 쓰기 전에 `.claude/harness-builder/backups/`에 타임스탬프 사본을 저장합니다.
2. **추가형 병합.** JSON 파일(settings, hooks)은 깊은 병합 — 배열은 합집합, 커스텀 키는 보존합니다.
3. **섹션 마커.** CLAUDE.md 같은 텍스트 파일에서 관리 콘텐츠는 `<!-- harness-builder:start -->` / `<!-- harness-builder:end -->` 마커로 감싸집니다. 재실행 시 해당 섹션만 업데이트됩니다.
4. **Lock 파일.** `harness-lock.json`이 관리 파일과 섹션을 기록합니다. lock 파일 밖의 것은 절대 건드리지 않습니다.

### 다른 플러그인과 함께 사용

- **네임스페이스 접두사.** 생성된 모든 훅 ID는 `harness:`로 시작합니다 (예: `harness:pre-commit-tsc`). superpowers, ECC 등 다른 플러그인과 충돌하지 않습니다.
- **훅 태깅.** 각 훅 항목에 `"managed-by": "harness-builder"` 필드가 있어 식별과 선택적 제거가 쉽습니다.
- **에이전트 네이밍.** 생성된 에이전트는 `harness-<역할>` 규칙을 따르며 전역 설치된 에이전트를 덮어쓰지 않습니다.

### 깔끔한 삭제

```bash
/harness-uninstall
```

`harness-lock.json`을 읽고, 관리 파일과 섹션만 제거하며, 요청 시 설치 전 백업을 복원합니다. 설정 잔여물이 남지 않습니다.

---

## 출력 예시

<details>
<summary>생성된 CLAUDE.md 섹션 예시</summary>

```markdown
<!-- harness-builder:start version="0.1.0" tier="balanced" -->
## 스택 컨텍스트

**런타임:** Node.js 20, TypeScript strict
**프레임워크:** Next.js 15 App Router — Server Components 기본
**데이터베이스:** PostgreSQL via Prisma ORM (`DATABASE_URL` in `.env.local`)
**테스트:** Vitest (단위), Playwright (E2E) — 80% 커버리지 목표
**CI/CD:** GitHub Actions → Docker → ArgoCD (롤링 배포, 3-4분)

## 에이전트 라우팅

| 프로필 | 에이전트 | 용도 |
|--------|---------|------|
| backend | `harness-backend` | API 라우트, Prisma, 서버 로직 |
| frontend | `harness-frontend` | UI 컴포넌트, 대시보드 화면 |
| pipeline | `harness-pipeline` | 데이터 스크립트, 배치 작업 |

## 자동화 규칙

- 빌드 실패 → `build-error-resolver` (자동)
- TypeScript 에러 2회 → 에스컬레이션 (자동)
- 보안 파일 변경 → 백그라운드 리뷰 (자동)
<!-- harness-builder:end -->
```

</details>

<details>
<summary>생성된 에이전트 정의 예시</summary>

```json
{
  "name": "harness-backend",
  "managed-by": "harness-builder",
  "model": "claude-sonnet-4-5",
  "description": "이 프로젝트의 백엔드 실행 에이전트",
  "skills": [
    ".claude/skills/backend-patterns.md",
    ".claude/skills/prisma-patterns.md",
    ".claude/skills/api-design.md"
  ],
  "system_prompt_prefix": "이 프로젝트의 백엔드 개발자입니다. 스택: Next.js 15 API routes, Prisma + PostgreSQL. skills의 패턴을 따르세요. 코드 변경 후 반드시 `npx tsc --noEmit`을 실행하세요."
}
```

</details>

<details>
<summary>생성된 훅 예시</summary>

```json
{
  "id": "harness:pre-commit-tsc",
  "managed-by": "harness-builder",
  "event": "PreToolUse",
  "matcher": "Bash",
  "condition": "input contains 'git commit'",
  "command": "npx tsc --noEmit",
  "on_failure": "block",
  "description": "TypeScript 에러가 있을 때 커밋 차단"
}
```

</details>

---

## 설계 원칙

- **비용 인식.** 판단이 필요한 곳(설계, 아키텍처, 리뷰)에는 opus, 실행에는 sonnet. 비용 티어를 명시적으로 설정하므로 예기치 않은 요금이 발생하지 않습니다.
- **비파괴.** 매 쓰기 전 백업, 덮어쓰기 대신 병합, lock 파일로 소유권 추적. 언제든 롤백할 수 있어 점진적 도입이 안전합니다.
- **증거 기반.** 설정은 실제 파일 분석에서 도출됩니다 — import, lock 파일, CI 설정, 기존 `.claude/` — 스택을 자칭하는 것이 아니라 증거에 기반합니다.
- **점진적.** 선택한 티어에 맞는 필수 요소부터 시작합니다. 준비되면 `--cost-tier full`로 더 많은 자동화를 사용하세요. 복잡도는 opt-in이지 기본값이 아닙니다.
- **멱등성.** `/harness-setup`을 두 번 실행해도 같은 결과가 나옵니다. 스택 변경 후 `/harness-update`는 변경된 부분만 업데이트합니다. 예측 가능성이 인지 부하를 줄입니다.

---

## 문제 해결

<details>
<summary>"/harness-setup" 커맨드를 찾을 수 없음</summary>

플러그인이 설치되고 활성화되어 있는지 확인하세요:

```bash
claude plugin list
# 예상: harness-builder  active
```

없으면 재설치:

```bash
claude plugin install harness-builder
```

</details>

<details>
<summary>Phase 3 도중 생성이 실패함</summary>

이전 부분 실행이 불완전한 `harness-lock.json`을 남겼을 수 있습니다. `--dry-run`으로 무엇이 쓰여질지 확인한 다음 정상 실행하세요:

```bash
/harness-setup --dry-run
/harness-setup
```

백업은 항상 Phase 3 시작 전에 생성되므로 실패한 실행을 안전하게 재시도할 수 있습니다.

</details>

<details>
<summary>기존 CLAUDE.md가 예기치 않게 수정됨</summary>

harness-builder는 `<!-- harness-builder:start -->` / `<!-- harness-builder:end -->` 마커 사이에만 씁니다. 마커 밖에서 변경이 보이면 `--force`가 전달되었는지 확인하세요. 복원하려면 백업을 사용하세요:

```bash
ls .claude/harness-builder/backups/
cp .claude/harness-builder/backups/<timestamp>/CLAUDE.md .claude/CLAUDE.md
```

</details>

<details>
<summary>생성된 에이전트가 기존 에이전트 이름과 충돌</summary>

생성된 에이전트는 기본적으로 `harness-<역할>` 네이밍 규칙을 사용합니다. 이미 `harness-backend`라는 에이전트가 있으면, 설정 실행 전에 기존 에이전트의 이름을 변경하거나 `--force`로 덮어쓰세요.

</details>

<details>
<summary>TypeScript 훅이 매 커밋마다 실행되는데 프로젝트에 TypeScript가 없음</summary>

코드베이스 분석이 이를 감지했어야 합니다. `/harness-update`를 실행해서 재분석하세요. 문제가 계속되면 `.claude/hooks/hooks.json`에서 `harness:pre-commit-tsc` 항목을 제거하세요 — 관리 섹션 밖에서 수동 편집하는 것은 안전합니다.

</details>

---

## FAQ

**기존 `.claude/` 설정이 있어도 사용할 수 있나요?**
네. harness-builder는 기존 설정을 교체하지 않고 병합합니다. 관리 섹션 밖의 커스텀 설정은 절대 수정되지 않습니다.

**모노레포에서도 작동하나요?**
네. 레포 루트에서 `/harness-setup`을 실행하세요. 코드베이스 분석이 워크스페이스(npm/pnpm/yarn/Turborepo)를 감지하고 패키지별 스킬 참조를 생성합니다.

**영어 이외의 프로젝트도 지원하나요?**
인터뷰와 HARNESS-GUIDE.md 언어는 시스템 로캘이나 프로젝트 설정의 `language` 필드를 따릅니다. 한국어, 일본어, 중국어를 지원합니다.

**지원 목록에 없는 스택이면 어떻게 되나요?**
분석이 언어 수준 감지로 폴백합니다 (예: 인식된 프레임워크 없는 Go도 Go 전용 스킬과 훅을 받습니다). 설정 후 커스텀 스킬을 수동으로 추가할 수 있습니다.

**생성된 설정을 커밋해도 안전한가요?**
`settings.json`, `hooks/hooks.json`, `skills/`, `agents/`, `CLAUDE.md`는 모두 커밋을 권장합니다. `settings.local.json`과 `harness-builder/backups/`는 기본적으로 gitignore 대상입니다.

**새 의존성을 추가하거나 CI 파이프라인을 변경한 후에는?**
`/harness-update`를 실행하세요. 코드베이스 분석을 재실행하고 분석 데이터에서 파생된 섹션(스택 컨텍스트, 에이전트 스킬, 훅 트리거)만 갱신합니다. `--force`를 전달하지 않는 한 인터뷰 응답은 보존됩니다.

**superpowers나 ECC 플러그인과 충돌하나요?**
아닙니다. 생성된 모든 훅은 `harness:` 네임스페이스 아래에 있고 `"managed-by": "harness-builder"` 태그가 붙습니다. 에이전트 이름은 `harness-` 접두사를 사용합니다. superpowers나 ECC 모두 이 네임스페이스를 사용하지 않습니다.

**새 머신으로 옮기면 하네스는 어떻게 되나요?**
`.claude/`를 커밋하세요 (`settings.local.json`과 `backups/` 제외). 새 머신에서 커밋된 설정이 바로 작동합니다. 환경을 재분석하려면 `/harness-update`를 실행하세요.

---

## 기여 방법

1. 레포를 포크합니다.
2. 브랜치를 생성합니다: `git checkout -b feat/your-feature`.
3. 변경사항을 작성하고 테스트 스위트를 실행합니다 (상세 내용은 `CONTRIBUTING.md` 참조).
4. 변경 내용과 이유를 명확히 설명한 PR을 올립니다.

이슈와 기능 요청을 환영합니다. 중복 이슈를 열기 전에 기존 이슈를 먼저 검색해 주세요.

## 라이선스

MIT — 자세한 내용은 [LICENSE](./LICENSE)를 참조하세요.
