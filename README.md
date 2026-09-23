# Claude Helper

Personal collection of Claude Code customizations — rules, commands, agents, hooks, and plugins — portable across any machine.

## Why this repo is useful

Claude Code becomes significantly more effective when it has the right rules, commands, agents, and hooks wired up — but setting that up from scratch on every machine (or for every teammate) is tedious and easy to forget. This repo gives you a ready-to-use, opinionated starter kit that you can install with one command and carry across machines:

- **Save money** — built-in rules push Claude toward the cheapest model that fits the task and keep responses terse, cutting token spend on every turn.
- **Skip the setup** — slash commands (`/review`, `/pr`, `/changelog`), agents, and hooks for format/lint/test are pre-wired and ready to drop in.
- **Stay portable** — clone anywhere and run `./install.sh`; existing files are preserved by default, so it's safe to layer on top of an existing `~/.claude/`.
- **Easy to extend** — drop a new `.md` into the right folder, re-run the installer, and it's live. Fork it and make it yours.

## What's Included

| Folder | Purpose | Description |
|--------|---------|-------------|
| `rules/` | Global rules | Behavior directives loaded into every Claude Code session |
| `commands/` | Slash commands | Custom `/command` skills invokable in any conversation |
| `agents/` | Agent definitions | Reusable agent specs with model, tools, and prompt |
| `skills/` | Orchestrated workflows | Invokable workflows backed by reusable agents |
| `hooks/` | Pre/post hooks | Shell scripts triggered by Claude Code events |
| `plugins/` | Plugins | Packaged extensions with skills and references |
| `docs/` | Reference docs | Detailed guides linked from rules/agents |
| `.claude/` | Settings | Permission allowlists and config copied to `~/.claude/` root |

> Folders that don't exist yet are skipped by the installer.

## Quick Start

```bash
git clone <repo-url>
cd claude-helper
./install.sh
```

This copies everything into `~/.claude/`, skipping files that already exist.

Windows PowerShell:

```powershell
git clone <repo-url>
cd claude-helper
.\install.ps1
```

This copies everything into `$HOME/.claude`, skipping files that already exist.

## Install Options

```bash
# Install everything (skip existing)
./install.sh

# Install specific modules only
./install.sh rules
./install.sh rules commands agents

# Force overwrite existing files
./install.sh -f

# Dry run — preview without copying
./install.sh -d

# Combine options
./install.sh -d rules          # Dry run, rules only
./install.sh -f commands       # Force overwrite commands only
```

PowerShell equivalents:

```powershell
# Install everything (skip existing)
.\install.ps1

# Install specific modules only
.\install.ps1 rules
.\install.ps1 rules commands agents

# Force overwrite existing files
.\install.ps1 -Force

# Dry run - preview without copying
.\install.ps1 -DryRun

# Combine options
.\install.ps1 -DryRun rules      # Dry run, rules only
.\install.ps1 -Force commands    # Force overwrite commands only
```

## Current Contents

### Rules

| File | What it does |
|------|-------------|
| `rules/claude-credits/model-selection-strategy.md` | Use the cheapest model that fits the task |
| `rules/claude-credits/response-context-efficiency.md` | Minimize token usage — terse responses, targeted reads |
| `rules/claude-credits/rule-agent-optimization.md` | Keep rules and agents concise for token efficiency |
| `rules/claude-credits/continuous-improvement.md` | After every task, optimize for cost/speed/efficiency |
| `rules/git-no-co-author.md` | Never add Co-Authored-By trailers to commits |

### Commands

| File | What it does |
|------|-------------|
| `commands/review.md` | `/review [PR#]` — Review staged changes or a specific PR |
| `commands/pr.md` | `/pr [options]` — Create a PR with structured summary and test plan |
| `commands/changelog.md` | `/changelog [range]` — Generate grouped changelog from git history |
| `commands/whatsapp.md` | `/whatsapp <file>` — Convert markdown to WhatsApp formatting |

### Hooks

| File | Event | What it does |
|------|-------|-------------|
| `hooks/format-on-save.sh` | PostToolUse (Edit/Write) | Auto-format files using prettier, black, gofmt, etc. |
| `hooks/lint-before-commit.sh` | PreToolUse (git commit) | Run linter on staged files, block commit on errors |
| `hooks/test-before-push.sh` | PreToolUse (git push) | Auto-detect test runner, block push on failures |

### Agents

| File | What it does |
|------|-------------|
| `agents/model-selector.md` | Recommend optimal model (haiku/sonnet/opus) for a task |
| `agents/rule-agent-optimizer.md` | Trim rules and agents to target line counts |
| `agents/orchestrators/mvp-test-factory.md` | Bootstrap unit tests, coordinate parallel API/UI/k6 test authoring, and run ordered quality gates |
| `agents/building-blocks/testers/mvp-test-bootstrapper.md` | Own approved manifests, shared test configuration, and the first passing unit smoke test |
| `agents/building-blocks/testers/api-e2e-writer.md` | Author public API end-to-end tests in an exclusive path |
| `agents/building-blocks/testers/ui-e2e-writer.md` | Author stable Playwright browser tests in an exclusive path |
| `agents/building-blocks/testers/performance-test-writer.md` | Author a bounded local k6 smoke test and server lifecycle wrapper |
| `agents/building-blocks/testers/quality-gate-runner.md` | Verify ownership and run build, unit, API, UI, and performance gates in order |

### Skills

| Skill | What it does |
|------|-------------|
| `/mvp-test-factory [project-path]` | Build and verify a real automated-test foundation for an MVP or prototype |

### Docs

| File | What it does |
|------|-------------|
| [Model Selection Guide](docs/model-selection-guide.md) | Full reference for model cost/capability tradeoffs |
| [MVP Test Factory Guide](docs/mvp-test-factory-guide.md) | Reusable workflow and password-strength-checker reference run |

## Adding New Customizations

Drop files into the appropriate folder and re-run `./install.sh`:

- **Rules** — `.md` files in `rules/`, optionally in subdirectories
- **Commands** — `.md` files in `commands/` with `$ARGUMENTS` for user input
- **Agents** — `.md` files in `agents/` with YAML frontmatter (name, tools, model)
- **Hooks** — Shell scripts in `hooks/`
- **Plugins** — Structured plugin packages in `plugins/`
- **Docs** — Reference material in `docs/`, linked from rules or agents

## How Claude Code Discovers These

Claude Code reads from `~/.claude/` at session start:

- `~/.claude/rules/**/*.md` — Global rules applied to every conversation
- `~/.claude/commands/**/*.md` — Available as `/command-name` slash commands
- `~/.claude/agents/**/*.md` — Available as agent definitions
- `~/.claude/docs/` — Reference docs accessible to rules and agents
- `~/.claude/plugins/` — Plugin packages with skills and references
- Hooks are configured in `~/.claude/settings.json` (see below)

## Wiring Up Hooks

The installer copies hook scripts to `~/.claude/hooks/`, but they also need to be registered in your `~/.claude/settings.json`. Add the `hooks` key:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{ "type": "command", "command": "~/.claude/hooks/format-on-save.sh $FILE_PATH" }]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash(git commit*)",
        "hooks": [{ "type": "command", "command": "~/.claude/hooks/lint-before-commit.sh" }]
      },
      {
        "matcher": "Bash(git push*)",
        "hooks": [{ "type": "command", "command": "~/.claude/hooks/test-before-push.sh" }]
      }
    ]
  }
}
```

Pick only the hooks you want — they're independent of each other.

## Uninstall

The installer only copies files — it never deletes. To remove, manually delete the corresponding files from `~/.claude/`.
