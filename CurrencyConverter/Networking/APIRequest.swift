
enum APIRequest {
  case rates(base: String)
}

extension APIRequest: Request {
  
  var path: String {
    switch self {
    case .rates:
      return "/latest"
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .rates(let base):
      return .url(["base" : base])
    }
  }
    
  var method: HTTPMethod {
    switch self {
    case .rates:
      return .post
    }
  }
}
