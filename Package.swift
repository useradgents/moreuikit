// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MoreUIKit",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "MoreUIKit", targets: ["MoreUIKit"])
    ],
    dependencies: [
        .package(name: "Slab", url: "https://bitbucket.org/useradgents/slab.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MoreUIKit",
            dependencies: [
                .product(name: "Slab", package: "Slab")
            ]
        ),
        .testTarget(name: "MoreUIKitTests", dependencies: ["MoreUIKit"])
    ],
    swiftLanguageVersions: [.v5]
)
