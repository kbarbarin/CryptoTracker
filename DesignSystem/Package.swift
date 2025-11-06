// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DesignSystem",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "DesignSystem",
            type: .dynamic, // ⬅️ force un framework embarqué
            targets: ["DesignSystem"]
        )
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [],
            path: "Sources/DesignSystem",
            swiftSettings: [
                .define("SWIFT_PACKAGE"),
                .unsafeFlags(["-target", "arm64-apple-ios17.0"])
            ]
        ),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: ["DesignSystem"],
            path: "Tests/DesignSystemTests"
        )
    ]
)
