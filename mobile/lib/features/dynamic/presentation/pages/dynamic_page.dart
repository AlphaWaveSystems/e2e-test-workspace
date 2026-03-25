import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class DynamicPage extends StatefulWidget {
  const DynamicPage({super.key});

  @override
  State<DynamicPage> createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage>
    with SingleTickerProviderStateMixin {
  late final bool _showAbBanner;
  int _countdown = 10;
  Timer? _timer;
  int _actionCount = 0;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _showAbBanner = Random().nextBool();

    // Start countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
      }
    });

    // Fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        key: const ValueKey('error_dialog'),
        title: const Text('Error'),
        content: const Text('Something went wrong!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A/B Banner
            if (_showAbBanner)
              Container(
                key: const ValueKey('ab_banner'),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Special Offer!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Countdown timer
            const Text('Countdown',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '$_countdown',
                key: const ValueKey('countdown'),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: _countdown <= 3 ? Colors.red : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Fade-in widget
            const Text('Fade Animation',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                key: const ValueKey('fade_widget'),
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'I faded in!',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Trigger error
            const Text('Error Handling',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            ElevatedButton(
              key: const ValueKey('trigger_error'),
              onPressed: _showErrorDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Trigger Error'),
            ),
            const SizedBox(height: 24),

            // Repeatable action
            const Text('Repeatable Action',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            ElevatedButton(
              key: const ValueKey('repeat_action'),
              onPressed: () {
                setState(() {
                  _actionCount++;
                });
              },
              child: const Text('Tap Me'),
            ),
            const SizedBox(height: 8),
            Text(
              'Tapped: $_actionCount',
              key: const ValueKey('action_count'),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
