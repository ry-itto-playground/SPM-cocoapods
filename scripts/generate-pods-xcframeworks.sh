#! /bin/bash

xcodebuild \
    -project 'Pods/Pods.xcodeproj' \
    -list

# Build Cocoapods Library for iOS Simulator
xcodebuild \
    'ENABLE_BITCODE=YES' \
    'BITCODE_GENERATION_MODE=bitcode' \
    'OTHER_CFLAGS=-fembed-bitcode' \
    'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' \
    'SKIP_INSTALL=NO' \
    archive \
    -project 'Pods/Pods.xcodeproj' \
    -scheme 'RxSwift' \
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
    -scheme 'RxSwift' \
    -destination 'generic/platform=iOS' \
    -configuration 'Release' \
    -archivePath 'build/Pods-iOS.xcarchive' \
    -quiet

# Create XCFramework
xcodebuild \
    -create-xcframework \
    -framework 'build/Pods-iOS.xcarchive/Products/Library/Frameworks/RxSwift.framework' \
    -framework 'build/Pods-iOS-Simulator.xcarchive/Products/Library/Frameworks/RxSwift.framework' \
    -output 'build/RxSwift.xcframework'
