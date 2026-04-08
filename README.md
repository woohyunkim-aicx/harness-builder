# harness-builder

Auto-configure a production-grade Claude Code harness for any project.

[한국어](https://github.com/woohyunkim-aicx/harness-builder/blob/main/README-KR.md) 

Analyzes your codebase, interviews you about preferences, and generates optimized skills, agents, hooks, and security rules — tailored to your tech stack and workflow.

## Quick Start

```bash
# Install from GitHub
claude plugin marketplace add woohyunkim/harness-builder
claude plugin install harness-builder

# Run setup
/harness-setup
```

## What It Does

```
/harness-setup
│
├── Phase 1: Codebase Analysis
│   Detects: language, framework, database, testing,
│   deployment, CI/CD, package manager, existing config
│   Output: .claude/harness-builder/analysis.json
│
├── Phase 2: User Interview
│   Asks about: project phase, cost tier, automation level,
│   git workflow, testing philosophy, security needs
│   Output: .claude/harness-builder/interview.json
│
├── Phase 3: Configuration Generation
│   Generates: settings.json, hooks, skills, agents,
│   CLAUDE.md, scripts, security rules
│   Output: .claude/* (full harness)
│
└── Phase 4: Verification & Guide
    Validates: JSON, permissions, frontmatter, secrets
    Generates: .claude/docs/HARNESS-GUIDE.md (Korean)
```

## Cost Tiers

| Tier | Models | Agents | Hooks | ~Cost/hr |
|------|--------|--------|-------|----------|
| **minimal** | sonnet only | 2 | basic | ~$0.5 |
| **balanced** | opus + sonnet | 4 | full | ~$2 |
| **full** | opus + sonnet + multi-model | 6+ | full + auto | ~$5 |

```bash
# Skip the cost question
/harness-setup --cost-tier balanced
```

## Supported Stacks

### Languages
TypeScript, JavaScript, Python, Go, Rust, Java, Kotlin, Ruby, C#, Swift, Dart, Elixir

### Frameworks
Next.js, Nuxt, Angular, Vite, Remix, Astro, SvelteKit, Express, NestJS, Hono, Django, Flask, FastAPI, Spring Boot, Ktor, Gin, Echo, Fiber, Vapor

### Databases & ORMs
Prisma, Drizzle, Knex, Sequelize, TypeORM, SQLAlchemy, Django ORM, Diesel, Ent, Mongoose

### Deployment
Docker, Kubernetes, Vercel, Netlify, Fly.io, Railway, AWS SAM, CDK, Terraform, Heroku

## Generated Files

```
.claude/
├── settings.json          # Permission deny-lists
├── settings.local.json    # Personal allow-lists (gitignored)
├── hooks/hooks.json       # Lifecycle hooks
├── skills/                # Project-specific domain skills
├── agents/                # Execution profile agents
├── scripts/               # Hook scripts (tsc-check, db-protection)
├── docs/HARNESS-GUIDE.md  # Korean usage guide
└── harness-builder/
    ├── analysis.json      # Codebase analysis results
    ├── interview.json     # User preferences
    ├── harness-lock.json  # Managed file tracker
    └── backups/           # Pre-generation backups
```

## Commands

| Command | Description |
|---------|-------------|
| `/harness-setup` | Full setup from scratch |
| `/harness-update` | Re-analyze and update managed sections |
| `/harness-status` | View current harness summary |

## Merge Behavior

The plugin is **non-destructive**:

1. **Backs up** existing `.claude/` before changes
2. **Deep merges** JSON files (union arrays, preserve custom keys)
3. **Section markers** in CLAUDE.md enable surgical updates
4. **harness-lock.json** tracks managed vs user-customized files
5. **Re-running is safe** — only managed sections are updated

## Design Principles

- **Cost-aware** — Right model for each task (opus for design, sonnet for execution)
- **Non-destructive** — Always backup, always merge, never overwrite user files
- **Evidence-based** — Extract real patterns from your codebase, not generic boilerplate
- **Progressive** — Start with essentials, add complexity based on preferences
- **Idempotent** — Safe to re-run; produces same results for same inputs

## Requirements

- Claude Code CLI
- Git repository (recommended)

## License

MIT
