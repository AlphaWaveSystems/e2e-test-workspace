import SwiftUI

/// Mirrors lib/features/gestures/presentation/pages/gestures_page.dart.
struct GesturesPage: View {
    @State private var gestureCount = 0
    @State private var doubleTapCount = 0
    @State private var dragAccepted = false
    @State private var swipeCardVisible = true
    @State private var showContextMenu = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Gesture Count: \(gestureCount)")
                    .font(.headline)
                    .accessibilityIdentifier("gesture_count")
                    .padding(.bottom, 16)

                Text("Drag & Drop").bold()
                HStack {
                    Spacer()
                    Text("Drag")
                        .frame(width: 80, height: 80)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .accessibilityIdentifier("drag_source")
                        .draggable("blue_box") {
                            Text("Drag")
                                .frame(width: 80, height: 80)
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                        }
                    Spacer()
                    Text(dragAccepted ? "Done!" : "Drop")
                        .frame(width: 80, height: 80)
                        .background(dragAccepted ? Color.green.opacity(0.6) : Color.green)
                        .foregroundColor(.white)
                        .accessibilityIdentifier("drag_target")
                        .dropDestination(for: String.self) { _, _ in
                            dragAccepted = true
                            gestureCount += 1
                            return true
                        }
                    Spacer()
                }
                .padding(.vertical, 8)

                Text("Double Tap").bold().padding(.top, 24)
                Text("Double taps: \(doubleTapCount)")
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background(Color.orange.opacity(0.2))
                    .accessibilityIdentifier("double_tap_area")
                    .onTapGesture(count: 2) {
                        doubleTapCount += 1
                        gestureCount += 1
                    }

                Text("Long Press").bold().padding(.top, 24)
                ZStack(alignment: .topLeading) {
                    Text("Long press me")
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .background(Color.purple.opacity(0.2))
                        .accessibilityIdentifier("long_press_area")
                        .onLongPressGesture {
                            gestureCount += 1
                            showContextMenu = true
                        }
                    if showContextMenu {
                        VStack(alignment: .leading, spacing: 0) {
                            Button("Copy") { showContextMenu = false }
                                .padding(10)
                            Divider()
                            Button("Delete") { showContextMenu = false }
                                .padding(10)
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .shadow(radius: 6)
                        .offset(x: 24, y: 24)
                        .zIndex(1)
                    }
                }

                Text("Swipe Card").bold().padding(.top, 24)
                if swipeCardVisible {
                    HStack {
                        Image(systemName: "arrow.left.and.right")
                        Text("Swipe me to dismiss")
                        Spacer()
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .accessibilityIdentifier("swipe_card")
                    .swipeToDismiss(direction: .horizontal) {
                        swipeCardVisible = false
                        gestureCount += 1
                    }
                } else {
                    Text("Card dismissed!")
                }
            }
            .padding(16)
        }
        .navigationTitle("Gestures")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            showContextMenu = false
        }
    }
}
