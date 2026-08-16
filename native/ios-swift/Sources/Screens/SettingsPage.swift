import SwiftUI

/// Mirrors lib/features/settings/presentation/pages/settings_page.dart.
struct SettingsPage: View {
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var snackbar: SnackbarCenter

    var body: some View {
        List {
            Toggle("Dark Mode", isOn: $settings.darkMode)
                .accessibilityIdentifier("dark_mode_toggle")

            Toggle("Notifications", isOn: $settings.notifications)
                .accessibilityIdentifier("notifications_toggle")

            Toggle("Agree to Terms", isOn: $settings.termsAccepted)
                .accessibilityIdentifier("terms_checkbox")

            Picker("Language", selection: $settings.language) {
                ForEach(SettingsStore.languages, id: \.self) { language in
                    Text(language).tag(language)
                }
            }
            .accessibilityIdentifier("language_dropdown")

            Button {
                settings.savePreferences()
                snackbar.show("Settings saved")
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("save_button")
            .listRowInsets(EdgeInsets())
            .padding()
            .listRowSeparator(.hidden)

            Button {
                // Permanently disabled, matching the Flutter twin (onPressed: null).
            } label: {
                Text("Delete Account")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.gray)
            .disabled(true)
            .accessibilityIdentifier("delete_button")
            .listRowInsets(EdgeInsets())
            .padding()
            .listRowSeparator(.hidden)

            Text("Build: 1.0.42+dev")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier("build_info")
                .listRowInsets(EdgeInsets())
                .padding(.top, 8)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
