import Foundation

enum Response<Result> where Result: Decodable {
  case data(Result)
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
    
    guard let ret = try? JSONDecoder().decode(Result.self, from: data) else {
      self = .error(Errors.malformedData)
      return
    }
    self = .data(ret)
  }
}
