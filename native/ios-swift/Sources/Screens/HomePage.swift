import SwiftUI

/// Mirrors lib/navigation/home_page.dart — a 3-tab shell (Home/Tests/About)
/// with a AppBar title that persists across all three tabs.
struct HomePage: View {
    @EnvironmentObject var router: AppRouter
    @State private var selectedTab: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selectedTab {
                case 0: homeTab
                case 1: testsTab
                default: aboutTab
                }
            }
            .frame(maxHeight: .infinity)
            Divider()
            tabBar
        }
        .navigationTitle("FlutterProbe Test App")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }

    // MARK: Home tab

    private var homeTab: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    Text("Welcome to the FlutterProbe Test App")
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.top, 24)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 24)
                        .accessibilityIdentifier("welcome_text")

                    navRow(key: "nav_login", icon: "arrow.right.to.line.circle", label: "Login") {
                        router.push(.login)
                    }
                    navRow(key: "nav_biometric", icon: "faceid", label: "Biometric Login") {
                        router.push(.biometric)
                    }
                    navRow(key: "nav_signal", icon: "bell.badge", label: "Signal Demo") {
                        router.push(.signal)
                    }
                    navRow(key: "nav_dashboard", icon: "gauge", label: "Dashboard") {
                        router.push(.dashboard)
                    }
                    navRow(key: "nav_settings", icon: "gearshape", label: "Settings") {
                        router.push(.settings)
                    }
                    navRow(key: "nav_items", icon: "list.bullet", label: "Items") {
                        router.push(.items)
                    }
                    navRow(key: "nav_gestures", icon: "hand.tap", label: "Gestures") {
                        router.push(.gestures)
                    }
                    navRow(key: "nav_api", icon: "network", label: "API Tests") {
                        router.push(.api)
                    }
                    navRow(key: "nav_device", icon: "iphone", label: "Device") {
                        router.push(.device)
                    }
                    navRow(key: "nav_visual", icon: "eye", label: "Visual") {
                        router.push(.visual)
                    }
                    navRow(key: "nav_dynamic", icon: "waveform.path", label: "Dynamic") {
                        router.push(.dynamicScreen)
                    }
                }
            }
            Text("Version 1.0")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .padding(.vertical, 8)
                .accessibilityIdentifier("version_text")
        }
    }

    private func navRow(key: String, icon: String, label: String, action: @escaping () -> Void) -> some View {
        VStack(spacing: 0) {
            Button(action: action) {
                HStack {
                    Image(systemName: icon)
                        .frame(width: 28)
                    Text(label)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier(key)
            Divider().padding(.leading, 16)
        }
    }

    // MARK: Tests / About tabs

    private var testsTab: some View {
        Text("Test Suites")
            .font(.system(size: 18))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .accessibilityIdentifier("tests_tab_content")
    }

    private var aboutTab: some View {
        Text("About FlutterProbe Test App")
            .font(.system(size: 18))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .accessibilityIdentifier("about_tab_content")
    }

    // MARK: Bottom tab bar

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabButton(index: 0, key: "tab_home", iconKey: "tab_home_icon", icon: "house.fill", label: "Home")
            tabButton(index: 1, key: "tab_tests", iconKey: "tab_tests_icon", icon: "testtube.2", label: "Tests")
            tabButton(index: 2, key: "tab_about", iconKey: "tab_about_icon", icon: "info.circle.fill", label: "About")
        }
        .padding(.vertical, 8)
        .background(.bar)
    }

    private func tabButton(index: Int, key: String, iconKey: String, icon: String, label: String) -> some View {
        Button {
            selectedTab = index
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .accessibilityIdentifier(iconKey)
                Text(label)
                    .font(.caption2)
            }
            .foregroundColor(selectedTab == index ? .accentColor : .gray)
            .frame(maxWidth: .infinity)
        }
        .accessibilityIdentifier(key)
    }
}
