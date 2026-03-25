import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:probe_agent/probe_agent.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
