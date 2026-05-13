import 'package:flutter/material.dart';
import 'package:flutter_probe_agent/flutter_probe_agent.dart';

/// Exercises FlutterProbe v0.9.9's `deliver signal "name"` step.
///
/// Three buttons each start an async operation that would normally block on
/// an OS-level prompt (push permission, payment, deep link). In PROBE_AGENT
/// mode they block on [awaitSignal] instead, letting the test script resolve
/// them with `deliver signal` at the right moment.
class SignalDemoPage extends StatefulWidget {
  const SignalDemoPage({super.key});

  @override
  State<SignalDemoPage> createState() => _SignalDemoPageState();
}

class _SignalDemoPageState extends State<SignalDemoPage> {
  String _status = '';
  bool _busy = false;

  Future<void> _requestPushPermission() async {
    setState(() { _busy = true; _status = 'Waiting for permission…'; });
    if (const bool.fromEnvironment('PROBE_AGENT')) {
      final granted = await awaitSignal('push_permission');
      if (!mounted) return;
      setState(() {
        _busy = false;
        _status = granted == 'true' ? 'Notifications enabled' : 'Permission denied';
      });
    } else {
      // Real implementation would call firebase_messaging / permission_handler.
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() { _busy = false; _status = 'Notifications enabled'; });
    }
  }

  Future<void> _startPayment() async {
    setState(() { _busy = true; _status = 'Payment in progress…'; });
    if (const bool.fromEnvironment('PROBE_AGENT')) {
      final result = await awaitSignal('payment_result');
      if (!mounted) return;
      setState(() {
        _busy = false;
        _status = result == 'success' ? 'Payment confirmed' : 'Payment failed';
      });
    } else {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() { _busy = false; _status = 'Payment confirmed'; });
    }
  }

  Future<void> _openDeepLink() async {
    setState(() { _busy = true; _status = 'Opening link…'; });
    if (const bool.fromEnvironment('PROBE_AGENT')) {
      final target = await awaitSignal('deep_link');
      if (!mounted) return;
      setState(() {
        _busy = false;
        _status = 'Opened: $target';
      });
    } else {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() { _busy = false; _status = 'Opened: https://example.com'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signal Demo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            ElevatedButton(
              key: const ValueKey('request_push_permission'),
              onPressed: _busy ? null : _requestPushPermission,
              child: const Text('Request Push Permission'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              key: const ValueKey('start_payment'),
              onPressed: _busy ? null : _startPayment,
              child: const Text('Start Payment'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              key: const ValueKey('open_deep_link'),
              onPressed: _busy ? null : _openDeepLink,
              child: const Text('Open Deep Link'),
            ),
            if (_busy) ...[
              const SizedBox(height: 24),
              const Center(
                child: CircularProgressIndicator(
                  key: ValueKey('signal_progress'),
                ),
              ),
            ],
            if (_status.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                _status,
                key: const ValueKey('signal_status'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
