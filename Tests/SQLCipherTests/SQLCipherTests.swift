import XCTest
@testable import SQLCipher

final class SQLCipherTests: XCTestCase {
  func testMemoryDatabase() throws {
    var rc: Int32
    var db: OpaquePointer? = nil
    var stmt: OpaquePointer? = nil
    let password: String = "correct horse battery staple"
    rc = sqlite3_open(":memory:", &db)
    if (rc != SQLITE_OK) {
      let errmsg = String(cString: sqlite3_errmsg(db))
      NSLog("Error opening database: \(errmsg)")
      exit(1)
    }
    rc = sqlite3_key(db, password, Int32(password.utf8CString.count))
    if (rc != SQLITE_OK) {
      let errmsg = String(cString: sqlite3_errmsg(db))
      NSLog("Error setting key: \(errmsg)")
    }
    print("DONE")
  }
}
