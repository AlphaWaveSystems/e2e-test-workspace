# E2E Test Workspace

Test workspace for [FlutterProbe](https://github.com/AlphaWaveSystems/flutter-probe) E2E testing.

## Structure

```
mobile/               Flutter test app (iOS + Android) — 11 screens, 78 E2E tests
native/ios-swift/     Native SwiftUI twin of the Flutter app — same 11 screens, 1:1 accessibilityIdentifiers
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

## Native iOS Twin

[`native/ios-swift/`](native/ios-swift/) is a hand-built SwiftUI app that replicates all 11 `mobile/` screens with real (not stubbed) behavior — same navigation shape, same state transitions, same assertable text. Every interactive/assertable view carries an `.accessibilityIdentifier` that mirrors the Flutter app's `ValueKey` 1:1 (e.g. `tab_home`, `nav_login`, `sign_in_button`), so the same test scenarios can eventually run against both frameworks with only the selector syntax changing.

- Bundle id `com.alphawavesystems.probeTestApp.native` (distinct from the Flutter app's `com.alphawavesystems.probeTestApp`, so both can be installed on one simulator at once).
- Biometric Login uses real `LocalAuthentication` (Face ID/Touch ID), matching the Flutter screen's enrollment/match/no-match flow.
- Built via `xcodegen` + `xcodebuild`, same pattern as `flutter-probe/native-test-apps/ios/`. See `native/ios-swift/project.yml`.

**Not yet runnable end-to-end via ProbeScript.** FlutterProbe drives apps through an embedded Flutter agent package that only exists inside Flutter apps; iOS support for driving arbitrary native UI (WebDriverAgent/XCTest-based) is tracked as proposal **N-2** in the flutter-probe repo (`docs/proposals/n2-ios-native-ui-bridging.md`) and is **not yet implemented** as of this writing. `native/ios-swift/probe-tests/native_suite.probe` records the intended test scenarios, clearly marked pending at the top of the file, ready to run once N-2 lands. In the meantime, `native/ios-swift/UITests/ProbeNativeTwinUITests.swift` is a standalone XCUITest smoke suite that verifies the key accessibilityIdentifiers actually resolve at runtime.

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
