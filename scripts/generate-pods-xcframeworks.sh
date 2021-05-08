#! /bin/bash

create-xcframework() {
    scheme_name=$1

    echo "Create XCFramework for $scheme_name ..."
    # Build Cocoapods Library for iOS Simulator
    xcodebuild \
        'ENABLE_BITCODE=YES' \
        'BITCODE_GENERATION_MODE=bitcode' \
        'OTHER_CFLAGS=-fembed-bitcode' \
        'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' \
        'SKIP_INSTALL=NO' \
        archive \
        -project 'Pods/Pods.xcodeproj' \
        -scheme $scheme_name \
        -destination 'generic/platform=iOS Simulator' \
        -configuration 'Release' \
        -archivePath 'build/Pods-iOS-Simulator.xcarchive' \
        -quiet

    # Build Cocoapods Library for iOS Device
    xcodebuild \
        'ENABLE_BITCODE=YES' \
        'BITCODE_GENERATION_MODE=bitcode' \
        'OTHER_CFLAGS=-fembed-bitcode' \
        'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' \
        'SKIP_INSTALL=NO' \
        archive \
        -project 'Pods/Pods.xcodeproj' \
        -scheme $scheme_name \
        -destination 'generic/platform=iOS' \
        -configuration 'Release' \
        -archivePath 'build/Pods-iOS.xcarchive' \
        -quiet
    
    # Create XCFramework
    xcodebuild \
        -create-xcframework \
        -framework "build/Pods-iOS.xcarchive/Products/Library/Frameworks/$scheme_name.framework" \
        -framework "build/Pods-iOS-Simulator.xcarchive/Products/Library/Frameworks/$scheme_name.framework" \
        -output "build/$scheme_name.xcframework"
}

schemes=`xcodebuild \
    -project 'Pods/Pods.xcodeproj' \
    -list |
    tr -d '\n' |
    awk '{sub("^.*Schemes:", ""); print $0}'`

echo 'Build xcframeworks for these Schemes.'
echo $schemes

for scheme in $schemes
do
    create-xcframework $scheme
done
