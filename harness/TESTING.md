<!-- HARNESS:START
     version=0.32.0
     schema=1
     updated=2026-07-18T02:25:54Z
     stack=generic
     DO NOT EDIT — regenerate with: harness-ctl update /Users/patrickbertsch/dev/e2e-test-workspace
-->

# Testing — e2e-test-workspace

> **Non-negotiable rule:** No feature ships without tests. No change merges without
> verifying existing tests still pass. This is enforced in CI — a failing test blocks merge.
>
> When in doubt: write the test first, then the code.

---

## Test hierarchy

```
E2E Tests          — full user flows against a running environment (staging)
    │                 slowest · highest confidence · catch integration regressions
    ▼
Integration Tests  — components working together, real dependencies (no mocks)
    │                 medium speed · catch contract bugs between layers
    ▼
Smoke Tests        — "is it alive?" — critical paths only, run in < 30 s
    │                 fastest · run before every deploy and after every start
    ▼
Unit Tests         — single function / module in isolation
                      fastest · catch logic bugs · must cover edge cases
```

All four levels are required. Skipping any level requires explicit justification in the PR.



---

## Commands — run before every commit

```bash
# Full test suite (required before opening a PR)
(configure in TESTING.md)

# Smoke tests only (run after deploy to verify the environment is alive)


# Integration tests only


# E2E tests only (requires staging environment running)


# Unit tests only


# With coverage report


# Watch mode (during development)

```

**If any command above returns "command not found":** do not proceed. Fix the test
setup first. A missing test command is a blocker, not a warning.


---

## Secondary stack: flutter (Dart) — `mobile/`

This repo also contains a flutter component. Its tests are independent of the
suite above — running the primary commands does not exercise this code.

```bash
cd mobile && flutter pub get
cd mobile && dart analyze lib/
cd mobile && flutter test
```

| Layer | Framework | Test location |
|---|---|---|
| Unit | flutter_test (Flutter SDK) | `mobile/test/` |

Test file naming convention: `*_test.dart`



---

## Test framework

| Layer | Framework | Config file | Test location |
|---|---|---|---|
| Unit | (not detected) |  | `` |
| Integration |  |  | `` |
| Smoke |  |  | `` |
| E2E |  |  | `` |

Test file naming convention: `(not detected)`

Coverage threshold: **80%** (enforced in CI — build fails below this)

---

## Mandatory checklist — new feature

When implementing any new feature, complete all items before opening a PR:

- [ ] **Smoke test added** — does the feature's entry point respond correctly after a cold start?
- [ ] **Unit tests added** — every new function/method has at least one happy-path and one error-path test
- [ ] **Integration test added** — the feature tested end-to-end with real dependencies (database, API, harness, etc.) — no mocks at the boundary
- [ ] **E2E test added** — a full user flow that exercises the feature from the outside (HTTP request → response, UI action → result)
- [ ] **Edge cases covered** — empty input, max input, invalid types, concurrent calls, timeout
- [ ] **`(configure in TESTING.md)` passes locally** — run it, paste the output in the PR
- [ ] **Coverage did not decrease** — run `` and confirm the percentage held or increased
- [ ] **Tests are deterministic** — run the suite 3× in a row; all must pass every time
- [ ] **`cd mobile && flutter test` passes locally** — the flutter component has its own suite, not covered by the command above


---

## Mandatory checklist — change to existing feature

When modifying existing code, complete all items before opening a PR:

- [ ] **Existing tests still pass** — `(configure in TESTING.md)` green with zero failures
- [ ] **Tests updated to reflect the change** — if behaviour changed, the tests describing that behaviour are updated
- [ ] **No tests deleted** — if a test was removed, explain why in the PR (rare; valid only if the tested code itself was removed)
- [ ] **Regression test added** — if the change fixes a bug, a test that would have caught it is added
- [ ] **Integration tests re-run** — even for "small" changes; integration tests catch contract breaks that unit tests miss
- [ ] **Smoke test passes against staging** — deploy to staging, run ``, confirm green

---

## Mandatory checklist — refactor

- [ ] **No behaviour change** — test suite before and after refactor must produce identical results
- [ ] **Coverage same or higher** — refactors do not reduce coverage
- [ ] **All test types pass** — unit + integration + smoke + E2E

---

## Writing integration tests — rules

Integration tests in this project hit **real dependencies** — no mocks at the service boundary.

```

```

**What to test in integration tests:**
- Real HTTP calls to the harness (`POST http://127.0.0.1:7700/mcp`, `/harness/register`, etc.)
- Real database reads and writes (not in-memory stubs)
- Real file system operations
- Real external API calls (use staging credentials, not production)
- Auth flows end-to-end (token issuance → use → expiry)

**What does NOT belong in integration tests:**
- Testing a single function's logic in isolation → that's a unit test
- Mocking the database and calling a service function → that's a unit test with extra steps
- Full browser automation → that's an E2E test

---

## Writing smoke tests — rules

Smoke tests answer one question: **"Is the system alive and responding correctly after a cold start?"**
They run in **under 30 seconds total**. If a smoke test takes longer, it's doing too much.

```

```

**Smoke test checklist:**
- [ ] Liveness: does the main entry point respond? (`GET /health`, `GET /`, main function returns)
- [ ] Auth: does registration / login work?
- [ ] One happy-path call per critical API endpoint
- [ ] One database read (proves DB connection is alive)
- [ ] Total runtime < 30 s

---

## Writing E2E tests — rules

E2E tests run against a **deployed staging environment**, not localhost.
They simulate real user behaviour from the outside — no internal state inspection.

```

```

**E2E test checklist:**
- [ ] Uses staging URL (`(configure in INFRASTRUCTURE.md)`), not localhost
- [ ] Uses staging credentials (from vault scope `staging-api`)
- [ ] Covers the full user flow: start → action → expected result → cleanup
- [ ] Asserts on the response/output, not on internal state
- [ ] Cleans up after itself (deletes test data, logs out, etc.)
- [ ] Idempotent — can be run multiple times without side effects
- [ ] Does not depend on test execution order

---

## Harness tool calls in tests — exact syntax

When tests interact with the harness, use the following patterns.
These are the only valid parameter combinations — any deviation causes a tool error.

### Register and get token
```

```

### Call a tool
```

```

### Assert tool response structure
```

```

### Common test errors and fixes

| Error | Cause | Fix |
|---|---|---|
| `401 Unauthorized` | Token expired or wrong secret | Re-register in test setup; check `HARNESS_REGISTER_SECRET` |
| `403 Forbidden` | Tool not in `allowed_tools` | Add tool to test agent manifest in `config/agents/` |
| `"key and value are required"` | `memory_store` called with empty param | Ensure both `key` and `value` are non-empty strings |
| `"query is required"` | `memory_search` called with empty query | Ensure `query` is a non-empty string |
| `"cmd must be a plain command name"` | `shell` called with a path in `cmd` | Use `"go"` not `"/usr/local/bin/go"` |
| `"only http and https URLs"` | `web_fetch` or `http_client` with bad scheme | URL must start with `https://` or `http://` |
| `"private and internal URLs"` | SSRF block on localhost/private IP | Do not call localhost from http_client in tests; use httptest patterns instead |
| `"path traversal not allowed"` | `file_ops` path escapes root | Use relative paths only |
| `429 Too Many Requests` | Budget or rate limit hit | Reset budget by re-registering; or increase limit in test manifest |

---

## CI pipeline — test stages

```
PR opened
    │
    ├── 1. Unit tests                     must pass
    ├── 2. Integration tests       must pass
    ├── 3. Build               (configure in TESTING.md)               must pass
    └── 4. Coverage check             must be ≥ 80%

PR merged to staging branch
    │
    ├── 5. Deploy to staging   
    ├── 6. Smoke tests                   must pass (blocks prod deploy)
    └── 7. E2E tests                       must pass (blocks prod deploy)

Staging approved (HITL gate — APPROVE required)
    │
    ├── 8. Deploy to production 
    └── 9. Smoke tests (prod)      must pass (alert on failure)
```

**A failed test at any stage is a hard block. Do not bypass CI.**
If CI is flaky (test passes locally, fails in CI intermittently):
1. Mark the test with `(not detected)` and open a bug ticket immediately
2. Do not merge until the flake is resolved — a flaky test is a broken test

---

## Test data and fixtures

| Concern | Rule |
|---|---|
| Test data isolation | Each test creates its own data and cleans it up — never share state between tests |
| Credentials in tests | Never hardcode — use `http://127.0.0.1:7700/harness/vault/token` or `.env.test` |
| Production data in tests | Never — use staging environment and synthetic test data only |
| Snapshot tests | Acceptable for UI components; commit snapshots in git; update intentionally |
| Random data | Use deterministic seeds — `Math.random()` / `rand.New(...)` with a fixed seed |

---

## Coverage requirements

| Layer | Minimum | Target |
|---|---|---|
| Unit | % | % |
| Integration | % | % |
| Overall | 80% | % |

Run coverage report: ``
View HTML report: ``

Coverage does not substitute for test quality. 100% coverage with only happy-path tests
is worse than 80% coverage with thorough edge-case tests.




---

## Notes from previous version

---

<!-- Add project-specific test patterns, known flaky tests, and test
     infrastructure notes below. The harness block above is managed automatically. -->



<!-- HARNESS:END -->

---

<!-- Add project-specific test patterns, known flaky tests, and test
     infrastructure notes below. The harness block above is managed automatically. -->
