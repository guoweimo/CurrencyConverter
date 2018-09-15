
import Foundation

class NetworkDispatcher<Result>: Dispatcher where Result: Decodable {
  typealias Data = Result
  private var environment: Environment
  private var session: URLSession
  
  required init(environment: Environment) {
    self.environment = environment
    self.session = URLSession(configuration: .default)
  }
  
  public func fetch(request: Request, completion: @escaping (Response<Result>) -> Void) throws {
    let urlRequest = try prepare(request, with: environment)
    session.dataTask(with: urlRequest) { (data, response, error) in
      let response = Response<Result>(response as? HTTPURLResponse, data: data, error: error)
      completion(response)
    }.resume()
  }
}
