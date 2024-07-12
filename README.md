```
brew install openssl@1.1
# in Package.swift
.unsafeFlags(["/opt/homebrew/opt/openssl@1.1/lib/libcrypto.a"])
```
