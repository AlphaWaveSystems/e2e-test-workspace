import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  String _cameraStatus = 'Not requested';
  String _locationStatus = 'Not requested';
  String _gpsDisplay = 'Location: --';
  String _pastedText = '';

  final TextEditingController _copyController =
      TextEditingController(text: 'Copy this text');

  @override
  void dispose() {
    _copyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Permission buttons
            const Text('Permissions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              key: const ValueKey('request_camera'),
              onPressed: () {
                setState(() {
                  _cameraStatus = 'Granted';
                });
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Request Camera'),
            ),
            const SizedBox(height: 4),
            Text(
              'Camera: $_cameraStatus',
              key: const ValueKey('camera_status'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              key: const ValueKey('request_location'),
              onPressed: () {
                setState(() {
                  _locationStatus = 'Granted';
                  _gpsDisplay = 'Location: 37.7749, -122.4194';
                });
              },
              icon: const Icon(Icons.location_on),
              label: const Text('Request Location'),
            ),
            const SizedBox(height: 4),
            Text(
              'Location: $_locationStatus',
              key: const ValueKey('location_status'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              key: const ValueKey('request_notifications'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Notification permission requested')),
                );
              },
              icon: const Icon(Icons.notifications),
              label: const Text('Request Notifications'),
            ),
            const SizedBox(height: 24),

            // GPS Display
            const Text('GPS',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              _gpsDisplay,
              key: const ValueKey('gps_display'),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Open browser
            const Text('Browser',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              key: const ValueKey('open_browser'),
              onPressed: () async {
                final url = Uri.parse('https://www.google.com');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Open Website'),
            ),
            const SizedBox(height: 24),

            // Clipboard
            const Text('Clipboard',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            TextField(
              key: const ValueKey('copy_text_field'),
              controller: _copyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Text to copy',
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              key: const ValueKey('paste_button'),
              onPressed: () async {
                final data = await Clipboard.getData(Clipboard.kTextPlain);
                setState(() {
                  _pastedText = data?.text ?? 'Nothing in clipboard';
                });
              },
              icon: const Icon(Icons.paste),
              label: const Text('Paste'),
            ),
            const SizedBox(height: 8),
            Text(
              _pastedText,
              key: const ValueKey('pasted_text'),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
