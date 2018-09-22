import XCTest
import RxSwift
@testable import CurrencyConverter

class RatesViewModelTests: XCTestCase {

  let environment = Environment("Test", host: "https://revolut.duckdns.org")
  let request = APIRequest.rates(base: "EUR")
  var viewModel: RatesViewModel?
  let bag = DisposeBag()
  
  override func setUp() {
    super.setUp()
    
    let dispatcher = MockDispatcher(environment: environment)
    viewModel = RatesViewModel(dispatcher: dispatcher)
  }
  
  func testFirstValidResponse() {
    viewModel?.requestRates().subscribeNext { state in
      switch state {
      case .initial(let rates):
        XCTAssertEqual(rates.count, 33)
        self.assertDisplayRates(rates)
      default:
        XCTFail()
      }
    }.disposed(by: bag)
  }
  
  func testSecondCallShouldRefreshRates() {
    viewModel?.requestRates().subscribe().disposed(by: bag)
    sleep(1)
    viewModel?.requestRates().subscribeNext { state in
      switch state {
      case .refresh(let rates):
        XCTAssertEqual(rates.count, 33)
        self.assertDisplayRates(rates)
      default:
        XCTFail()
      }
    }.disposed(by: bag)
  }

  private func assertDisplayRates(_ rates: [DisplayRate]) {
    
    let rate0 = rates[0]
    XCTAssertEqual(rate0.currencyCode, "EUR")
    XCTAssertEqual(rate0.formattedValue, "1")
    
    let rate1 = rates[1]
    XCTAssertEqual(rate1.currencyCode, "AUD")
    XCTAssertEqual(rate1.formattedValue, "1.61")
    
    let rate2 = rates[2]
    XCTAssertEqual(rate2.currencyCode, "BGN")
    XCTAssertEqual(rate2.formattedValue, "1.95")

    let rate3 = rates[3]
    XCTAssertEqual(rate3.currencyCode, "BRL")
    XCTAssertEqual(rate3.formattedValue, "4.78")

    let rate4 = rates[4]
    XCTAssertEqual(rate4.currencyCode, "CAD")
    XCTAssertEqual(rate4.formattedValue, "1.53")

    let rate5 = rates[5]
    XCTAssertEqual(rate5.currencyCode, "CHF")
    XCTAssertEqual(rate5.formattedValue, "1.13")
  }
}
