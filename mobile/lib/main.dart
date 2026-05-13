import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nightowl_sdk/nightowl.dart';

import 'package:flutter_probe_agent/flutter_probe_agent.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  NightOwlBinding.ensureInitialized(
    config: NightOwlConfig(
      serverUrl: 'ws://localhost:7890/sessions/stream',
      debugLogging: true,
      deviceMetadata: {'app': 'probe_test_app', 'version': '1.0.0'},
    ),
  );

  const probeEnabled = bool.fromEnvironment('PROBE_AGENT');
  if (probeEnabled) {
    ProbeAgent.start();
  }

  setupDependencies();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const ProbeTestApp(),
    ),
  );
}
