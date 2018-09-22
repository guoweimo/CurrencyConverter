import Foundation

enum Response {
  case data(Data?)
  case error(Error?)
  
  init(_ response: HTTPURLResponse?, data: Data?, error: Error?) {
    guard response?.statusCode == 200, error == nil else {
      self = .error(error)
      return
    }
    self = .data(data)
  }
}
