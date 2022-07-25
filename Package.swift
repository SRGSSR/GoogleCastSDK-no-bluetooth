// swift-tools-version:5.3

import PackageDescription

struct PackageMetadata {
    static let version: String = "4.7.1-beta.1"
    static let checksum: String = "cb4bfb426ee381c2b42ca7d7d96d3081da315af6d84b53c4dff52fa9edf66c9a"
}

let package = Package(
    name: "GoogleCastSDK-no-bluetooth",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12)
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
