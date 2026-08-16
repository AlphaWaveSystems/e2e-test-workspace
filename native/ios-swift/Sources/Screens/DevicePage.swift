import SwiftUI
import UIKit

/// Mirrors lib/features/device/presentation/pages/device_page.dart.
/// All permission simulation is UI-only, matching the Flutter twin — no real
/// permission APIs are invoked (the Flutter app doesn't use one either).
struct DevicePage: View {
    @EnvironmentObject var snackbar: SnackbarCenter

    @State private var cameraStatus = "Not requested"
    @State private var locationStatus = "Not requested"
    @State private var gpsDisplay = "Location: --"
    @State private var copyText = "Copy this text"
    @State private var pastedText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Permissions").font(.title3.bold())

                Button {
                    cameraStatus = "Granted"
                } label: {
                    Label("Request Camera", systemImage: "camera.fill")
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("request_camera")
                Text("Camera: \(cameraStatus)")
                    .accessibilityIdentifier("camera_status")
                    .padding(.bottom, 12)

                Button {
                    locationStatus = "Granted"
                    gpsDisplay = "Location: 37.7749, -122.4194"
                } label: {
                    Label("Request Location", systemImage: "location.fill")
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("request_location")
                Text("Location: \(locationStatus)")
                    .accessibilityIdentifier("location_status")
                    .padding(.bottom, 12)

                Button {
                    snackbar.show("Notification permission requested")
                } label: {
                    Label("Request Notifications", systemImage: "bell.fill")
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("request_notifications")

                Text("GPS").font(.title3.bold()).padding(.top, 24)
                Text(gpsDisplay)
                    .accessibilityIdentifier("gps_display")

                Text("Browser").font(.title3.bold()).padding(.top, 24)
                Button {
                    if let url = URL(string: "https://www.google.com") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Label("Open Website", systemImage: "safari")
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("open_browser")

                Text("Clipboard").font(.title3.bold()).padding(.top, 24)
                TextField("Text to copy", text: $copyText)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityIdentifier("copy_text_field")

                Button {
                    pastedText = UIPasteboard.general.string ?? "Nothing in clipboard"
                } label: {
                    Label("Paste", systemImage: "doc.on.clipboard")
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("paste_button")

                Text(pastedText)
                    .font(.system(size: 14))
                    .accessibilityIdentifier("pasted_text")
            }
            .padding(16)
        }
        .navigationTitle("Device")
        .navigationBarTitleDisplayMode(.inline)
    }
}
