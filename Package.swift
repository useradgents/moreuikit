// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MoreUIKit",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "MoreUIKit", targets: ["MoreUIKit"])
    ],
    dependencies: [
        .package(name: "Slab", url: "https://github.com/useradgents/slab.git", from: "1.3.0")
    ],
    targets: [
        .target(
            name: "MoreUIKit",
            dependencies: ["Slab"]
        ),
        .testTarget(name: "MoreUIKitTests", dependencies: ["MoreUIKit"])
    ],
    swiftLanguageVersions: [.v5]
)
