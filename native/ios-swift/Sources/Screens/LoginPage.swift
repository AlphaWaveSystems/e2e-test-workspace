import SwiftUI

/// Mirrors lib/features/auth/presentation/pages/login_page.dart.
struct LoginPage: View {
    @EnvironmentObject var auth: AuthStore
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var snackbar: SnackbarCenter

    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer().frame(height: 48)

                Image(systemName: "lock")
                    .font(.system(size: 80))
                    .foregroundColor(.accentColor)

                TextField("Enter your email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.horizontal, 24)
                    .accessibilityIdentifier("email_field")

                SecureField("Enter your password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 24)
                    .accessibilityIdentifier("password_field")

                if let error = auth.error {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .accessibilityIdentifier("error_message")
                }

                if auth.isLoading {
                    ProgressView()
                        .accessibilityIdentifier("loading_indicator")
                        .padding(.top, 8)
                } else {
                    Button(action: handleSignIn) {
                        Text("Sign In")
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 24)
                    .accessibilityIdentifier("sign_in_button")
                }

                Button("Forgot Password?") {
                    snackbar.show("Password reset not implemented")
                }
                .accessibilityIdentifier("forgot_password")

                Spacer()
            }
        }
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func handleSignIn() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        Task {
            let success = await auth.login(email: trimmedEmail, password: password)
            if success {
                router.replaceStackWithDashboard()
            }
        }
    }
}
