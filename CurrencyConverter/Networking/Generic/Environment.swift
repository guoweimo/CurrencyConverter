import Foundation

struct Environment {
  static let test = Environment("Test", host: "https://revolut.duckdns.org")
  
  var name: String
  var host: String
  
  init(_ name: String, host: String) {
    self.name = name
    self.host = host
  }
}

