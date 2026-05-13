import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_probe_agent/flutter_probe_agent.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../../../../navigation/routes.dart';
import '../providers/auth_provider.dart';

/// Tests FlutterProbe v0.9.8's biometric simulation hooks
/// (`enroll biometric`, `biometric match`, `biometric no match`).
///
/// In PROBE_AGENT builds, uses [awaitBiometricResult] instead of
/// `local_auth.authenticate()` so the ProbeAgent CLI can deliver the
/// match/no-match result directly via [probe.biometric_signal] — required
/// on iOS 26+ where `notifyutil` no-match notifications no longer resolve
/// [LAContext.evaluatePolicy].
class BiometricLoginPage extends StatefulWidget {
  const BiometricLoginPage({super.key});

  @override
  State<BiometricLoginPage> createState() => _BiometricLoginPageState();
}

class _BiometricLoginPageState extends State<BiometricLoginPage> {
  final _auth = LocalAuthentication();
  bool _busy = false;
  String? _error;

  Future<void> _signInWithBiometrics() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    bool ok = false;
    try {
      if (const bool.fromEnvironment('PROBE_AGENT')) {
        // In test mode the CLI sends probe.biometric_signal after firing the
        // platform-level biometric notification. Using awaitBiometricResult()
        // bypasses LAContext so no-match reliably resolves on all iOS versions.
        ok = await awaitBiometricResult();
      } else {
        ok = await _auth.authenticate(
          localizedReason: 'Sign in to your account',
          options: const AuthenticationOptions(
            stickyAuth: false,
            biometricOnly: true,
          ),
        );
      }
    } on PlatformException {
      // Any platform error in non-probe mode is treated as authentication failure.
    }

    if (!mounted) return;

    if (ok) {
      await context.read<AuthProvider>().loginWithBiometrics();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.dashboard,
        (route) => route.isFirst,
      );
      return;
    }

    setState(() {
      _busy = false;
      _error = 'Authentication failed';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 48),
            const Icon(Icons.face_retouching_natural, size: 96),
            const SizedBox(height: 16),
            const Text(
              'Use your face or fingerprint to sign in.',
              key: ValueKey('biometric_prompt_intro'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              key: const ValueKey('sign_in_with_face_id'),
              onPressed: _busy ? null : _signInWithBiometrics,
              icon: const Icon(Icons.face),
              label: const Text('Sign in with Face ID'),
            ),
            if (_busy) ...[
              const SizedBox(height: 24),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(
                    key: ValueKey('biometric_progress'),
                  ),
                ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 24),
              Container(
                key: const ValueKey('biometric_error_banner'),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
