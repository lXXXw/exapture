// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "exapture",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(
            name: "exapture",
            targets: ["exapture"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0")
    ],
    targets: [
        .executableTarget(
            name: "exapture",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        )
    ]
)