import Foundation

struct Environment {
  
   var name: String
   var host: String
  
   init(_ name: String, host: String) {
    self.name = name
    self.host = host
  }
}
