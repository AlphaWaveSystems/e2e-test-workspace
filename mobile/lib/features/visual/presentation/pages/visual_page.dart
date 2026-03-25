import 'package:flutter/material.dart';

class VisualPage extends StatefulWidget {
  const VisualPage({super.key});

  @override
  State<VisualPage> createState() => _VisualPageState();
}

class _VisualPageState extends State<VisualPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visual'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Static header
            Container(
              key: const ValueKey('visual_header'),
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Visual Test',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Color grid
            GridView.count(
              key: const ValueKey('color_grid'),
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Red',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Green',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Blue',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Yellow',
                      style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Counter
            Center(
              child: Text(
                'Count: $_counter',
                key: const ValueKey('visual_counter'),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                key: const ValueKey('increment_button'),
                onPressed: () {
                  setState(() {
                    _counter++;
                  });
                },
                child: const Text('Increment'),
              ),
            ),
            const SizedBox(height: 24),

            // Static image placeholder
            Container(
              key: const ValueKey('static_image'),
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Image Placeholder',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Typography sample
            Container(
              key: const ValueKey('typography_sample'),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Heading 1',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Heading 2',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Text('Body text at 16px', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Caption text at 12px', style: TextStyle(fontSize: 12)),
                  SizedBox(height: 8),
                  Text('Small text at 10px', style: TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
