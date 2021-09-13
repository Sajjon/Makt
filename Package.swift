// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Makt",
    products: [
        .library(name: "Makt", targets: ["Makt", "Malm"]),
    ],
    dependencies: [
        .package(url: "https://github.com/1024jp/GzipSwift.git", .upToNextMajor(from: "5.1.1"))
    ],
    targets: [
        .target(
            name: "Util", dependencies: []
        ),
        .target(
            name: "Malm",
            dependencies: [
                "Util"
            ]
        ),
        .target(
            name: "H3M",
            dependencies: [
                "Util",
                "Malm",
                .product(name: "Gzip", package: "GzipSwift")
            ],
            exclude: ["h3m_polish.txt", "H3M.md", "H3M_google_translated_from_polish.txt"]
        ),
        .target(
            name: "Makt",
            dependencies: ["Util", "Malm", "H3M"]
        ),
        .testTarget(
            name: "MalmTests",
            dependencies: ["Malm"]
        ),
        .testTarget(
            name: "H3MTests",
            dependencies: ["H3M", "Malm"],
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
                .copy("Resources/TestMaps/resources.h3m"),
                .copy("Resources/TestMaps/witch-hut.h3m"),
                .copy("Resources/TestMaps/random-AB.h3m"),
                .copy("Resources/TestMaps/random-RoE.h3m"),
                .copy("Resources/TestMaps/garrison.h3m"),
                .copy("Resources/TestMaps/town-events.h3m"),
                .copy("Resources/TestMaps/scholar.h3m"),
                .copy("Resources/TestMaps/random-SoD.h3m"),
                .copy("Resources/TestMaps/seers-hut.h3m"),
                .copy("Resources/TestMaps/secondary-skills.h3m"),
                .copy("Resources/TestMaps/pandora-box.h3m"),
                .copy("Resources/TestMaps/town-spells-1-3.h3m"),
                .copy("Resources/TestMaps/town-spells-4-5.h3m")
            ]
        ),
        .testTarget(
            name: "MaktTests",
            dependencies: ["Makt"]
        )
    ]
)
