import SwiftUI

/// Mirrors lib/features/signal/presentation/pages/signal_demo_page.dart.
/// See Stores.swift SignalStore doc comment re: why this always takes the
/// Flutter twin's non-agent fallback branch.
struct SignalDemoPage: View {
    @EnvironmentObject var signal: SignalStore

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Spacer().frame(height: 24)

                Button("Request Push Permission") {
                    Task { await signal.requestPushPermission() }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .disabled(signal.busy)
                .accessibilityIdentifier("request_push_permission")

                Button("Start Payment") {
                    Task { await signal.startPayment() }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .disabled(signal.busy)
                .accessibilityIdentifier("start_payment")

                Button("Open Deep Link") {
                    Task { await signal.openDeepLink() }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .disabled(signal.busy)
                .accessibilityIdentifier("open_deep_link")

                if signal.busy {
                    ProgressView()
                        .padding(.top, 24)
                        .accessibilityIdentifier("signal_progress")
                }

                if !signal.status.isEmpty {
                    Text(signal.status)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(.top, 24)
                        .accessibilityIdentifier("signal_status")
                }
            }
            .padding(24)
        }
        .navigationTitle("Signal Demo")
        .navigationBarTitleDisplayMode(.inline)
    }
}
