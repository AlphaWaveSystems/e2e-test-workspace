import SwiftUI

/// Mirrors lib/features/auth/presentation/pages/dashboard_page.dart.
struct DashboardPage: View {
    @EnvironmentObject var auth: AuthStore
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var snackbar: SnackbarCenter

    private var userName: String { auth.currentUser?.name ?? "Guest" }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome, \(userName)")
                        .font(.title3.bold())
                    Text("Here is your dashboard overview")
                        .font(.subheadline)
                        .opacity(0.7)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.accentColor.opacity(0.15))
                .cornerRadius(12)
                .accessibilityIdentifier("welcome_banner")
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

                HStack(spacing: 8) {
                    statCard(key: "stat_card_1", value: "42", title: "Tests Run", icon: "checkmark.circle.fill")
                    statCard(key: "stat_card_2", value: "38", title: "Passed", icon: "hand.thumbsup.fill")
                    statCard(key: "stat_card_3", value: "4", title: "Failed", icon: "exclamationmark.circle")
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

                Text("Recent Items")
                    .font(.headline)
                    .padding(.top, 24)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
            }

            ForEach(0..<10, id: \.self) { index in
                Button {
                    snackbar.show("Tapped item \(index + 1)")
                } label: {
                    HStack {
                        Text("\(index + 1)")
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(Color.accentColor.opacity(0.2)))
                        VStack(alignment: .leading) {
                            Text("Item \(index + 1)")
                            Text("Description for item \(index + 1)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("item_\(index)")
            }
        }
        .listStyle(.plain)
        .refreshable {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    snackbar.show("Refreshed")
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .accessibilityIdentifier("refresh_button")
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    auth.logout()
                    router.popToHome()
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
                .accessibilityIdentifier("logout_button")
            }
        }
    }

    private func statCard(key: String, value: String, title: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
            Text(value)
                .font(.title2.bold())
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .accessibilityIdentifier(key)
    }
}
