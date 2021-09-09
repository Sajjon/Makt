// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Makt",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Makt",
            targets: ["Makt"]),
    ],
    dependencies: [
        .package(url: "https://github.com/1024jp/GzipSwift.git", .upToNextMajor(from: "5.1.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Makt",
            dependencies: [.product(name: "Gzip", package: "GzipSwift")]),
        .testTarget(
            name: "MaktTests",
            dependencies: ["Makt"],
            resources: [
                .copy("Resources/TestMaps/artifacts.h3m"),
                .copy("Resources/TestMaps/creatures-cyon-modified.h3m"),
                .copy("Resources/TestMaps/cyon_sod_additional_info_heroes_starting_with_letter_A.h3m"),
                .copy("Resources/TestMaps/cyon_sod_additional_info_heroes_starting_with_letter_B.h3m"),
                .copy("Resources/TestMaps/cyon_sod_only_allows_artifacts_starting_with_letter_A.h3m"),
                .copy("Resources/TestMaps/cyon_sod_only_additional_info_custom_heroes.h3m"),
                .copy("Resources/TestMaps/dwelling.h3m"),
                .copy("Resources/TestMaps/events.h3m"),
                .copy("Resources/TestMaps/monsters.h3m"),
                .copy("Resources/TestMaps/garrison.h3m"),
                .copy("Resources/TestMaps/town-events.h3m")
            ]
            )
    ]
)
