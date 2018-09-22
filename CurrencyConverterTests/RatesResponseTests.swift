import XCTest
@testable import CurrencyConverter

class RatesResponseTests: XCTestCase {

  let environment = Environment("Test", host: "https://revolut.duckdns.org")
  let request = APIRequest.rates(base: "EUR")
  var dispatcher: MockDispatcher?
  
  override func setUp() {
    super.setUp()
    dispatcher = MockDispatcher(environment: environment)
  }
  
  func testRatesResponseParsing() {
    try? dispatcher?.fetch(request: request) { [weak self] (response) in
      switch response {
      case .data(let rates)?:
        self!.assertRates(rates)
      case .error?:
        XCTFail()
      default:
        break
      }
    }
  }
  
  private func assertRates(_ rates: RawRates) {
    XCTAssertEqual(rates.base, "EUR")
    XCTAssertEqual(rates.rates.count, 32)
    
    let rate0 = rates.rates[0]
    XCTAssertEqual(rate0.currency, "AUD")
    XCTAssertEqual(rate0.value, 1.614)
    
    let rate1 = rates.rates[1]
    XCTAssertEqual(rate1.currency, "BGN")
    XCTAssertEqual(rate1.value, 1.9529)

    let rate2 = rates.rates[2]
    XCTAssertEqual(rate2.currency, "BRL")
    XCTAssertEqual(rate2.value, 4.7846)

    let rate3 = rates.rates[3]
    XCTAssertEqual(rate3.currency, "CAD")
    XCTAssertEqual(rate3.value, 1.5315)

    let rate4 = rates.rates[4]
    XCTAssertEqual(rate4.currency, "CHF")
    XCTAssertEqual(rate4.value, 1.1258)

  }
}


struct MockDispatcher: Dispatcher {
  
  typealias Data = RawRates
  init(environment: Environment) {
    
  }
  
  func fetch(request: Request, completion: @escaping (Response?) -> Void) throws {
    guard let data = MockData.from(file: "sample_rates") else {
      return
    }
    let mockResponseState = HTTPURLResponse(url: URL(string: "www.google.co.uk")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    let response = Response(mockResponseState, data: data, error: nil)
    completion(response)
  }
}
