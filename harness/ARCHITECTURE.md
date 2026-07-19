<!-- HARNESS:START
     version=0.34.0
     schema=1
     updated=2026-07-19T12:15:55Z
     DO NOT EDIT — regenerate with: harness-ctl update /Users/patrickbertsch/dev/e2e-test-workspace
-->

# Architecture — e2e-test-workspace

> Auto-generated from constitution scan on 2026-07-19T12:15:55Z.
> Reflects the state of the repo at install time — update manually as the project evolves,
> or re-run `harness-ctl update /Users/patrickbertsch/dev/e2e-test-workspace` to refresh from the latest scan.

---

## Project identity

| Field | Value |
|---|---|
| Name | e2e-test-workspace |
| Path | `/Users/patrickbertsch/dev/e2e-test-workspace` |
| Repository | https://github.com/AlphaWaveSystems/e2e-test-workspace.git |
| Stack | generic |
| Language(s) | (not detected) |
| Runtime | (not detected) |
| Package manager | (not detected) |
| Zeus owner | `atlas` |

---

## Project overview


# E2E Test Workspace

Test workspace for [FlutterProbe](https://github.com/AlphaWaveSystems/flutter-probe) E2E testing.

## Structure

```
mobile/       Flutter test app (iOS + Android) — 11 screens, 78 E2E tests
```

## Mobile App

Purpose-built Flutter app for exercising every FlutterProbe framework feature:

- **11 screens**: Home, Login, **Biometric Login (new in v0.9.7)**, Dashboard, Settings, Items, Gestures, API, Device, Visual, Dynamic
- **78 test files** covering: navigation, forms, gestures, HTTP mocking, visual regression, hooks, data-driven tests, and **Face ID / Touch ID / fingerprint flows (new)**
- **Clean Architecture**: domain/data/presentation layers with Provider + get_it

### Biometric auth tests (v0.9.7)

The `BiometricLoginPage` exercises the new `enroll biometric` / `biometric match` / `biometric no match` ProbeScript steps. Live tests in `mobile/tests/auth/`:

- `biometric_match.probe` — matching Face ID unlocks the app (smoke + cold-start variants)
- `biometric_no_match.probe` — non-matching Face ID shows an error banner; retry-after-failure path

**Prerequisites:**
- iOS: just a running simulator (notifyutil drives the prompt — no extra setup)
- Android: emulator with fingerprint ID `1` pre-enrolled in Settings → Security
- Physical devices skip these steps with a warning (`set location`-style behavior)

## Running Tests

```bash
# Build with ProbeAgent enabled
cd mobile
flutter build apk --debug --dart-define=PROBE_AGENT=true    # Android
flutter build ios --debug --simulator --dart-define=PROBE_AGENT=true  # iOS

# Run all tests
probe test mobile/tests/ --device <device-serial> --config mobile/tests/probe.yaml -v -y

# Run in parallel across iOS + Android
probe test mobile/tests/ --parallel --devices emulator-5554,<ios-udid>
```

## License

[BSL 1.1](https://github.com/AlphaWaveSystems/flutter-probe/blob/main/LICENSE) — same as FlutterProbe.


---

## Stack overview

Generic project.

### Key entry points


### Build and test commands

| Action | Command |
|---|---|
| Install deps | `` |
| Build | `(configure in TESTING.md)` |
| Test | `(configure in TESTING.md)` |
| Lint | `(not detected — configure manually)` |
| Dev server | `` |
| Deploy (staging) | `` |
| Deploy (production) | `` |


### Secondary stack: flutter (Dart) — `mobile/`

Dart/Flutter package in `mobile/`. Installed with `flutter pub get`, tested with `flutter test`.

| Action | Command |
|---|---|
| Install deps | `cd mobile && flutter pub get` |
| Build / analyze | `cd mobile && dart analyze lib/` |
| Test | `cd mobile && flutter test` |


---

## Directory structure

```
├── AGENTS.md
├── CLAUDE.md
├── README.md
├── backend/
│   └── cmd/
│   └── go.mod
│   └── internal/
├── frontend/
│   └── index.html
│   └── package.json
│   └── src/
│   └── tsconfig.json
│   └── vite.config.ts
├── harness/
│   └── ARCHITECTURE.md
│   └── FEATURES.md
│   └── INFRASTRUCTURE.md
│   └── SECURITY.md
│   └── TESTING.md
│   └── TOOLS.md
│   └── VERSION
│   └── WORKFLOWS.md
├── mobile/
├── reports/
```

---

## Dependencies

**Runtime dependencies (0):**



**Dev dependencies:**


---

## Environment variables

Variables the project reads at runtime. Do not commit values — use the harness vault.

| Variable | Required | Purpose |
|---|---|---|


*(none detected — add manually if needed)*


---

## External services



*(none detected)*


---

## Constitution context

Rules extracted from `CLAUDE.md` at install time:

<!-- HARNESS:START
     version=0.33.0
     schema=1
     agent=e2e-test-workspace
     updated=2026-07-19T05:36:09Z
     DO NOT EDIT THIS BLOCK — regenerate with: harness-ctl update /Users/patrickbertsch/dev/e2e-test-workspace
-->

# Harness — Active Constraints

**This file is the entry point for every task in this project — always start here.**

**Agent:** `e2e-test-workspace` · trust: `worker` · model: `mid`
**Budget:** 40 steps · 80000 tokens · $3.00 per session
**Privacy:** local_preferred — local models preferred; cloud only on low confidence
**Memory namespace:** `e2e-test-workspace-worker`


## Must escalate (blocks until human approves)

*(truncated — see CLAUDE.md for full rules)*

*(Full rules in `CLAUDE.md` — this is a harness-generated summary only)*



---

## Notes from previous version

---

<!-- Add architecture decisions, diagrams, and notes below.
     The harness block above is managed automatically — everything below is yours. -->



<!-- HARNESS:END -->

---

<!-- Add architecture decisions, diagrams, and notes below.
     The harness block above is managed automatically — everything below is yours. -->
