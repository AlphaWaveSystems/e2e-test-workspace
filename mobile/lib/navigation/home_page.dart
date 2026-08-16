import 'package:flutter/material.dart';

import 'routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterProbe Test App'),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) => setState(() => _currentTabIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Semantics(
              identifier: 'tab_home_icon',
              child: const Icon(Icons.home, key: ValueKey('tab_home_icon')),
            ),
            label: 'Home',
            key: const ValueKey('tab_home'),
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              identifier: 'tab_tests_icon',
              child: const Icon(Icons.science, key: ValueKey('tab_tests_icon')),
            ),
            label: 'Tests',
            key: const ValueKey('tab_tests'),
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              identifier: 'tab_about_icon',
              child: const Icon(Icons.info, key: ValueKey('tab_about_icon')),
            ),
            label: 'About',
            key: const ValueKey('tab_about'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentTabIndex) {
      case 1:
        return Center(
          child: Semantics(
            identifier: 'tests_tab_content',
            child: const Text(
              'Test Suites',
              key: ValueKey('tests_tab_content'),
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      case 2:
        return Center(
          child: Semantics(
            identifier: 'about_tab_content',
            child: const Text(
              'About FlutterProbe Test App',
              key: ValueKey('about_tab_content'),
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Semantics(
            identifier: 'welcome_text',
            child: const Text(
              'Welcome to the FlutterProbe Test App',
              key: ValueKey('welcome_text'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              _navTile('Login', Icons.login, Routes.login, 'nav_login'),
              _navTile('Biometric Login', Icons.face, Routes.biometric, 'nav_biometric'),
              _navTile('Signal Demo', Icons.notifications_active, Routes.signal, 'nav_signal'),
              _navTile('Dashboard', Icons.dashboard, Routes.dashboard, 'nav_dashboard'),
              _navTile('Settings', Icons.settings, Routes.settings, 'nav_settings'),
              _navTile('Items', Icons.list, Routes.items, 'nav_items'),
              _navTile('Gestures', Icons.touch_app, Routes.gestures, 'nav_gestures'),
              _navTile('API Tests', Icons.api, Routes.api, 'nav_api'),
              _navTile('Device', Icons.phone_android, Routes.device, 'nav_device'),
              _navTile('Visual', Icons.visibility, Routes.visual, 'nav_visual'),
              _navTile('Dynamic', Icons.dynamic_feed, Routes.dynamic, 'nav_dynamic'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Semantics(
            identifier: 'version_text',
            child: const Text(
              'Version 1.0',
              key: ValueKey('version_text'),
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _navTile(String title, IconData icon, String route, String keyName) {
    return Semantics(
      identifier: keyName,
      child: ListTile(
        key: ValueKey(keyName),
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
