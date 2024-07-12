# SQLCipher for macOS

The instructions from https://www.zetetic.net/sqlcipher/ios-tutorial/ are insufficient for macOS.

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

```sh
brew install openssl
nm /opt/homebrew/opt/openssl/lib/libcrypto.a | grep -i 'EVP_aes_256_cbc'
# static link in Package.swift
.unsafeFlags(["/opt/homebrew/opt/openssl/lib/libcrypto.a"])
```
