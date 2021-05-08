#! /bin/bash

xcodebuild \
    -project 'Pods/Pods.xcodeproj' \
    -list

xcodebuild \
    'ENABLE_BITCODE=YES' \
    'BITCODE_GENERATION_MODE=bitcode' \
    'OTHER_CFLAGS=-fembed-bitcode' \
    'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' \
    'SKIP_INSTALL=NO' \
    archive \
    -project 'Pods/Pods.xcodeproj' \
    -scheme 'QiitaAPIKit' \
    -destination 'generic/platform=iOS' \
    -configuration 'Release' \
    -archivePath 'build/Pods.xcarchive' \
    -quiet

xcodebuild \
    -create-xcframework \
    -framework 'build/Pods.xcarchive/Products/Library/Frameworks/QiitaAPIKit.framework' \
    -output 'build/QiitaAPIKit.xcframework'
