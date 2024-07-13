# SQLCipher for macOS

Step-by-step instructions on how to create a Swift package for SQLCipher on macOS.

The instructions from https://www.zetetic.net/sqlcipher/ios-tutorial/ and https://www.youtube.com/watch?v=iVrD854cFYM are insufficient for macOS.

First, get the SQLCipher source code, and copy the resulting `sqlite3.c` and `sqlite3.h` files to the new Swift package.

```sh
git clone https://github.com/sqlcipher/sqlcipher.git
cd sqlcipher
./configure --with-crypto-lib=none
make sqlite3.c
cd ..
mkdir SQLCipher
swift package init
mkdir Sources/SQLCipher/include
cp ../sqlcipher/sqlite3.c Sources/SQLCipher
cp ../sqlcipher/sqlite3.h Sources/SQLCipher/include
```

## OpenSSL

Make sure OpenSSL is installed. The instructions below work both with the 1.1, and the latest, at this time 3.3.

```sh
brew install openssl
nm /opt/homebrew/opt/openssl/lib/libcrypto.a | grep -i 'EVP_aes_256_cbc'
# static link in Package.swift
.unsafeFlags(["/opt/homebrew/opt/openssl/lib/libcrypto.a"])
```

## Buillding

Compiler warnings are supressed for the `sqlite3.c` file. The macOS version in `Package.swift` must match the platform, otherwise you get 'was built for newer macOS version' linker warnings.

Can probably also be done with `export MACOSX_DEPLOYMENT_TARGET=14`

## Testing

Includes a `sqlcipher` executable that dumps all the tables to test the SQLCipher library.

```sh
swift run sqlcipher <db_file> <cipher_key>
```

## Xcode Project

* Header search paths: /opt/homebrew/opt/openssl@1.1/include
* Build Phases, Link Binary with Libraries, Add Other...
   /opt/homebrew/opt/openssl@1.1/lib/libcrypto.a
