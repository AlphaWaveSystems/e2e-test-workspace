import 'package:flutter/material.dart';

import 'navigation/routes.dart';
import 'navigation/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/dashboard_page.dart';

class ProbeTestApp extends StatelessWidget {
  const ProbeTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterProbe Test App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: Routes.home,
      routes: {
        Routes.home: (context) => const HomePage(),
        Routes.login: (context) => const LoginPage(),
        Routes.dashboard: (context) => const DashboardPage(),
        Routes.settings: (context) => const _PlaceholderPage(title: 'Settings'),
        Routes.items: (context) => const _PlaceholderPage(title: 'Items'),
        Routes.gestures: (context) => const _PlaceholderPage(title: 'Gestures'),
        Routes.api: (context) => const _PlaceholderPage(title: 'API Tests'),
        Routes.device: (context) => const _PlaceholderPage(title: 'Device'),
        Routes.visual: (context) => const _PlaceholderPage(title: 'Visual'),
        Routes.dynamic: (context) => const _PlaceholderPage(title: 'Dynamic'),
      },
    );
  }
}

/// Temporary placeholder page for screens not yet implemented.
class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title — Coming Soon',
          key: ValueKey('placeholder_$title'),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
