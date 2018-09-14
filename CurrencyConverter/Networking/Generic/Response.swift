import Foundation

enum Response<Result> where Result: Decodable {
  case data(_: Result)
  case error(_: Int?, _: Error?)
  
  init(_ response: HTTPURLResponse?, data: Data?, error: Error?) {
    guard response?.statusCode == 200, error == nil else {
      self = .error(response?.statusCode, error)
      return
    }
    
    guard let data = data else {
      self = .error(response?.statusCode, Errors.noData)
      return
    }
    
    guard let ret = try? JSONDecoder().decode(Result.self, from: data) else {
      self = .error(nil, Errors.malformedData)
      return
    }
    self = .data(ret)
  }
}
