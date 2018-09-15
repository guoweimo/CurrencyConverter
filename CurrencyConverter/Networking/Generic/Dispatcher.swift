import Foundation

protocol Dispatcher {
  associatedtype Data: Decodable
  init(environment: Environment)
  
  func fetch(request: Request, completion: @escaping (Response<Data>) -> Void) throws
}

extension Dispatcher {
  func prepare(_ request: Request, with environment: Environment) throws -> URLRequest {
    
    guard let baseURL = URL(string: environment.host) else {
      throw Errors.invalidURL
    }
    let fullUrl = baseURL.appendingPathComponent(request.path)
    var apiRequest = URLRequest(url: fullUrl)
    
    switch request.parameters {
    case .url(let params):
      if let params = params {
        let queryParams = params.map { pair  in
          URLQueryItem(name: pair.key, value: pair.value)
        }
        guard var components = URLComponents(string: fullUrl.absoluteString) else {
          throw Errors.invalidURL
        }
        components.queryItems = queryParams
        apiRequest.url = components.url
      } else {
        throw Errors.badInput
      }
    }
    apiRequest.httpMethod = request.method.rawValue
    
    return apiRequest
  }

}
