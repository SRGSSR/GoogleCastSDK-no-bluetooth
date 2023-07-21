// swift-tools-version:5.3

import PackageDescription

struct PackageMetadata {
    static let version: String = "4.8.0"
    static let checksum: String = "ae6db94f6fff7720bc28faac2f5dbd0b9c5af0215a1819c4682f7060f21eb1bb"
}

let package = Package(
    name: "GoogleCastSDK-no-bluetooth",
    platforms: [
        .iOS(.v13),
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
