import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Japanese',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SwitchListTile(
                key: const ValueKey('dark_mode_toggle'),
                title: const Text('Dark Mode'),
                value: provider.darkMode,
                onChanged: provider.toggleDarkMode,
              ),
              SwitchListTile(
                key: const ValueKey('notifications_toggle'),
                title: const Text('Notifications'),
                value: provider.notifications,
                onChanged: provider.toggleNotifications,
              ),
              CheckboxListTile(
                key: const ValueKey('terms_checkbox'),
                title: const Text('Agree to Terms'),
                value: provider.termsAccepted,
                onChanged: (value) {
                  if (value != null) {
                    provider.toggleTermsAccepted(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: const ValueKey('language_dropdown'),
                decoration: const InputDecoration(
                  labelText: 'Language',
                  border: OutlineInputBorder(),
                ),
                value: provider.language,
                items: _languages
                    .map((lang) => DropdownMenuItem(
                          value: lang,
                          child: Text(lang),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    provider.setLanguage(value);
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: const ValueKey('save_button'),
                onPressed: () {
                  provider.savePreferences();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings saved')),
                  );
                },
                child: const Text('Save'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                key: const ValueKey('delete_button'),
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: const Text('Delete Account'),
              ),
              const SizedBox(height: 24),
              Text(
                'Build: 1.0.42+dev',
                key: const ValueKey('build_info'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}
