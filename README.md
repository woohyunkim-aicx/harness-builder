# harness-builder

[English](./README.md) | [한국어](./README-KR.md)

Auto-configure a production-grade Claude Code harness for any project in under 4 minutes.

![Version](https://img.shields.io/badge/version-0.1.0-blue) ![License](https://img.shields.io/badge/license-MIT-green) ![Stars](https://img.shields.io/github/stars/woohyunkim-aicx/harness-builder?style=social)

Analyzes your codebase, runs an adaptive interview, and generates optimized skills, agents, hooks, and security rules — tailored to your actual tech stack and workflow, not generic templates.

---

## Why harness-builder?

- **Hours → 4 minutes.** Setting up `.claude/` from scratch takes most developers half a day. harness-builder does it in one command.
- **Evidence-based, not generic.** It reads your actual code — imports, config files, CI pipelines — before generating anything. Output reflects your project, not a template.
- **Non-destructive by design.** Every run backs up existing files. Section markers and a lock file allow surgical updates without touching your customizations.
- **Cost-aware from the start.** Uses opus only where judgment matters (design, architecture); sonnet for execution. Configurable via `--cost-tier`.
- **Beginner-friendly interview.** The 6-round adaptive interview (15–24 questions) adjusts depth to your experience level. Novices get guardrails; power users get full control.

---

## Table of Contents

- [Quick Start](#quick-start)
- [How It Works](#how-it-works)
- [Deep Interview System](#deep-interview-system)
- [Cost Tiers](#cost-tiers)
- [Supported Stacks](#supported-stacks)
- [Generated Files](#generated-files)
- [Commands](#commands)
- [Coexistence and Safety](#coexistence-and-safety)
- [Example Output](#example-output)
- [Design Principles](#design-principles)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)
- [Contributing](#contributing)
- [License](#license)

---

## Quick Start

```bash
# 1. Add from marketplace
claude plugin marketplace add woohyunkim/harness-builder

# 2. Install
claude plugin install harness-builder

# 3. Run setup
/harness-setup
```

**Verify installation:**

```bash
/harness-status
# Expected: "harness-builder v0.1.0 — active"
```

---

## How It Works

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
└── Phase 4: Verification and Guide
    Validates: JSON, permissions, frontmatter, secrets
    Generates: .claude/docs/HARNESS-GUIDE.md
```

### Manual vs Automated — Time Comparison

| Task | Manual | harness-builder |
|------|--------|-----------------|
| Write CLAUDE.md from scratch | 45–90 min | included in setup |
| Configure hooks.json | 30–60 min | included in setup |
| Define agent profiles | 60–120 min | included in setup |
| Write domain skills | 60–90 min | included in setup |
| Set security deny-lists | 20–30 min | included in setup |
| Re-sync after stack change | 30–60 min | `/harness-update` (~1 min) |
| **Total** | **4–7 hours** | **~4 minutes** |

---

## Deep Interview System

harness-builder does not ask generic questions. The interview runs in 6 rounds with 15–24 questions total, adapting based on your answers.

| Round | Topic | Example Questions |
|-------|-------|-------------------|
| 1 | Project context | Phase (PoC / growth / stable), team size, deadline pressure |
| 2 | Cost and model policy | Budget per hour, when to use opus vs sonnet |
| 3 | Automation preferences | What to auto-trigger vs require explicit approval |
| 4 | Git and review workflow | Branch strategy, PR review requirements, commit style |
| 5 | Testing philosophy | Coverage targets, TDD preference, E2E tooling |
| 6 | Security posture | Data sensitivity, secret management, audit requirements |

**Adaptive depth:** If you answer "I'm new to Claude Code" in round 1, rounds 2–6 default to safe, recommended values and skip advanced options. If you indicate experience, every option is surfaced.

Each answer directly maps to one or more generated configuration values. Nothing is inferred from templates — all output is derived from your interview responses and codebase analysis.

---

## Cost Tiers

| Tier | Models | Agents | Hooks | ~Cost/hr | Best For |
|------|--------|--------|-------|----------|----------|
| **minimal** | sonnet only | 2 | basic | ~$0.5 | Side projects, learning, tight budgets |
| **balanced** | opus + sonnet | 4 | full | ~$2 | Most professional projects |
| **full** | opus + sonnet + multi-model | 6+ | full + auto | ~$5 | High-stakes production, team use |

```bash
# Skip the cost question during interview
/harness-setup --cost-tier balanced
```

---

## Supported Stacks

**Languages:** TypeScript, JavaScript, Python, Go, Rust, Java, Kotlin, Ruby, C#, Swift, Dart, Elixir

**Frameworks:** Next.js, Nuxt, Angular, Vite, Remix, Astro, SvelteKit, Express, NestJS, Hono, Django, Flask, FastAPI, Spring Boot, Ktor, Gin, Echo, Fiber, Vapor

**Databases and ORMs:** Prisma, Drizzle, Knex, Sequelize, TypeORM, SQLAlchemy, Django ORM, Diesel, Ent, Mongoose

**Deployment:** Docker, Kubernetes, Vercel, Netlify, Fly.io, Railway, AWS SAM, CDK, Terraform, Heroku

---

## Generated Files

```
.claude/
├── settings.json            # Global permission deny-lists
├── settings.local.json      # Personal allow-lists (gitignored)
├── hooks/hooks.json         # Lifecycle hooks (pre-commit, post-tool, etc.)
├── skills/                  # Domain skills scoped to your stack
├── agents/                  # Execution profile agents (backend, frontend, etc.)
├── scripts/                 # Hook scripts (tsc-check, db-protection, whitelist)
├── docs/HARNESS-GUIDE.md    # Usage guide (language matches your preference)
└── harness-builder/
    ├── analysis.json        # Codebase analysis snapshot
    ├── interview.json       # Recorded interview answers
    ├── harness-lock.json    # Tracks managed vs user-owned files
    └── backups/             # Timestamped backups taken before each run
```

---

## Commands

| Command | Description |
|---------|-------------|
| `/harness-setup` | Full setup: analyze, interview, generate, verify |
| `/harness-update` | Re-analyze codebase and refresh managed sections only |
| `/harness-status` | Show current harness version, tier, and managed file list |
| `/harness-uninstall` | Remove all managed files (lock-file driven, no leftovers) |

### Options

| Option | Commands | Description |
|--------|----------|-------------|
| `--cost-tier <minimal\|balanced\|full>` | setup, update | Skip cost question, use specified tier |
| `--dry-run` | setup, update, uninstall | Preview changes without writing files |
| `--force` | setup | Overwrite even user-customized sections (use with caution) |

---

## Coexistence and Safety

### Working with existing configs

harness-builder never clobbers existing `.claude/` content:

1. **Backup first.** A timestamped copy of `.claude/` is saved to `.claude/harness-builder/backups/` before any write.
2. **Additive merge.** JSON files (settings, hooks) are deep-merged — arrays are unioned, custom keys are preserved.
3. **Section markers.** In text files like `CLAUDE.md`, managed content is wrapped in `<!-- harness-builder:start -->` / `<!-- harness-builder:end -->` markers. Only those sections are updated on re-run.
4. **Lock file.** `harness-lock.json` records which files and sections are managed. Anything outside the lock file is never touched.

### Working with other plugins

- **Namespace prefix.** All generated hook IDs are prefixed with `harness:` (e.g., `harness:pre-commit-tsc`). No collision with superpowers, ECC, or other plugins.
- **Hook tagging.** Each hook entry carries a `"managed-by": "harness-builder"` field, making it easy to identify and selectively remove.
- **Agent naming.** Generated agents follow the `harness-<role>` convention and do not overwrite globally installed agents.

### Clean uninstall

```bash
/harness-uninstall
```

Reads `harness-lock.json`, removes only managed files and sections, and restores the pre-install backup if requested. No orphaned config fragments.

---

## Example Output

<details>
<summary>Sample generated CLAUDE.md section</summary>

```markdown
<!-- harness-builder:start version="0.1.0" tier="balanced" -->
## Stack Context

**Runtime:** Node.js 20, TypeScript strict
**Framework:** Next.js 15 App Router — Server Components by default
**Database:** PostgreSQL via Prisma ORM (`DATABASE_URL` in `.env.local`)
**Testing:** Vitest (unit), Playwright (E2E) — 80% coverage target
**CI/CD:** GitHub Actions → Docker → ArgoCD (rolling deploy, 3–4 min)

## Agent Routing

| Profile | Agent | Use For |
|---------|-------|---------|
| backend | `harness-backend` | API routes, Prisma, server logic |
| frontend | `harness-frontend` | UI components, dashboard screens |
| pipeline | `harness-pipeline` | Data scripts, batch jobs |

## Automation Rules

- Build fails → `build-error-resolver` (auto)
- TypeScript errors 2x → escalate (auto)
- Security file changed → background review (auto)
<!-- harness-builder:end -->
```

</details>

<details>
<summary>Sample generated agent definition</summary>

```json
{
  "name": "harness-backend",
  "managed-by": "harness-builder",
  "model": "claude-sonnet-4-5",
  "description": "Backend execution agent for this project",
  "skills": [
    ".claude/skills/backend-patterns.md",
    ".claude/skills/prisma-patterns.md",
    ".claude/skills/api-design.md"
  ],
  "system_prompt_prefix": "You are a backend developer on this project. Stack: Next.js 15 API routes, Prisma + PostgreSQL. Follow patterns in skills. Run `npx tsc --noEmit` after every code change."
}
```

</details>

<details>
<summary>Sample generated hook</summary>

```json
{
  "id": "harness:pre-commit-tsc",
  "managed-by": "harness-builder",
  "event": "PreToolUse",
  "matcher": "Bash",
  "condition": "input contains 'git commit'",
  "command": "npx tsc --noEmit",
  "on_failure": "block",
  "description": "Block commits when TypeScript errors exist"
}
```

</details>

---

## Design Principles

- **Cost-aware.** Opus for judgment (design, architecture, review); sonnet for execution. Cost tier is explicit, not hidden. This prevents surprise bills and lets you control the trade-off.
- **Non-destructive.** Backup before every write, merge never overwrite, lock file tracks ownership. You can always roll back. This makes harness-builder safe to adopt incrementally.
- **Evidence-based.** Configuration derives from actual file analysis — imports, lock files, CI config, existing `.claude/` — not from what you claim your stack is. Accuracy requires evidence, not trust.
- **Progressive.** Start with the essentials for your tier. Use `--cost-tier full` when you're ready for more automation. Complexity is opt-in, not default-on.
- **Idempotent.** Running `/harness-setup` twice produces the same output. Running `/harness-update` after a stack change updates only what changed. Predictability reduces cognitive overhead.

---

## Troubleshooting

<details>
<summary>"/harness-setup" command not found</summary>

Verify the plugin is installed and active:

```bash
claude plugin list
# Should show: harness-builder  active
```

If missing, reinstall:

```bash
claude plugin install harness-builder
```

</details>

<details>
<summary>Generation fails partway through Phase 3</summary>

Check whether a previous partial run left an incomplete `harness-lock.json`. Run with `--dry-run` to inspect what would be written, then re-run normally:

```bash
/harness-setup --dry-run
/harness-setup
```

Backups are always created before Phase 3 starts, so a failed run can be safely retried.

</details>

<details>
<summary>My existing CLAUDE.md was modified unexpectedly</summary>

harness-builder only writes between `<!-- harness-builder:start -->` and `<!-- harness-builder:end -->` markers. If you see changes outside those markers, check whether `--force` was passed. To restore, use the backup:

```bash
ls .claude/harness-builder/backups/
cp .claude/harness-builder/backups/<timestamp>/CLAUDE.md .claude/CLAUDE.md
```

</details>

<details>
<summary>Generated agents conflict with my existing agent names</summary>

Generated agents use the `harness-<role>` naming convention by default. If you have an existing agent named `harness-backend`, rename your existing agent before running setup, or use `--force` to overwrite it.

</details>

<details>
<summary>TypeScript hook fires on every commit but the project has no TypeScript</summary>

The codebase analysis should have detected this. Run `/harness-update` to re-analyze. If the issue persists, remove the `harness:pre-commit-tsc` entry from `.claude/hooks/hooks.json` — it is safe to edit manually outside the managed sections.

</details>

---

## FAQ

**Does this work with an existing `.claude/` setup?**
Yes. harness-builder merges with existing config rather than replacing it. Your customizations outside the managed sections are never modified.

**Can I use this on a monorepo?**
Yes. Run `/harness-setup` from the repo root. The codebase analysis detects workspaces (npm/pnpm/yarn/Turborepo) and generates per-package skill references where relevant.

**Does it support non-English projects?**
The interview and HARNESS-GUIDE.md language follow your system locale or a detected `language` field in your project config. Korean, Japanese, and Chinese are supported.

**What if my stack is not on the supported list?**
The analysis falls back to language-level detection (e.g., Go without a recognized framework still gets Go-specific skills and hooks). You can manually add custom skills after setup.

**Is the generated config safe to commit?**
`settings.json`, `hooks/hooks.json`, `skills/`, `agents/`, and `CLAUDE.md` are all safe and recommended to commit. `settings.local.json` and `harness-builder/backups/` are gitignored by default.

**How do I update after adding a new dependency or changing my CI pipeline?**
Run `/harness-update`. It re-runs codebase analysis and refreshes only the sections that derive from analyzed data (stack context, agent skills, hook triggers). Your interview answers are preserved unless you pass `--force`.

**Will this conflict with superpowers or ECC plugins?**
No. All generated hooks are namespaced under `harness:` and tagged with `"managed-by": "harness-builder"`. Agent names use the `harness-` prefix. Neither superpowers nor ECC use these namespaces.

**What happens to my harness if I switch to a new machine?**
Commit `.claude/` (excluding `settings.local.json` and `backups/`). On a new machine, the committed config works immediately. Run `/harness-update` if you want to re-analyze the environment.

---

## Contributing

1. Fork the repository.
2. Create a branch: `git checkout -b feat/your-feature`.
3. Make changes and run the test suite (details in `CONTRIBUTING.md`).
4. Open a pull request with a clear description of what changed and why.

Issues and feature requests are welcome. Please search existing issues before opening a duplicate.

## License

MIT — see [LICENSE](./LICENSE) for details.
