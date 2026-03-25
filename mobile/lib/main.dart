import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: Uncomment when probe_agent is added as a git dependency
// import 'package:probe_agent/probe_agent.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ProbeAgent if PROBE_AGENT dart define is set
  const probeEnabled = bool.fromEnvironment('PROBE_AGENT');
  if (probeEnabled) {
    // TODO: Uncomment when probe_agent is added as a git dependency
    // await ProbeAgent.init();
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
