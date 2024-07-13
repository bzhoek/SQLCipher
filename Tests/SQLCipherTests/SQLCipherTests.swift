import XCTest
@testable import SQLCipher

final class SQLCipherTests: XCTestCase {
  func testMemoryDatabase() throws {
    var db: OpaquePointer? = nil
    let password: String = "correct horse battery staple"

    if sqlite3_open(":memory:", &db) != SQLITE_OK {
      let errmsg = String(cString: sqlite3_errmsg(db))
      fatalError("Error opening database: \(errmsg)")
    }

    if sqlite3_key(db, password, Int32(password.utf8CString.count)) != SQLITE_OK {
      fatalError(String(cString: sqlite3_errmsg(db)))
    }

    var stmt: OpaquePointer? = nil

    if sqlite3_prepare(db, "PRAGMA cipher_version;", -1, &stmt, nil) != SQLITE_OK {
      fatalError(String(cString: sqlite3_errmsg(db)))
    }

    if sqlite3_step(stmt) != SQLITE_ROW {
      fatalError(String(cString: sqlite3_errmsg(db)))
    }

    let version = String(cString: sqlite3_column_text(stmt, 0))
    XCTAssertEqual(version, "4.6.0 community")
  }
}
