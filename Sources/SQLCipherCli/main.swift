import SQLCipher

guard CommandLine.arguments.count > 2 else {
  print("Usage: <master.db> <cipher_key>")
  throw Error.missingParameters
}

let db_filename = CommandLine.arguments[1]
let cipher_key = CommandLine.arguments[2]

enum Error: Swift.Error {
  case missingParameters
  case sqlError(message: String)
}

var db: OpaquePointer? = nil

if sqlite3_open(db_filename, &db) != SQLITE_OK {
  let errmsg = String(cString: sqlite3_errmsg(db))
  fatalError("Error opening database: \(errmsg)")
}

do {
  defer { sqlite3_close(db) }

  if sqlite3_exec(db, "PRAGMA cipher_compatibility = 4;", nil, nil, nil) != SQLITE_OK {
    let errmsg = String(cString: sqlite3_errmsg(db))
    throw Error.sqlError(message: errmsg)
  }

  if sqlite3_exec(db, "PRAGMA key = '\(cipher_key)';", nil, nil, nil) != SQLITE_OK {
    let errmsg = String(cString: sqlite3_errmsg(db))
    throw Error.sqlError(message: errmsg)
  }

  var stmt: OpaquePointer? = nil

  if sqlite3_prepare(db, "PRAGMA cipher_version;", -1, &stmt, nil) != SQLITE_OK {
    let errmsg = String(cString: sqlite3_errmsg(db))
    throw Error.sqlError(message: errmsg)
  }

  defer { sqlite3_finalize(stmt) }

  if sqlite3_step(stmt) != SQLITE_ROW {
    let errmsg = String(cString: sqlite3_errmsg(db))
    throw Error.sqlError(message: errmsg)
  }

  let version = String(cString: sqlite3_column_text(stmt, 0))
  print("cipher_version: \(version)")

  var statement: OpaquePointer? = nil

  if sqlite3_prepare_v2(db, "SELECT * FROM sqlite_master WHERE type='table'", -1, &statement, nil)
    != SQLITE_OK
  {
    let errmsg = String(cString: sqlite3_errmsg(db))
    throw Error.sqlError(message: errmsg)
  }

  while sqlite3_step(statement) == SQLITE_ROW {
    let id = String(cString: sqlite3_column_text(statement, 0))
    let filename = String(cString: sqlite3_column_text(statement, 1))
    print("\(id): \(filename)")
  }

  sqlite3_finalize(statement)
}
