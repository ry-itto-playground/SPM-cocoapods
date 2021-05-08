# SPM-cocoapods

Example Project of using Cocoapods with SPM Project Definition.
Prebuild cocoapods libraries like Carthage and use `binaryTarget` in Package.swift to add dependency of cocoapods library.

## How to test

1. Setup dependencies

```sh
bundle
bundle exec pod install
```

2. Create XCFrameworks

This step takes a few minutes.

```sh
./scripts/generate-pods-xcframeworks.sh
```

3. Open Workspace and Run

```sh
open Sample.xcworkspace
```
