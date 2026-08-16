# E2E Test Workspace

Test workspace for [FlutterProbe](https://github.com/AlphaWaveSystems/flutter-probe) E2E testing.

## Structure

```
mobile/                 Flutter test app (iOS + Android) — 11 screens, 78 E2E tests
native/android-kotlin/  Native Android twin (Kotlin + Jetpack Compose) — same 11 screens, for native-verb testing
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

## Native Android Twin

[`native/android-kotlin/`](native/android-kotlin/) is a full native Android replica of the Flutter app (Kotlin, Jetpack Compose, applicationId `com.alphawavesystems.probe_test_app_native`) built to exercise FlutterProbe's **native verb family** (`tap native`, `type native`, `see native`, `don't see native`) against a real non-Flutter app. Every interactive/assertable view carries a Compose `testTag` that mirrors the Flutter app's `ValueKey` names 1:1 and is surfaced as a uiautomator `resource-id` (`testTagsAsResourceId`), so the same element vocabulary works across both apps. The Biometric Login screen uses the real Android `BiometricPrompt`, driven by `biometric match` / `biometric no match`. Its native-verb suite lives in [`native/android-kotlin/probe-tests/`](native/android-kotlin/probe-tests/) — see the suite header for the run pattern (native verbs are CLI-side; a ProbeAgent host app holds the session while this app is foregrounded).

```bash
cd native/android-kotlin
JAVA_HOME=$(/usr/libexec/java_home -v 21) ./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb shell am start -n com.alphawavesystems.probe_test_app_native/.MainActivity
```

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
