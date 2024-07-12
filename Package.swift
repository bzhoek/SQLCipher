// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SQLCipher",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SQLCipher",
            targets: ["SQLCipher"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SQLCipher",
            cSettings: [
              .define("SQLITE_HAS_CODEC", to: "1"),
              .define("SQLITE_TEMP_STORE", to: "3"),
              .define("SQLITE_CRYPTO_CC", to: nil),
              .define("NDEBUG", to: "1"),
              .unsafeFlags(["-I/opt/homebrew/Cellar/openssl@3/3.3.1/include"])],
            linkerSettings: [
              .linkedFramework("Foundation"),
              .linkedFramework("Security"),
              .unsafeFlags(["LDFLAGS=/opt/homebrew/Cellar/openssl@3/3.3.1/lib/libcrypto.a"])
            ]),
    ]
)
