<!-- HARNESS:START
     version=0.32.0
     schema=1
     agent=e2e-test-workspace
     updated=2026-07-18T02:25:54Z
     DO NOT EDIT THIS BLOCK — regenerate with: harness-ctl update /Users/patrickbertsch/dev/e2e-test-workspace
-->

# Harness — Active Constraints

**This file is the entry point for every task in this project — always start here.**

**Agent:** `e2e-test-workspace` · trust: `worker` · model: `mid`
**Budget:** 40 steps · 80000 tokens · $3.00 per session
**Privacy:** local_preferred — local models preferred; cloud only on low confidence
**Memory namespace:** `e2e-test-workspace-worker`


## Must escalate (blocks until human approves)

- `create_pr`

- `deploy`

- `spend`



## Available tools
See `harness/TOOLS.md` for full reference with parameter schemas.

- `web_search` — search the web via Brave/Google
- `web_fetch` — fetch and extract URL content
- `file_ops` — read/write files within the project root
- `memory_store` / `memory_search` — per-session key-value memory

## Project overrides (harness.yaml)

*(no harness.yaml found — using manifest defaults)*


<!-- HARNESS:END -->

---


# Harness — E2eTestWorkspace

**Agent:** `e2e-test-workspace` · trust: `worker` · model: `mid`
**Project root:** `~/dev/e2e-test-workspace`
**Remote:** `https://github.com/AlphaWaveSystems/e2e-test-workspace`
**Stack:** `test configuration`

## Startup

Before working:
1. Read this file
2. `cd ~/dev/e2e-test-workspace`
3. Run verification: `echo "Add verification command for this project"`
4. Check `git status` and `git log --oneline -10`

## Working rules

- Branch names: `feat/e2e-test-workspace`, `fix/e2e-test-workspace`, `chore/e2e-test-workspace`
- Always work in a git worktree: `git worktree add .worktrees/<branch> -b <branch>`
- Stage specific files only — never `git add .`
- Commit format: `type: description` (feat/fix/chore/refactor/docs)
- PRs required for all merges — no direct commits to main/master
- Run verification before every commit

## Verification

```bash
echo "Add verification command for this project"
```

## Definition of done

- [ ] Implementation complete and verified
- [ ] Tests pass
- [ ] PR created (or commit staged if no remote)
- [ ] No regressions in adjacent features

## Guardrails

Bounded autonomy. Escalate deploys and spend to Zeus.
