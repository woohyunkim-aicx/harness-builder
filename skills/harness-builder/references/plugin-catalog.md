# Plugin Compatibility Catalog

## Tier 1: Essential (auto-selected based on stack)

| Plugin | Marketplace | Stack | Category | Tokens/session | Description |
|--------|-------------|-------|----------|---------------|-------------|
| hookify | claude-plugins-official | all | safety | ~200 | Create hooks to prevent unwanted behaviors |
| typescript-lsp | claude-plugins-official | typescript | lsp | ~100 | TypeScript language server integration |
| pyright-lsp | claude-plugins-official | python | lsp | ~100 | Python type checking |

## Tier 2: Recommended (score > 0.7)

| Plugin | Marketplace | Stack | Category | Tokens/session | Description |
|--------|-------------|-------|----------|---------------|-------------|
| superpowers | obra/superpowers | all | workflow | ~500 | Planning, brainstorming, TDD, debugging, verification workflows |
| claude-mem | thedotmack/claude-mem | all | memory | ~300 | Persistent cross-session memory and knowledge graph |
| code-review | claude-plugins-official | all | review | ~200 | Code review for PRs and local changes |
| commit-commands | claude-plugins-official | git | workflow | ~100 | Git commit, push, PR automation |
| skill-creator | claude-plugins-official | all | meta | ~200 | Create, test, and optimize custom skills |

## Tier 3: Optional (score 0.4-0.7)

| Plugin | Marketplace | Stack | Category | Tokens/session | Description |
|--------|-------------|-------|----------|---------------|-------------|
| claude-hud | jarrodwatts/claude-hud | all | monitoring | ~100 | Real-time statusline HUD |
| pr-review-toolkit | claude-plugins-official | git | review | ~300 | Comprehensive PR review with specialized agents |
| feature-dev | claude-plugins-official | all | development | ~300 | Guided feature development with code exploration |
| frontend-design | claude-plugins-official | frontend | design | ~400 | Production-grade frontend interface creation |
| GSD | gsd-framework | all | project-mgmt | ~500 | Phase-based project management with roadmaps |

## Tier 4: Specialized (manual selection)

| Plugin | Marketplace | Stack | Category | Tokens/session | Description |
|--------|-------------|-------|----------|---------------|-------------|
| everything-claude-code | ecc.tools | all | comprehensive | ~1000 | 38 agents, 156 skills — selective module install |
| claude-night-market | athola/claude-night-market | all | collection | ~500 | 23 plugins for various workflows |
| dev-browser | claude-plugins-official | web | testing | ~200 | Browser automation for web testing |
| atlassian | marketplace | all | integration | ~200 | Jira/Confluence integration |

## Scoring Formula

```
score = (stack_match × 0.4) + (workflow_match × 0.3) + (popularity × 0.1) + (cost_fit × 0.2)
```

### stack_match (0-1)
- 1.0: Plugin explicitly targets detected stack
- 0.7: Plugin targets detected language family
- 0.5: Plugin is stack-agnostic ("all")
- 0.0: Plugin targets different stack

### workflow_match (0-1)
- 1.0: Plugin matches declared workflow (e.g., TDD → superpowers)
- 0.5: Plugin is generally useful
- 0.0: Plugin conflicts with declared workflow

### popularity (0-1)
- Normalized by: stars / max_stars_in_category

### cost_fit (0-1)
- minimal tier: penalize high token/session plugins (>300 tokens → 0.3)
- balanced tier: no penalty
- full tier: bonus for comprehensive plugins

## Conflict Matrix

| Plugin A | Plugin B | Conflict Type |
|----------|----------|--------------|
| code-review | pr-review-toolkit | Overlapping — choose one |
| superpowers | GSD | Complementary — can coexist |
| everything-claude-code | most others | ECC includes many features — check overlap |
| typescript-lsp | pyright-lsp | Language-exclusive — pick by stack |

## Stack → Plugin Mapping

### TypeScript/Next.js Project
- Essential: hookify, typescript-lsp
- Recommended: superpowers, claude-mem, commit-commands, code-review
- Optional: claude-hud, frontend-design, pr-review-toolkit

### Python/Django Project
- Essential: hookify, pyright-lsp
- Recommended: superpowers, claude-mem, commit-commands, code-review
- Optional: claude-hud, GSD

### Go Project
- Essential: hookify
- Recommended: superpowers, claude-mem, commit-commands
- Optional: code-review, claude-hud

### Rust Project
- Essential: hookify
- Recommended: superpowers, claude-mem, commit-commands
- Optional: code-review

### Full-Stack (Frontend + Backend + DB)
- Essential: hookify, typescript-lsp (if TS)
- Recommended: superpowers, claude-mem, commit-commands, code-review, skill-creator
- Optional: claude-hud, frontend-design, feature-dev, GSD
