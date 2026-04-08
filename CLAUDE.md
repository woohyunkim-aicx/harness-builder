# harness-builder — Project Configuration

## INSTRUCTIONS

1. **Language:** English for code/docs. Korean for user-facing guide output (HARNESS-GUIDE.md).
2. **Architecture:** Claude Code plugin format — `.claude-plugin/plugin.json`, agents/*.md, skills/*/SKILL.md, commands/*.md
3. **No runtime dependencies.** Pure markdown + bash + JSON. No npm install, no build step.

## CONTEXT

**What this is:** A Claude Code plugin that auto-configures a production-grade harness for any project. Analyzes codebase, interviews user, generates optimized .claude/ directory.

**Stack:** Markdown (skills, agents, commands), JSON (plugin.json, templates), Bash (scripts)

**Phase:** v0.1.0 initial release — functional but not yet tested end-to-end on diverse projects.

## Plugin Structure

```
harness-builder/
├── .claude-plugin/
│   ├── plugin.json              # Plugin manifest
│   └── marketplace.json         # Marketplace listing
├── commands/                    # 4 slash commands
│   ├── harness-setup.md           /harness-setup (main, 4-phase pipeline)
│   ├── harness-update.md          /harness-update (selective regeneration)
│   ├── harness-status.md          /harness-status (current config summary)
│   └── harness-uninstall.md       /harness-uninstall (lock-based clean removal)
├── agents/                      # 3 agents (all sonnet)
│   ├── codebase-analyzer.md       Phase 1: stack detection
│   ├── config-generator.md        Phase 3: config generation + coexistence rules
│   └── harness-verifier.md        Phase 4: validation + guide generation
├── skills/harness-builder/      # Main skill + references
│   ├── SKILL.md                   Orchestration skill (auto-trigger)
│   └── references/
│       ├── stack-detectors.md     Detection heuristics (12+ languages, 20+ frameworks)
│       ├── interview-bank.md      24-question adaptive interview (6 rounds)
│       ├── plugin-catalog.md      Plugin compatibility matrix + scoring formula
│       └── cost-profiles.md       3 cost tiers (minimal/balanced/full)
├── templates/                   # 8 generation reference templates
├── scripts/                     # 2 bash utilities
├── hooks/hooks.json             # SessionStart hook
├── README.md + README-KR.md     # Bilingual docs
└── CHANGELOG.md
```

## Key Design Decisions

### Coexistence System (config-generator.md)
- All generated files use `{project-slug}-` prefix to avoid naming collisions
- settings.json: additive-only merge (never remove existing patterns)
- hooks.json: `[harness-builder]` tagged entries for identification
- CLAUDE.md: `<!-- harness-builder:start/end -->` section markers
- harness-lock.json tracks exact files/values added for precise uninstall

### Uninstall Safety (harness-uninstall.md)
- Lock-file driven deletion only — NO glob patterns for removal
- `addedDenyPatterns` / `addedHookEntries` arrays track exact values
- Backup location inside project (not /tmp/)
- JSON validation before any deletion
- Marker pair validation before CLAUDE.md section removal

### Interview Depth (interview-bank.md)
- 6 rounds, 15-24 questions (adaptive based on experience level)
- Pain point question (Q18) directly maps to hookify rules
- Existing plugin detection (Q21) prevents recommendation conflicts

## TODO / Known Issues

- [ ] End-to-end test on fresh Next.js project
- [ ] End-to-end test on Python/Django project
- [ ] End-to-end test with existing partial harness
- [ ] End-to-end test with ECC/Superpowers already installed
- [ ] Plugin recommendation Phase 2.5 web search needs real-world validation
- [ ] config-generator's actual merge implementation needs testing (described in prose, not code)
- [ ] Consider adding `--re-interview` flag to harness-setup
- [ ] README-KR: create demo terminal GIF
- [ ] Add LICENSE file
- [ ] Add CONTRIBUTING.md
- [ ] Marketplace submission to claude-plugins-official

## Essential Commands

```bash
# Local development testing
claude --plugin-dir ./

# Validate plugin structure
claude plugin validate .

# Test individual commands
/harness-setup --dry-run
/harness-status
/harness-uninstall --dry-run
```

## References

- `skills/harness-builder/references/` — All reference documents
- `templates/` — Generation templates (config-generator reads these)
- Current harness reference: `/Users/woohyunkim/dev/voc-internal-tool-claudecode/.claude/` (the production harness this plugin is modeled after)
