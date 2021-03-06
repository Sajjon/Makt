// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let excludedFilenames = ["README.md"]

let package = Package(
    name: "Makt",
    platforms: [.macOS(.v11), .iOS(.v13)],
    products: [
        .library(name: "Makt", targets: ["Makt", "Malm"]),
    ],
    dependencies: [
        .package(url: "https://github.com/1024jp/GzipSwift", .upToNextMajor(from: "5.1.1")),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.1"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),

        // Commented out because it does not work in RELEASE mode.
//        .package(url: "https://github.com/sunlubo/SwiftFFmpeg", .upToNextMajor("1.5.0")),
    ],
    targets: [
        .target(
            name: "Common", dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .target(
            name: "Decompressor",
            dependencies: [
                .product(name: "Gzip", package: "GzipSwift")
            ]
        ),
        .target(
            name: "Video",
            dependencies: [
              /* "SwiftFFmpeg", */ "Common", "Guld"
            ]
        ),
        .target(
            name: "Malm",
            dependencies: [
                "Common"
            ]
        ),
        .target(
            name: "Packa",
            dependencies: [
                "Common"
            ],
            exclude: excludedFilenames
        ),
        .target(
            name: "Guld",
            dependencies: [
                "Common", "Malm", "Decompressor", "H3C", "H3M"
            ]
        ),
        .executableTarget(
            name: "Laka",
            dependencies: [
                "Common",
                "Malm",
                "Guld",
                "Packa",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
            ],
            exclude: excludedFilenames
        ),
        .target(
            name: "H3M",
            dependencies: [
                "Common",
                "Malm",
                "Decompressor",
            ],
            exclude: ["h3m_polish.txt", "H3M.md", "H3M_google_translated_from_polish.txt"]
        ),
        .target(
            name: "H3C",
            dependencies: [
            "Common",
            "Malm",
            "Decompressor",
            ]
        ),
        .target(
            name: "Makt",
            dependencies: ["Common", "Malm", "H3M", "Guld", "Video"]
        ),
        .testTarget(
            name: "MalmTests",
            dependencies: ["Malm"]
        ),
        .testTarget(
            name: "CommonTests",
            dependencies: ["Common"]
        ),
    
        .testTarget(
            name: "GuldTests",
            dependencies: ["Guld", "Malm"],
            resources: [
                .copy("Resources/ExpectedHashesOfDefFilesInArchive__H3sprite_lod.json")
            ]
        ),
        .testTarget(
            name: "LakaTests",
            dependencies: ["Laka"]
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
        ),
        .testTarget(
            name: "DecompressorTests",
            dependencies: ["Decompressor"]
        )
    ]
)
