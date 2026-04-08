---
name: harness-builder
description: "Auto-configure a production-grade Claude Code harness for any project. ALWAYS trigger when user mentions: harness setup, configure claude code, project setup, claude configuration, onboarding, or asks how to set up their development environment with Claude Code."
version: "0.1.0"
user-invocable: false
---

# Harness Builder

Automatically configures a fully customized Claude Code harness by analyzing your codebase, interviewing you about preferences, and generating optimized configuration files.

## What It Does

The harness builder creates a complete `.claude/` directory with:

- **settings.json** — Permission deny-lists and lifecycle hooks
- **hooks/** — Database protection, TypeScript checks, session tracking
- **skills/** — Project-specific domain skills extracted from your codebase
- **agents/** — Execution profile agents matched to your tech stack
- **CLAUDE.md** — Agent routing table, model policy, automation tiers
- **scripts/** — Hook scripts for automation
- **docs/HARNESS-GUIDE.md** — Korean usage guide

## Pipeline

```
Phase 1: Codebase Analysis    → analysis.json
Phase 2: User Interview       → interview.json  
Phase 3: Config Generation    → .claude/* files
Phase 4: Verification + Guide → validation report
```

## How to Use

Run `/harness-setup` to start the full pipeline.

### Options
- `/harness-setup` — Full setup from scratch
- `/harness-setup --cost-tier minimal` — Skip cost question, use minimal tier
- `/harness-setup --cost-tier balanced` — Skip cost question, use balanced tier  
- `/harness-setup --cost-tier full` — Skip cost question, use full tier

### After Setup
- `/harness-update` — Re-analyze and update managed sections only
- `/harness-status` — View current harness configuration summary
- `/harness-guide` — Regenerate Korean usage guide

## Cost Tiers

| Tier | Model Config | Agents | Hooks | ~Cost/hr |
|------|-------------|--------|-------|----------|
| **minimal** | sonnet only | 2 profiles | basic security | ~$0.5 |
| **balanced** | opus main + sonnet agents | 4 profiles + reviewers | full lifecycle | ~$2 |
| **full** | opus + sonnet + multi-model | 6+ profiles + architect | full + auto-resolve | ~$5 |

## Supported Stacks

### Languages
TypeScript/JavaScript, Python, Go, Rust, Java/Kotlin, Ruby, C#, Swift

### Frameworks
Next.js, Nuxt, Angular, Vite, Remix, Astro, Django, Flask, FastAPI, Spring Boot, Vapor

### Databases
Prisma, Drizzle, Knex, Sequelize, TypeORM, SQLAlchemy, Django ORM, Diesel, Ent

### Deployment
Docker, Kubernetes, Vercel, Netlify, Fly.io, Railway, AWS SAM, CDK, Terraform

## Merge Behavior

When a harness already exists:
1. **Backs up** existing `.claude/` before any changes
2. **Deep merges** JSON files (union arrays, preserve custom keys)
3. **Section markers** in CLAUDE.md allow surgical updates to managed blocks only
4. **harness-lock.json** tracks which files/sections are managed vs user-customized
5. **User files are never overwritten** — only harness-managed files are updated

## Design Principles

1. **Cost-aware** — Choose the right model for each task (opus for design, sonnet for execution)
2. **Non-destructive** — Always backup, always merge, never overwrite user customizations
3. **Evidence-based** — Extract real patterns from the codebase, not generic boilerplate
4. **Progressive** — Start with essentials, add complexity based on user preferences
5. **Idempotent** — Safe to re-run; produces same results for same inputs
