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
