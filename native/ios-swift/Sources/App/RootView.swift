import SwiftUI

struct RootView: View {
    @StateObject private var router = AppRouter()
    @StateObject private var auth = AuthStore()
    @StateObject private var settings = SettingsStore()
    @StateObject private var items = ItemsStore()
    @StateObject private var signal = SignalStore()
    @StateObject private var snackbar = SnackbarCenter()

    var body: some View {
        ZStack {
            NavigationStack(path: $router.path) {
                HomePage()
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
            }
            SnackbarOverlay()
        }
        .environmentObject(router)
        .environmentObject(auth)
        .environmentObject(settings)
        .environmentObject(items)
        .environmentObject(signal)
        .environmentObject(snackbar)
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .login: LoginPage()
        case .biometric: BiometricLoginPage()
        case .dashboard: DashboardPage()
        case .settings: SettingsPage()
        case .items: ItemsPage()
        case .gestures: GesturesPage()
        case .api: ApiDemoPage()
        case .device: DevicePage()
        case .visual: VisualPage()
        case .dynamicScreen: DynamicPage()
        case .signal: SignalDemoPage()
        }
    }
}

#Preview {
    RootView()
}
