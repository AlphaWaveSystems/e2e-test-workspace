import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../navigation/routes.dart';
import '../providers/auth_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final userName = auth.currentUser?.name ?? 'Guest';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                key: const ValueKey('refresh_button'),
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Refreshed')),
                  );
                },
              ),
              IconButton(
                key: const ValueKey('logout_button'),
                icon: const Icon(Icons.logout),
                onPressed: () {
                  auth.logout();
                  Navigator.pushReplacementNamed(context, Routes.home);
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // Simulate refresh
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Welcome banner
                Card(
                  key: const ValueKey('welcome_banner'),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, $userName',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Here is your dashboard overview',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Stat cards row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        key: const ValueKey('stat_card_1'),
                        title: 'Tests Run',
                        value: '42',
                        icon: Icons.check_circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        key: const ValueKey('stat_card_2'),
                        title: 'Passed',
                        value: '38',
                        icon: Icons.thumb_up,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        key: const ValueKey('stat_card_3'),
                        title: 'Failed',
                        value: '4',
                        icon: Icons.error_outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Items section header
                Text(
                  'Recent Items',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),

                // Item list
                ...List.generate(10, (index) {
                  return ListTile(
                    key: ValueKey('item_$index'),
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text('Item ${index + 1}'),
                    subtitle: Text('Description for item ${index + 1}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped item ${index + 1}')),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
