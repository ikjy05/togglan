// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Togglan",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "Togglan",
            path: "Sources/Togglan"
        )
    ]
)
