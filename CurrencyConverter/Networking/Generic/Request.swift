
enum HTTPMethod: String {
  case post = "POST"
  case get = "GET"
}

enum RequestParams {
  case url(_ : [String: String]?)
}

protocol Request {
  var path: String { get }
  var method: HTTPMethod { get }
  var parameters: RequestParams { get }
}
