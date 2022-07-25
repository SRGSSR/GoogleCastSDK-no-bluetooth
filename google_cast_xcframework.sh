#!/bin/bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)

scheme_name="GoogleCast"
framework_name="$scheme_name.framework"

package_file_name="Package.swift"
package_file_path="$script_dir/$package_file_name"

xcframework_name="GoogleCastSDK-no-bluetooth.xcframework"
xcframework_zip_name="$xcframework_name.zip"
xcframework_path="$script_dir/$xcframework_name"

source_dir="$script_dir/GoogleCast"
binaries_dir="$script_dir/Binaries"

iphoneos_dir="$binaries_dir/GoogleCast.xcframework/ios-arm64"
iphonesimulator_dir="$binaries_dir/GoogleCast.xcframework/ios-arm64_x86_64-simulator"

iphoneos_framework="$iphoneos_dir/GoogleCast.framework"
iphonesimulator_framework="$iphonesimulator_dir/GoogleCast.framework"

iphoneos_bc_symbol_maps="$iphoneos_dir/BCSymbolMaps/7B32ACDD-A45F-3B68-9E8A-BC0CF485C973.bcsymbolmap"

appletvos_archive="$source_dir/archives/appletvos.xcarchive"
appletvsimulator_archive="$source_dir/archives/appletvsimulator.xcarchive"

xcarchive_framework="Products/Library/Frameworks/$framework_name"

zip_file_path="$1"
if [ ! -f "$zip_file_path" ]; then
    echo "Please provide a Google Cast SDK dynamic XCFramework zip downloaded from https://developers.google.com/cast/docs/ios_sender#xcframework_beta."
    exit 0
fi

if ! unzip -d "$binaries_dir" "$zip_file_path" > /dev/null; then
    echo "Failed to extract Google Cast binaries."
fi

pushd "$source_dir" > /dev/null || exit

echo "Building appletvos variant..."
xcodebuild clean archive -scheme $scheme_name -sdk appletvos -archivePath $appletvos_archive SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES &> /dev/null

echo "Building appletvsimulator variant..."
xcodebuild clean archive -scheme $scheme_name -sdk appletvsimulator -archivePath $appletvsimulator_archive SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES &> /dev/null

popd > /dev/null || exit

xcodebuild -create-xcframework \
    -framework "$iphoneos_framework" \
    -debug-symbols "$iphoneos_bc_symbol_maps" \
    -framework "$iphonesimulator_framework" \
    -framework "$appletvos_archive/$xcarchive_framework" \
    -framework "$appletvsimulator_archive/$xcarchive_framework" \
    -output "$xcframework_path" # &> /dev/null

echo "Cleanup files..."
rm -rf "$source_dir/archives"
rm -rf "$binaries_dir"

zip -r "$xcframework_zip_name" "$xcframework_name" > /dev/null
rm -rf "$xcframework_name"

xcframework_zip_path="$script_dir/$xcframework_zip_name"
if [ ! -f "$xcframework_zip_path" ]; then
    echo "XCFramework creation failed."
    exit 1
fi

# Currently a Package.swift file must be found for the swift package command to succeed
dummy_package_file_created=false
if [ ! -f "$package_file_path" ]; then
    touch "$package_file_path"
    dummy_package_file_created=true
fi

hash=$(swift package compute-checksum "$xcframework_zip_name")

if ! $dummy_package_file_created; then
    old_hash=$(grep 'checksum: String =' "$package_file_path")
    old_hash="$(echo -e "${old_hash}" | sed -e 's/^[[:space:]]*//')"

    new_hash="static let checksum: String = \"$hash\""
    sed -i "" "s/$old_hash/$new_hash/g" "$package_file_path" # -i "" on BSD, -i -e on GNU

    saved_information=", saved in $package_file_name"
fi

echo ""
echo "The XCFramework zip is saved at $xcframework_zip_path."
echo "The XCFramework zip hash is $hash$saved_information."
echo ""
echo "Please keep the zip and its hash in a safe place, as regenerating a new zip will produce a new hash."
echo "The Package.swift file was automatically updated with the new hash, please manually commit the changes."

if $dummy_package_file_created; then
    rm "$package_file_path"
fi