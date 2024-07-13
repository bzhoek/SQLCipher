// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "SQLCipher",
  platforms: [
    .macOS(.v14),
  ],
  products: [
    .executable(name: "sqlcipher", targets: ["SQLCipherCli"]),
    .library(
      name: "SQLCipher",
      targets: ["SQLCipher"]),
  ],
  targets: [
    .target(
      name: "SQLCipher",
      cSettings: [
        .define("SQLITE_HAS_CODEC", to: "1"),
        .define("SQLITE_TEMP_STORE", to: "3"),
        .define("SQLITE_CRYPTO_CC"),
        .define("NDEBUG", to: "1"),
        .unsafeFlags(["-w", "-I/opt/homebrew/opt/openssl/include"])
      ],
      swiftSettings: [
        .define("SQLITE_HAS_CODEC"),
      ],
      linkerSettings: [
        .linkedFramework("Foundation"),
        .linkedFramework("Security"),
        .unsafeFlags(["-v", "/opt/homebrew/opt/openssl/lib/libcrypto.a"])
      ]),
    .executableTarget(name: "SQLCipherCli", dependencies: ["SQLCipher"]),
//    .target(name: "SQLCipherCli", dependencies: ["SQLCipher"]),
    .testTarget(
      name: "SQLCipherTests",
      dependencies: ["SQLCipher"]),
  ]
)
