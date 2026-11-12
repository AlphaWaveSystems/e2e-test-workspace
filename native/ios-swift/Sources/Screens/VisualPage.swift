import SwiftUI

/// Mirrors lib/features/visual/presentation/pages/visual_page.dart. Deliberately
/// deterministic (no animation, no async work) for pixel/visual-regression tests.
struct VisualPage: View {
    @State private var counter = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Visual Test")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(24)
                    .background(Color(red: 0.4, green: 0.2, blue: 0.6))
                    .cornerRadius(12)
                    .accessibilityIdentifier("visual_header")

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    colorCell("Red", .red, textColor: .white)
                    colorCell("Green", .green, textColor: .white)
                    colorCell("Blue", .blue, textColor: .white)
                    colorCell("Yellow", .yellow, textColor: .black)
                }
                .accessibilityIdentifier("color_grid")

                VStack(spacing: 12) {
                    Text("Count: \(counter)")
                        .font(.system(size: 32, weight: .bold))
                        .accessibilityIdentifier("visual_counter")

                    Button("Increment") {
                        counter += 1
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("increment_button")
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 8) {
                    Image(systemName: "photo")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("Image Placeholder")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .background(Color(.systemGray5))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                .cornerRadius(8)
                .accessibilityIdentifier("static_image")

                VStack(alignment: .leading, spacing: 8) {
                    Text("Heading 1").font(.system(size: 32, weight: .bold))
                    Text("Heading 2").font(.system(size: 24, weight: .semibold))
                    Text("Body text at 16px").font(.system(size: 16))
                    Text("Caption text at 12px").font(.system(size: 12))
                    Text("Small text at 10px").font(.system(size: 10))
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray4)))
                .accessibilityIdentifier("typography_sample")
            }
            .padding(16)
        }
        .navigationTitle("Visual")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func colorCell(_ label: String, _ color: Color, textColor: Color) -> some View {
        Text(label)
            .font(.system(size: 18))
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(color)
            .cornerRadius(8)
    }
}
