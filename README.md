# E2E Test Workspace

Test workspace for [FlutterProbe](https://github.com/AlphaWaveSystems/flutter-probe) E2E testing.

## Structure

```
mobile/       Flutter test app (iOS + Android) — 10 screens, 74 E2E tests
```

## Mobile App

Purpose-built Flutter app for exercising every FlutterProbe framework feature:

- **10 screens**: Home, Login, Dashboard, Settings, Items, Gestures, API, Device, Visual, Dynamic
- **74 test files** covering: navigation, forms, gestures, HTTP mocking, visual regression, hooks, data-driven tests, and more
- **Clean Architecture**: domain/data/presentation layers with Provider + get_it

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
