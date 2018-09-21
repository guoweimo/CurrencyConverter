import Foundation

enum Response {
  case data(Data?)
  case error(Error?)
  
  init(_ response: HTTPURLResponse?, data: Data?, error: Error?) {
    guard response?.statusCode == 200, error == nil else {
      self = .error(error)
      return
    }
    
    guard let data = data else {
      self = .error(Errors.noData)
      return
    }
    
    self = .data(data)
  }
}
