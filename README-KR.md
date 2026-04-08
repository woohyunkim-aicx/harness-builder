# harness-builder

프로젝트에 맞는 Claude Code 하네스를 자동으로 구성해주는 플러그인입니다.

코드베이스를 분석하고, 선호도를 인터뷰한 뒤, 기술 스택과 워크플로우에 최적화된 스킬, 에이전트, 훅, 보안 규칙을 생성합니다.

## 빠른 시작

```bash
# GitHub에서 설치
claude plugin marketplace add woohyunkim/harness-builder
claude plugin install harness-builder

# 설정 실행
/harness-setup
```

## 동작 방식

```
/harness-setup
│
├── Phase 1: 코드베이스 분석
│   탐지: 언어, 프레임워크, DB, 테스트, 배포, CI/CD
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
    생성: .claude/docs/HARNESS-GUIDE.md (한국어)
```

## 비용 티어

| 티어 | 모델 | 에이전트 | 훅 | 예상 비용/hr |
|------|------|---------|-----|-------------|
| **최소** | sonnet only | 2개 | 기본 | ~$0.5 |
| **균형** | opus + sonnet | 4개 | 전체 | ~$2 |
| **풀** | opus + sonnet + 멀티모델 | 6+개 | 전체 + 자동 | ~$5 |

```bash
# 비용 질문 건너뛰기
/harness-setup --cost-tier balanced
```

## 지원 스택

### 언어
TypeScript, JavaScript, Python, Go, Rust, Java, Kotlin, Ruby, C#, Swift, Dart, Elixir

### 프레임워크
Next.js, Nuxt, Angular, Vite, Remix, Astro, SvelteKit, Express, NestJS, Hono, Django, Flask, FastAPI, Spring Boot, Ktor, Gin, Echo, Fiber, Vapor

### 데이터베이스 & ORM
Prisma, Drizzle, Knex, Sequelize, TypeORM, SQLAlchemy, Django ORM, Diesel, Ent, Mongoose

### 배포
Docker, Kubernetes, Vercel, Netlify, Fly.io, Railway, AWS SAM, CDK, Terraform, Heroku

## 생성되는 파일

```
.claude/
├── settings.json          # 권한 차단 목록
├── settings.local.json    # 개인 허용 목록 (gitignore 대상)
├── hooks/hooks.json       # 라이프사이클 훅
├── skills/                # 프로젝트별 도메인 스킬
├── agents/                # 실행 프로필 에이전트
├── scripts/               # 훅 스크립트
├── docs/HARNESS-GUIDE.md  # 한국어 사용 가이드
└── harness-builder/
    ├── analysis.json      # 코드베이스 분석 결과
    ├── interview.json     # 유저 선호도
    ├── harness-lock.json  # 관리 파일 추적
    └── backups/           # 생성 전 백업
```

## 커맨드

| 커맨드 | 설명 |
|--------|------|
| `/harness-setup` | 전체 설정 (최초) |
| `/harness-update` | 관리 영역만 업데이트 |
| `/harness-status` | 현재 구성 확인 |

## 병합 동작

이 플러그인은 **비파괴적**입니다:

1. 변경 전 기존 `.claude/`를 **백업**
2. JSON 파일은 **깊은 병합** (배열은 합집합, 커스텀 키 보존)
3. CLAUDE.md에서 **섹션 마커**로 관리 영역만 업데이트
4. **harness-lock.json**으로 관리/사용자 파일 구분
5. **재실행 안전** — 관리 영역만 갱신

## 설계 원칙

- **비용 인식** — 작업별 적합한 모델 선택 (설계=opus, 실행=sonnet)
- **비파괴** — 항상 백업, 항상 병합, 사용자 파일 보존
- **증거 기반** — 코드베이스에서 실제 패턴 추출 (보일러플레이트 아님)
- **점진적** — 필수 요소부터 시작, 선호도에 따라 복잡도 추가
- **멱등성** — 재실행 안전, 동일 입력이면 동일 결과

## 요구사항

- Claude Code CLI
- Git 레포지토리 (권장)

## 라이선스

MIT
