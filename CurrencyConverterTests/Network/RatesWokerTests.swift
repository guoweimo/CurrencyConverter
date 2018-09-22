
import XCTest
import RxSwift
@testable import CurrencyConverter

class RatesWokerTests: XCTestCase {
  
  let bag = DisposeBag()
  
  func testWorkerShouldHaveValidResponse() {
    RatesWorker(base: .defaultCurrency).doWork(in: MockDispatcher(environment: .test)).subscribeNext { state in
      switch state {
      case .loaded(let data):
        XCTAssertEqual(data.base, "EUR")
        XCTAssertEqual(data.rates.count, 32)
      default:
        XCTFail("Should not go to this case")
      }
    }.disposed(by: bag)
  }
  
  func testWorkerShouldHaveErrorResponse() {
    RatesWorker(base: .defaultCurrency).doWork(in: MockErrorDispatcher(environment: .test)).subscribeNext { state in
      switch state {
      case .failed(let error):
        XCTAssertEqual(error as! Errors, Errors.badInput)
      default:
        XCTFail("Should not go to this case")
      }
    }.disposed(by: bag)
  }

  
  
}

struct MockDispatcher: Dispatcher {
  
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

struct MockErrorDispatcher: Dispatcher {
  init(environment: Environment) {
    
  }
  
  func fetch(request: Request, completion: @escaping (Response?) -> Void) throws {
    let response = Response(nil, data: nil, error: Errors.badInput)
    completion(response)
  }
}
