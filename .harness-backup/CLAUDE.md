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
