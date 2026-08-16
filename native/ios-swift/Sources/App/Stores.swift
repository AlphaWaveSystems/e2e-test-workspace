import Foundation
import SwiftUI

// MARK: - Auth (mirrors lib/features/auth/presentation/providers/auth_provider.dart
// and lib/features/auth/data/datasources/auth_remote_datasource.dart)

struct AppUser: Equatable {
    let id: Int
    let name: String
    let email: String
}

@MainActor
final class AuthStore: ObservableObject {
    @Published private(set) var currentUser: AppUser? = nil
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: String? = nil

    var isAuthenticated: Bool { currentUser != nil }

    /// Exact-match, case-sensitive credentials from auth_remote_datasource.dart.
    private static let validCredentials: [(email: String, password: String, user: AppUser)] = [
        ("test@test.com", "password", AppUser(id: 1, name: "Test User", email: "test@test.com")),
        ("admin@test.com", "admin123", AppUser(id: 2, name: "Admin User", email: "admin@test.com")),
    ]

    /// Mirrors the 1000ms Future.delayed in AuthRemoteDatasource.login.
    func login(email: String, password: String) async -> Bool {
        isLoading = true
        error = nil
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        if let match = Self.validCredentials.first(where: { $0.email == email && $0.password == password }) {
            currentUser = match.user
            isLoading = false
            return true
        } else {
            error = "Invalid email or password"
            isLoading = false
            return false
        }
    }

    /// Mirrors AuthProvider.loginWithBiometrics() — synthetic user, no delay.
    func loginWithBiometrics() {
        currentUser = AppUser(id: -1, name: "Biometric User", email: "biometric@local")
        error = nil
    }

    func logout() {
        currentUser = nil
        error = nil
    }
}

// MARK: - Settings (mirrors lib/features/settings/presentation/providers/settings_provider.dart)

@MainActor
final class SettingsStore: ObservableObject {
    static let languages = ["English", "Spanish", "French", "German", "Japanese"]

    @Published var darkMode: Bool = false
    @Published var notifications: Bool = true
    @Published var termsAccepted: Bool = false
    @Published var language: String = "English"

    /// Mirrors SettingsProvider.savePreferences() — a no-op round trip in the
    /// Flutter app (no disk persistence despite shared_preferences dependency).
    func savePreferences() {
        // Intentionally a no-op, matching the Flutter twin's behavior.
    }
}

// MARK: - Snackbar (mirrors Flutter's ScaffoldMessenger.showSnackBar)

@MainActor
final class SnackbarCenter: ObservableObject {
    @Published private(set) var message: String? = nil
    private var dismissTask: Task<Void, Never>?

    func show(_ text: String) {
        dismissTask?.cancel()
        message = text
        dismissTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            if !Task.isCancelled {
                message = nil
            }
        }
    }
}

struct SnackbarOverlay: View {
    @EnvironmentObject var center: SnackbarCenter

    var body: some View {
        VStack {
            Spacer()
            if let message = center.message {
                Text(message)
                    .padding()
                    .background(Color.black.opacity(0.85))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.bottom, 24)
                    .accessibilityIdentifier("snackbar_message")
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .allowsHitTesting(false)
            }
        }
        .animation(.easeInOut, value: center.message)
    }
}

// MARK: - Items (mirrors lib/features/items/presentation/providers/item_provider.dart)

struct AppItem: Identifiable, Equatable {
    let id: Int
    let title: String
    let description: String
}

@MainActor
final class ItemsStore: ObservableObject {
    @Published private(set) var allItems: [AppItem]
    @Published private(set) var filteredItems: [AppItem]
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var searchQuery: String = ""

    init() {
        let generated = Self.generateItems()
        allItems = generated
        filteredItems = generated
    }

    private static func generateItems() -> [AppItem] {
        (0..<50).map { AppItem(id: $0, title: "Item \($0)", description: "Description for item \($0)") }
    }

    /// Mirrors ItemProvider.fetchItems() — 300ms delayed regeneration.
    /// Nothing in the current UI calls this (no pull-to-refresh), kept for parity.
    func fetchItems() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 300_000_000)
        allItems = Self.generateItems()
        applySearch()
        isLoading = false
    }

    func search(_ query: String) {
        searchQuery = query
        applySearch()
    }

    private func applySearch() {
        if searchQuery.isEmpty {
            filteredItems = allItems
        } else {
            let needle = searchQuery.lowercased()
            filteredItems = allItems.filter { $0.title.lowercased().contains(needle) }
        }
    }

    func deleteItem(id: Int) {
        allItems.removeAll { $0.id == id }
        applySearch()
    }
}

// MARK: - Signal demo (mirrors lib/features/signal/presentation/pages/signal_demo_page.dart)
//
// The Flutter screen branches on `bool.fromEnvironment('PROBE_AGENT')`: under the
// probe agent it awaits an RPC-delivered signal; otherwise it falls back to a fixed
// delay + happy-path result. This native twin has no probe-agent socket bridge yet
// (iOS N-2 XCTest bridging is unimplemented — see native_suite.probe), so it always
// takes the non-agent fallback branch, matching Flutter's non-agent behavior exactly.

@MainActor
final class SignalStore: ObservableObject {
    @Published private(set) var busy: Bool = false
    @Published private(set) var status: String = ""

    func requestPushPermission() async {
        guard !busy else { return }
        busy = true
        status = "Waiting for permission\u{2026}"
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        status = "Notifications enabled"
        busy = false
    }

    func startPayment() async {
        guard !busy else { return }
        busy = true
        status = "Payment in progress\u{2026}"
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        status = "Payment confirmed"
        busy = false
    }

    func openDeepLink() async {
        guard !busy else { return }
        busy = true
        status = "Opening link\u{2026}"
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        status = "Opened: https://example.com"
        busy = false
    }
}
