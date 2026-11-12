import SwiftUI

/// A lightweight stand-in for Flutter's `Dismissible` widget: a single continuous
/// drag past a threshold fully dismisses the row, rather than SwiftUI's native
/// two-step swipeActions (reveal, then tap a button). This matches the gesture
/// shape ProbeScript's `swipe left on #key` / `swipe right` verbs expect.
struct SwipeToDismissModifier: ViewModifier {
    enum Direction {
        case leftOnly
        case horizontal
    }

    let direction: Direction
    let onDismiss: () -> Void

    @State private var offsetX: CGFloat = 0
    @State private var isGone = false

    private let threshold: CGFloat = 90

    func body(content: Content) -> some View {
        ZStack {
            if offsetX != 0 {
                HStack {
                    if offsetX < 0 { Spacer() }
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                    if offsetX > 0 { Spacer() }
                }
                .frame(maxWidth: .infinity)
                .background(Color.red)
            }
            content
                .offset(x: offsetX)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let dx = value.translation.width
                            switch direction {
                            case .leftOnly:
                                offsetX = min(0, dx)
                            case .horizontal:
                                offsetX = dx
                            }
                        }
                        .onEnded { value in
                            let dx = value.translation.width
                            let dismissedLeft = direction == .leftOnly && dx < -threshold
                            let dismissedEither = direction == .horizontal && abs(dx) > threshold
                            if dismissedLeft || dismissedEither {
                                withAnimation(.easeOut) {
                                    offsetX = dx < 0 ? -600 : 600
                                    isGone = true
                                }
                                onDismiss()
                            } else {
                                withAnimation(.spring()) { offsetX = 0 }
                            }
                        }
                )
        }
        .opacity(isGone ? 0 : 1)
        .clipped()
    }
}

extension View {
    func swipeToDismiss(direction: SwipeToDismissModifier.Direction, onDismiss: @escaping () -> Void) -> some View {
        modifier(SwipeToDismissModifier(direction: direction, onDismiss: onDismiss))
    }
}
