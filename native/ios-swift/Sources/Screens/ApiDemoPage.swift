import SwiftUI

/// Mirrors the inline `_ApiPage` in app.dart, reached via the "API Tests" home
/// tile. AppBar/nav title is "API Demo" — note this differs from the route's
/// nav-tile label "API Tests", matching the Flutter twin exactly.
struct ApiDemoPage: View {
    @State private var loading = false
    @State private var error: String? = nil
    @State private var users: [String] = []
    @State private var postResult: String? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Button("Fetch Users") {
                    Task { await fetchUsers() }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .disabled(loading)
                .accessibilityIdentifier("fetch_users_button")

                Button("Create Post") {
                    Task { await createPost() }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .disabled(loading)
                .accessibilityIdentifier("create_post_button")

                if loading {
                    ProgressView()
                        .padding(.top, 16)
                        .accessibilityIdentifier("api_loading")
                }

                if let error = error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.top, 16)
                        .accessibilityIdentifier("api_error")
                }

                if !users.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Users:").font(.system(size: 16, weight: .bold))
                        ForEach(Array(users.enumerated()), id: \.offset) { index, name in
                            Text(name)
                                .accessibilityIdentifier("user_\(index)")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 16)
                }

                if let postResult = postResult {
                    Text(postResult)
                        .foregroundColor(.green)
                        .padding(.top, 16)
                        .accessibilityIdentifier("post_result")
                }
            }
            .padding(16)
        }
        .navigationTitle("API Demo")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func fetchUsers() async {
        loading = true
        error = nil
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        users = ["Leanne Graham", "Ervin Howell", "Clementine Bauch"]
        loading = false
    }

    private func createPost() async {
        loading = true
        error = nil
        try? await Task.sleep(nanoseconds: 500_000_000)
        postResult = "Post created with id: 101"
        loading = false
    }
}
