#! /bin/bash

set -eu

PODS_PROJECT=Pods/Pods.xcodeproj
DESTINATION_IOS_SIMULATOR='generic/platform=iOS Simulator'
DESTINATION_IOS='generic/platform=iOS'
CONFIGURATION=Release
ARCHIVE_PATH_IOS_SIMULATOR=build/Pods-iOS-Simulator.xcarchive
ARCHIVE_PATH_IOS=build/Pods-iOS.xcarchive
XCFRAMEWORK_OUTPUT=build

create-xcframework() {
    scheme_name=$1

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
        -archivePath $ARCHIVE_PATH_IOS_SIMULATOR \
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
        -archivePath $ARCHIVE_PATH_IOS \
        -quiet
    
    # Create XCFramework
    xcodebuild \
        -create-xcframework \
        -framework "$ARCHIVE_PATH_IOS/Products/Library/Frameworks/$scheme_name.framework" \
        -framework "$ARCHIVE_PATH_IOS_SIMULATOR/Products/Library/Frameworks/$scheme_name.framework" \
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
