# Changelog

## [0.1.0] - 2026-04-08

### Added
- Initial release
- `/harness-setup` command — 4-phase pipeline (analyze, interview, generate, verify)
- `/harness-update` command — selective regeneration of managed sections
- `/harness-status` command — current configuration summary
- `codebase-analyzer` agent — tech stack detection for 12+ languages, 20+ frameworks
- `config-generator` agent — generates settings, hooks, skills, agents, CLAUDE.md
- `harness-verifier` agent — 9-point validation + Korean guide generation
- 4 reference documents (stack-detectors, interview-bank, plugin-catalog, cost-profiles)
- 8 generation templates (CLAUDE.md, settings, hooks, skills, agents, scripts)
- 3 cost tiers (minimal, balanced, full)
- Non-destructive merge with harness-lock.json tracking
- SessionStart hook for setup suggestion
