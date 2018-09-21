
import Foundation

class NetworkDispatcher: Dispatcher  {
  private var environment: Environment
  private var session: URLSession
  
  required init(environment: Environment) {
    self.environment = environment
    self.session = URLSession(configuration: .default)
  }
  
  public func fetch(request: Request, completion: @escaping (Response?) -> Void) throws {
    let urlRequest = try prepare(request, with: environment)
    session.dataTask(with: urlRequest) { (data, response, error) in
      let response = Response(response as? HTTPURLResponse, data: data, error: error)
      completion(response)
    }.resume()
  }
}
