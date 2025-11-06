import SwiftUI

public enum AppColor {
    // MARK: - Backgrounds
    public static let backgroundPrimary = Color(hex: "#0D0D0D")
    public static let backgroundSecondary = Color(hex: "#141414")
    public static let cardBackground = Color(hex: "#1A1A1A")

    // MARK: - Text
    public static let textPrimary = Color(hex: "#FFFFFF")
    public static let textSecondary = Color(hex: "#A3A3A3")

    // MARK: - Accents
    public static let accentGreen = Color(hex: "#3DDC84")
    public static let accentYellow = Color(hex: "#E5FF78")
    public static let accentRed = Color(hex: "#FF4D4D")

    // MARK: - Chart
    public static let chartLine = Color(hex: "#FFD84C")

    // MARK: - Shadows
    public static let softShadow = Color.black.opacity(0.4)
}

public extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
