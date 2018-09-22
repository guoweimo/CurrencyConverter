import XCTest
import RxSwift
@testable import CurrencyConverter

class RatesViewModelTests: XCTestCase {

  let environment = Environment("Test", host: "https://revolut.duckdns.org")
  let request = APIRequest.rates(base: "EUR")
  var viewModel: RatesViewModel?
  let bag = DisposeBag()
  let originBase = Rate(currency: "EUR", value: 1)

  override func setUp() {
    super.setUp()
    
    let dispatcher = MockDispatcher(environment: environment)
    viewModel = RatesViewModel(dispatcher: dispatcher)
  }
  
  func testBaseRateChangeEvent() {
    let currentRates = viewModel?.currentRates
    let currentBase = viewModel?.baseRate
    
    viewModel?.requestRates().subscribe().disposed(by: bag)
    
    XCTAssertEqual(currentRates?.value[0], originBase)

    viewModel?.event.onNext(.baseRateChanged(to: "CNY", text: "1.20"))
    
    let newBase = Rate(currency: "CNY", value: 1.2)
    XCTAssertEqual(currentBase?.value, newBase)
    XCTAssertEqual(currentRates?.value[0], newBase)
    XCTAssertEqual(currentRates?.value[1], originBase)
  }
  
  func testBaseValueChangeEvent() {
    let currentRates = viewModel?.currentRates
    
    viewModel?.requestRates().subscribe().disposed(by: bag)
    XCTAssertEqual(currentRates?.value[0], originBase)
    
    let oldValues = currentRates?.value.map { $0.value }

    viewModel?.event.onNext(.baseValueChanged(newValue: "208.34"))
    
    XCTAssertEqual(currentRates?.value[0].value, 208.34)
    
    currentRates?.value.enumerated().forEach {
      (index, rate) in
      XCTAssertEqual(rate.value, oldValues![index] * 208.34)
    }
  }
  
  func testIndexPathOfCurrency() {
    viewModel?.requestRates().subscribe().disposed(by: bag)
    
    let indexPath = viewModel?.indexPath(for: "EUR")
    XCTAssertEqual(indexPath, .zero)
    
    let indexPath2 = viewModel?.indexPath(for: "USD")
    XCTAssertEqual(indexPath2, IndexPath(row: 31, section: 0))

  }
}
