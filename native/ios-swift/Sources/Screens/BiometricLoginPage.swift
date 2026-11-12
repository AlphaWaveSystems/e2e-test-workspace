import SwiftUI
import LocalAuthentication

/// Mirrors lib/features/auth/presentation/pages/biometric_login_page.dart.
///
/// Unlike the Flutter twin's PROBE_AGENT branch (which awaits an RPC-delivered
/// bool from flutter-probe's `biometric match` / `biometric no match` steps),
/// this native screen always uses real LocalAuthentication as instructed —
/// flutter-probe drives Face ID/Touch ID match outcomes directly at the iOS
/// Simulator level via `xcrun simctl ... notifyutil`, independent of the app,
/// so real LAContext usage is compatible with those verbs once the N-2 XCTest
/// bridge lands and can drive taps/waits against this screen.
struct BiometricLoginPage: View {
    @EnvironmentObject var auth: AuthStore
    @EnvironmentObject var router: AppRouter

    @State private var busy = false
    @State private var error: String? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer().frame(height: 48)

                Image(systemName: "faceid")
                    .font(.system(size: 96))

                Text("Use your face or fingerprint to sign in.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .accessibilityIdentifier("biometric_prompt_intro")

                Button(action: signIn) {
                    Label("Sign in with Face ID", systemImage: "faceid")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                }
                .buttonStyle(.borderedProminent)
                .disabled(busy)
                .accessibilityIdentifier("sign_in_with_face_id")

                if busy {
                    ProgressView()
                        .padding(.top, 8)
                        .accessibilityIdentifier("biometric_progress")
                }

                if let error = error {
                    Text(error)
                        .foregroundColor(Color(red: 0.6, green: 0, blue: 0))
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.red.opacity(0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 24)
                        .accessibilityIdentifier("biometric_error_banner")
                }

                Spacer()
            }
        }
        .navigationTitle("Biometric Login")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func signIn() {
        busy = true
        error = nil
        let context = LAContext()
        var policyError: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &policyError) else {
            busy = false
            self.error = "Authentication failed"
            return
        }

        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Sign in to your account"
        ) { success, _ in
            DispatchQueue.main.async {
                if success {
                    auth.loginWithBiometrics()
                    router.replaceStackWithDashboard()
                } else {
                    busy = false
                    error = "Authentication failed"
                }
            }
        }
    }
}
