import 'package:flutter/material.dart';

class GesturesPage extends StatefulWidget {
  const GesturesPage({super.key});

  @override
  State<GesturesPage> createState() => _GesturesPageState();
}

class _GesturesPageState extends State<GesturesPage> {
  int _doubleTapCount = 0;
  int _gestureCount = 0;
  bool _dragAccepted = false;
  bool _swipeCardVisible = true;

  void _incrementGestureCount() {
    setState(() {
      _gestureCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestures'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gesture Count: $_gestureCount',
              key: const ValueKey('gesture_count'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),

            // Drag source and target
            const Text('Drag & Drop',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Draggable<String>(
                  data: 'blue_box',
                  feedback: Container(
                    width: 80,
                    height: 80,
                    color: Colors.blue.withOpacity(0.7),
                  ),
                  childWhenDragging: Container(
                    width: 80,
                    height: 80,
                    color: Colors.blue.withOpacity(0.3),
                  ),
                  onDragCompleted: _incrementGestureCount,
                  child: Container(
                    key: const ValueKey('drag_source'),
                    width: 80,
                    height: 80,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: const Text(
                      'Drag',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    setState(() {
                      _dragAccepted = true;
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      key: const ValueKey('drag_target'),
                      width: 80,
                      height: 80,
                      color: _dragAccepted ? Colors.greenAccent : Colors.green,
                      alignment: Alignment.center,
                      child: Text(
                        _dragAccepted ? 'Done!' : 'Drop',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Double tap area
            const Text('Double Tap',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              key: const ValueKey('double_tap_area'),
              onDoubleTap: () {
                setState(() {
                  _doubleTapCount++;
                });
                _incrementGestureCount();
              },
              child: Container(
                width: double.infinity,
                height: 80,
                color: Colors.orange.shade100,
                alignment: Alignment.center,
                child: Text(
                  'Double taps: $_doubleTapCount',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Long press area
            const Text('Long Press',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              key: const ValueKey('long_press_area'),
              onLongPressStart: (details) {
                _incrementGestureCount();
                final overlay = Overlay.of(context).context.findRenderObject()
                    as RenderBox;
                showMenu(
                  context: context,
                  position: RelativeRect.fromRect(
                    details.globalPosition & const Size(1, 1),
                    Offset.zero & overlay.size,
                  ),
                  items: [
                    const PopupMenuItem(
                      value: 'copy',
                      child: Text('Copy'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                );
              },
              child: Container(
                width: double.infinity,
                height: 80,
                color: Colors.purple.shade100,
                alignment: Alignment.center,
                child: const Text(
                  'Long press me',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Swipe card
            const Text('Swipe Card',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_swipeCardVisible)
              Dismissible(
                key: const ValueKey('swipe_card'),
                onDismissed: (_) {
                  setState(() {
                    _swipeCardVisible = false;
                  });
                  _incrementGestureCount();
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child:
                      const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  child: ListTile(
                    title: const Text('Swipe me to dismiss'),
                    leading: const Icon(Icons.swipe),
                  ),
                ),
              )
            else
              const Text('Card dismissed!'),
          ],
        ),
      ),
    );
  }
}
