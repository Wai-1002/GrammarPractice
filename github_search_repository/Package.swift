// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "github_search_repository",
    targets: [
        .target(
            name: "GitHubSearch"),
        .testTarget(name: "GitHubSearchTests",
                   dependencies: ["GitHubSearch"]),
        .target(name: "github_search_repository",
               dependencies: ["GitHubSearch"]),
    ]
)
