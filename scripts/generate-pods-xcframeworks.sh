#! /bin/bash

set -eu

PODS_PROJECT=Pods/Pods.xcodeproj
DESTINATION_IOS_SIMULATOR='generic/platform=iOS Simulator'
DESTINATION_IOS='generic/platform=iOS'
CONFIGURATION=Release
ARCHIVE_PATH_PODS=build/Pods
ARCHIVE_FILE_IOS_SIMULATOR=iOS-Simulator.xcarchive
ARCHIVE_FILE_IOS=iOS.xcarchive
XCFRAMEWORK_OUTPUT=build

create-xcframework() {
    scheme_name=$1
    archive_path_ios="$ARCHIVE_PATH_PODS/$scheme_name/$ARCHIVE_FILE_IOS"
    archive_path_ios_simulator="$ARCHIVE_PATH_PODS/$scheme_name/$ARCHIVE_FILE_IOS_SIMULATOR"

    echo "Create XCFramework for $scheme_name..."

    # Build Cocoapods Library for iOS Simulator
    xcodebuild \
        'ENABLE_BITCODE=YES' \
        'BITCODE_GENERATION_MODE=bitcode' \
        'OTHER_CFLAGS=-fembed-bitcode' \
        'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' \
        'SKIP_INSTALL=NO' \
        archive \
        -project $PODS_PROJECT \
        -scheme $scheme_name \
        -destination "$DESTINATION_IOS_SIMULATOR" \
        -configuration $CONFIGURATION \
        -archivePath $archive_path_ios_simulator \
        -quiet

    # Build Cocoapods Library for iOS Device
    xcodebuild \
        'ENABLE_BITCODE=YES' \
        'BITCODE_GENERATION_MODE=bitcode' \
        'OTHER_CFLAGS=-fembed-bitcode' \
        'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' \
        'SKIP_INSTALL=NO' \
        archive \
        -project $PODS_PROJECT \
        -scheme $scheme_name \
        -destination "$DESTINATION_IOS" \
        -configuration $CONFIGURATION \
        -archivePath $archive_path_ios \
        -quiet
    
    # Create XCFramework
    xcodebuild \
        -create-xcframework \
        -framework "$archive_path_ios/Products/Library/Frameworks/$scheme_name.framework" \
        -framework "$archive_path_ios_simulator/Products/Library/Frameworks/$scheme_name.framework" \
        -output "$XCFRAMEWORK_OUTPUT/$scheme_name.xcframework"
}

schemes=`xcodebuild \
    -project $PODS_PROJECT \
    -list |
    tr -d '\n' |
    awk '{sub("^.*Schemes:", ""); print $0}'`

echo 'Build xcframeworks for these Schemes.'
echo $schemes

for scheme in $schemes
do
    create-xcframework $scheme
done
