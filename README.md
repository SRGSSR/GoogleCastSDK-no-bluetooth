GoogleCastSDK-no-bluetooth XCFramework
======================================

Until Google provides SPM support for its Google Cast SDK this repository delivers official XCFrameworks as Swift packages for easy integration into projects.

Because of a known [SPM issue](https://github.com/apple/swift-package-manager/issues/4370) XCFramework iOS binaries delivered by Google cannot be integrated into a universal (iOS / tvOS) project, at least not with [simple wrapping](https://github.com/SRGSSR/GoogleCastSDK-ios-no-bluetooth).

This repository provides a workaround for this issue by building dummy tvOS binaries and integrating them into the original XCFramework.

## Integration

Use [Swift Package Manager](https://swift.org/package-manager) directly [within Xcode](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app). You can also declare the library as a dependency of another one directly in the associated `Package.swift` manifest.

## Generation

1. Download the _dynamic without Guest Mode_ binary from the [GoogleCastSDK manual setup](https://developers.google.com/cast/docs/ios_sender#manual_setup).
2. Use the script to package the framework, providing the zip file path as parameter: `$ ./google_cast_xcframework.sh /path/to/zip`.

If everything goes well a zip of the XCFramework will be generated where the script was executed, with the corresponding checksum displayed and inserted into the `Package.swift` available at the same location. **You should save the binary zip and the checksum somewhere safe.**

### Make the XCFramework available

To make the generated framework available:

1. Update the `Package.swift` in this repository with the framework version number. The checksum has been automatically inserted when running the script, see above.
2. Commit the changes on `master` and create a corresponding tag.
3. Push the commit and the tag to GitHub.
4. Attach the binary to the tag on GitHub.

Do not commit the binaries in the repository, as this would slow done checkouts made by SPM as the repostory grows.