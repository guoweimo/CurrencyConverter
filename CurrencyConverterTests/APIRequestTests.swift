
import XCTest
@testable import CurrencyConverter

class APIRequestTests: XCTestCase {
  
  var ratesRequest: Request?
  
  override func setUp() {
    super.setUp()
    ratesRequest = APIRequest.rates(base: "EUR")
  }
  
  func testRatesRequestShouldHaveCorrectPath() {
    XCTAssertEqual(ratesRequest?.path, "/latest")
  }
  
  func testRatesRequestShouldHaveCorrectParameters() {
    switch ratesRequest?.parameters {
    case .url(let para)?:
      XCTAssertEqual(para, ["base" : "EUR"])
    case .none:
      XCTFail()
    }
  }
  
  func testRatesRequestShouldHaveCorrectMethod() {
    XCTAssertEqual(ratesRequest?.method, .get)
  }
  
}
