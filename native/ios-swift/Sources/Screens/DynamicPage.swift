import SwiftUI

/// Mirrors lib/features/dynamic/presentation/pages/dynamic_page.dart.
struct DynamicPage: View {
    @State private var showAbBanner = Bool.random()
    @State private var countdown = 10
    @State private var actionCount = 0
    @State private var fadeOpacity: Double = 0
    @State private var showErrorDialog = false
    @State private var timer: Timer? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if showAbBanner {
                    Text("Special Offer!")
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(16)
                        .background(Color.orange.opacity(0.3))
                        .cornerRadius(8)
                        .accessibilityIdentifier("ab_banner")
                }

                Text("Countdown").font(.system(size: 18, weight: .bold))
                Text("\(countdown)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(countdown <= 3 ? .red : .primary)
                    .frame(maxWidth: .infinity)
                    .accessibilityIdentifier("countdown")

                Text("Fade Animation").font(.system(size: 18, weight: .bold))
                Text("I faded in!")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background(Color.teal)
                    .cornerRadius(8)
                    .opacity(fadeOpacity)
                    .accessibilityIdentifier("fade_widget")

                Text("Error Handling").font(.system(size: 18, weight: .bold))
                Button("Trigger Error") {
                    showErrorDialog = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .accessibilityIdentifier("trigger_error")

                Text("Repeatable Action").font(.system(size: 18, weight: .bold))
                Button("Tap Me") {
                    actionCount += 1
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("repeat_action")
                Text("Tapped: \(actionCount)")
                    .accessibilityIdentifier("action_count")
            }
            .padding(16)
        }
        .navigationTitle("Dynamic")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $showErrorDialog) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Something went wrong!")
        }
        .onAppear {
            withAnimation(.easeIn(duration: 2)) {
                fadeOpacity = 1
            }
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
                DispatchQueue.main.async {
                    if countdown > 0 {
                        countdown -= 1
                    } else {
                        t.invalidate()
                    }
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
}
