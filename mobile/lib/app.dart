import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'navigation/routes.dart';
import 'navigation/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/dashboard_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'features/items/presentation/pages/item_list_page.dart';
import 'features/items/presentation/providers/item_provider.dart';
import 'features/gestures/presentation/pages/gestures_page.dart';
import 'features/device/presentation/pages/device_page.dart';
import 'features/visual/presentation/pages/visual_page.dart';
import 'features/dynamic/presentation/pages/dynamic_page.dart';

class ProbeTestApp extends StatelessWidget {
  const ProbeTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
      ],
      child: MaterialApp(
        key: UniqueKey(),
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
          Routes.settings: (context) => const SettingsPage(),
          Routes.items: (context) => const ItemListPage(),
          Routes.gestures: (context) => const GesturesPage(),
          Routes.api: (context) => const _ApiPage(),
          Routes.device: (context) => const DevicePage(),
          Routes.visual: (context) => const VisualPage(),
          Routes.dynamic: (context) => const DynamicPage(),
        },
      ),
    );
  }
}

/// Simple API demo page with fetch/post buttons.
class _ApiPage extends StatefulWidget {
  const _ApiPage();

  @override
  State<_ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<_ApiPage> {
  bool _loading = false;
  String? _error;
  List<String> _users = [];
  String? _postResult;

  Future<void> _fetchUsers() async {
    setState(() { _loading = true; _error = null; });
    try {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _users = ['Leanne Graham', 'Ervin Howell', 'Clementine Bauch'];
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = 'Server Error'; _loading = false; });
    }
  }

  Future<void> _createPost() async {
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _postResult = 'Post created with id: 101';
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              key: const ValueKey('fetch_users_button'),
              onPressed: _loading ? null : _fetchUsers,
              child: const Text('Fetch Users'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              key: const ValueKey('create_post_button'),
              onPressed: _loading ? null : _createPost,
              child: const Text('Create Post'),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Center(
                child: CircularProgressIndicator(
                  key: ValueKey('api_loading'),
                ),
              ),
            if (_error != null)
              Text(
                _error!,
                key: const ValueKey('api_error'),
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 16),
              ),
            if (_users.isNotEmpty) ...[
              const Text('Users:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ...List.generate(_users.length, (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(_users[i], key: ValueKey('user_$i')),
              )),
            ],
            if (_postResult != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _postResult!,
                  key: const ValueKey('post_result'),
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ),
          ],
        ),
      ),
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
