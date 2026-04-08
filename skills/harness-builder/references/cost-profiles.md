# Cost Tier Profiles

## Overview

Each tier defines: model assignments, agent count, hook coverage, and parallel task limits. Users select a tier during interview (Q2) or via `--cost-tier` argument.

---

## Minimal Tier (~$0.5/hr)

**Philosophy**: Maximum cost efficiency. Single model, minimal automation.

### Model Assignment
| Role | Model |
|------|-------|
| Main session | sonnet |
| All agents | sonnet |
| Code review | sonnet (manual trigger only) |

### Agent Profiles (2)
1. **backend-developer** — API, DB, server logic
2. **frontend-developer** OR **fullstack-developer** — UI, components (choose based on stack)

### Hooks
- **Stop**: tsc-check (TypeScript only)
- No PreToolUse hooks
- No PostToolUse hooks
- No session tracking

### Automation Tiers
- **T1 only**: Build error → manual fix (no auto-resolver)
- No T2 context-based triggers
- No T3 multi-agent

### Parallel Tasks
- Never spawn parallel agents
- Sequential execution only

### settings.json Hooks
```json
{ "hooks": { "Stop": [{ "hooks": [{ "type": "command", "command": "bash .claude/scripts/tsc-check.sh" }] }] } }
```

### CLAUDE.md Model Policy Section
```markdown
## Model Policy
- All agents use sonnet for maximum cost efficiency
- No parallel agent spawning — tasks execute sequentially
- Manual code review only (not auto-triggered)
```

---

## Balanced Tier (~$2/hr) [Default]

**Philosophy**: Cost-effective quality. Opus for design decisions, sonnet for execution.

### Model Assignment
| Role | Model |
|------|-------|
| Main session | opus |
| Execution agents | sonnet |
| Code review | sonnet (context-triggered) |
| Architecture review | opus (rare, manual) |

### Agent Profiles (4)
1. **backend-developer** (sonnet) — API, DB, server logic
2. **frontend-developer** (sonnet) — UI, components
3. **code-reviewer** (sonnet) — Code quality, logic defects
4. **database-admin** (sonnet) — Schema, queries, migrations (if DB detected)

### Hooks
- **UserPromptSubmit**: Session start tracking (if automation >= moderate)
- **PreToolUse**: Database protection (if DB detected)
- **Stop**: tsc-check (TypeScript), build resolution

### Automation Tiers
- **T1**: Build fails → auto tsc-check on Stop
- **T2**: Complex task → spawn planner agent; bug fix → TDD approach
- No T3 multi-agent orchestration

### Parallel Tasks
- Up to 2 parallel sonnet agents for independent tasks
- Main session (opus) orchestrates

### CLAUDE.md Model Policy Section
```markdown
## Model Policy
- **Main session**: opus (design, orchestration, review decisions)
- **Execution agents**: sonnet (implementation, fixes, standard reviews)
- Run up to 2 independent tasks in parallel when each takes >30s
- Verify before claiming completion — evidence over assertion
```

---

## Full Tier (~$5/hr)

**Philosophy**: Maximum quality and coverage. Multi-model with cross-verification.

### Model Assignment
| Role | Model |
|------|-------|
| Main session | opus |
| Execution agents | sonnet |
| Architecture review | opus agent |
| Security review | sonnet agent |
| Cross-model verification | codex (GPT-5.4) if available |

### Agent Profiles (6+)
1. **backend-developer** (sonnet) — API, DB, server logic
2. **frontend-developer** (sonnet) — UI, components
3. **code-reviewer** (sonnet) — Code quality
4. **database-admin** (sonnet) — Schema, queries
5. **architect** (opus) — System design, architectural decisions
6. **security-reviewer** (sonnet) — OWASP, secrets, auth
7. (Optional) **uxui-reviewer** (sonnet) — If frontend detected

### Hooks
- **UserPromptSubmit**: Session tracking, skill activation
- **PreToolUse**: Database protection, destructive op blocking
- **PostToolUse**: Tracking updates, PR notifications
- **Stop**: tsc-check, build resolution, session end tracking

### Automation Tiers
- **T1**: Build fails → auto-resolver agent
- **T1.5**: tsc 2x fail → escalation; security file change → background review
- **T2**: Complex → planner; bug → TDD; refactor → architect; DB → database-reviewer
- **T3**: Manual multi-agent orchestration available

### Parallel Tasks
- Up to 4 parallel sonnet agents
- Opus main orchestrates
- Cross-model verification when available

### CLAUDE.md Model Policy Section
```markdown
## Model Policy
- **Main session**: opus (design, orchestration, review decisions)
- **Execution agents**: sonnet (implementation, fixes, standard reviews)
- **Architecture review**: opus agent (for complex design decisions)
- **Security review**: sonnet agent (OWASP, secrets, auth)
- Run up to 4 independent tasks in parallel
- Cross-model verification for critical changes
```

---

## Tier Comparison Matrix

| Feature | Minimal | Balanced | Full |
|---------|---------|----------|------|
| Main model | sonnet | opus | opus |
| Agent models | sonnet | sonnet | sonnet + opus |
| Agent count | 2 | 4 | 6+ |
| Parallel agents | 0 | 2 | 4 |
| Hook coverage | Stop only | Stop + PreToolUse | Full lifecycle |
| Auto-resolver | No | Stop hook only | Build + tsc |
| Code review | Manual | Context-triggered | Auto-triggered |
| Security review | None | None | Available |
| Architecture review | None | Manual (rare) | Available |
| Session tracking | None | Basic | Full |
| Estimated cost/hr | ~$0.5 | ~$2 | ~$5 |
