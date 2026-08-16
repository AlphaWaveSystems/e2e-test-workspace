import Foundation

/// Mirrors the Flutter app's named routes (lib/navigation/routes.dart).
enum AppRoute: Hashable {
    case login
    case biometric
    case dashboard
    case settings
    case items
    case gestures
    case api
    case device
    case visual
    case dynamicScreen
    case signal
}

/// Replicates the two navigation patterns the Flutter app uses:
/// - `Navigator.pushNamed` (push)
/// - `Navigator.pushNamedAndRemoveUntil(route, (r) => r.isFirst)` after
///   login / biometric success -> stack becomes [Home, Dashboard]
/// - `Navigator.pushNamedAndRemoveUntil(route, (r) => false)` after logout
///   -> stack becomes [Home]
final class AppRouter: ObservableObject {
    @Published var path: [AppRoute] = []

    func push(_ route: AppRoute) {
        path.append(route)
    }

    /// Equivalent of pushNamedAndRemoveUntil(Dashboard, (r) => r.isFirst).
    func replaceStackWithDashboard() {
        path = [.dashboard]
    }

    /// Equivalent of pushNamedAndRemoveUntil(Home, (r) => false).
    func popToHome() {
        path = []
    }
}
