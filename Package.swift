// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Onitama",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .library(name: "Onitama", targets: ["Onitama"])
    ],
    targets: [
        .target(name: "Onitama", dependencies: [])
    ],
    swiftLanguageVersions: [.v5]
)