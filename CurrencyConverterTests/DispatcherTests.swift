
import XCTest
@testable import CurrencyConverter

struct MockRequest: Request {
  var path: String {
    return ""
  }
  
  var method: HTTPMethod {
    return .get
  }
  
  var parameters: RequestParams {
    return .url(nil)
  }
  
}


class DispatcherTests: XCTestCase {
  
  var dispatcher: MockDispatcher?
  let environment = Environment("Test", host: "https://revolut.duckdns.org")
  let request = APIRequest.rates(base: "GBP")
  
  override func setUp() {
    super.setUp()
    
    dispatcher = MockDispatcher(environment: environment)
  }
  
  func testCallingPrepareShouldReturnExpectedRequest() {
    let urlRequest = try? dispatcher?.prepare(request, with: environment)
    
    XCTAssertEqual(urlRequest??.url?.absoluteString, "https://revolut.duckdns.org/latest?base=GBP")
    XCTAssertEqual(urlRequest??.httpMethod, "POST")
  }
  
  func testInvalidURLShouldThrowError() {
    let environment = Environment("Error", host: "invalid url")

    XCTAssertThrowsError(try dispatcher?.prepare(request, with: environment)) { (error) -> Void in
      XCTAssertEqual(error as? Errors, Errors.invalidURL)
    }
  }
  
  func testMissingParametersInURLLShouldThrowError() {
    let request = MockRequest()

    XCTAssertThrowsError(try dispatcher?.prepare(request, with: environment)) { (error) -> Void in
      XCTAssertEqual(error as? Errors, Errors.badInput)
    }
  }

}
