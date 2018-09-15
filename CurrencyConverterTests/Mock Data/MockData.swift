import Foundation

class Class {
  
}

struct MockData {
  
  static func from(file name: String) -> Data? {
    if let path = Bundle(for: Class.self).path(forResource: name, ofType: "json") {
      do {
        return try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
      } catch let error {
        print("parse error: \(error.localizedDescription)")
      }
    } else {
      print("Invalid filename/path.")
    }
    return nil
  }
}
