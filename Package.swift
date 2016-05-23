import PackageDescription

let package = Package(
    name: "HTTP",
    dependencies: [
        .Package(url: "https://github.com/noppoMan/MediaType.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/slimane-swift/URI.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/open-swift/S4.git", majorVersion: 0, minor: 7)
    ]
)
