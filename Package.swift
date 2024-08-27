// swift-tools-version:5.3

import PackageDescription

struct PackageMetadata {
    static let version: String = "4.8.3"
    static let checksum: String = "bc2c3c2434ef2895a0388ac3f16932242d3d3ac11805f810dbe7d7bce3bb27f6"
}

let package = Package(
    name: "GoogleCastSDK-no-bluetooth",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "GoogleCastSDK-no-bluetooth",
            targets: ["GoogleCastSDK-no-bluetooth"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "GoogleCastSDK-no-bluetooth",
            url: "https://github.com/SRGSSR/GoogleCastSDK-no-bluetooth/releases/download/\(PackageMetadata.version)/GoogleCastSDK-no-bluetooth.xcframework.zip",
            checksum: PackageMetadata.checksum
        )
    ]
)
