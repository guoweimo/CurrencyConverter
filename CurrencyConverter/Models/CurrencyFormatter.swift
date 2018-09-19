
import Foundation

// A CurrencyFormatter tailored for current requirement
struct CurrencyFormatter {
  private let currencyFormatter: NumberFormatter
  
  init(currencyCode: String) {
    currencyFormatter = NumberFormatter()
//    currencyFormatter.numberStyle = .currency
    currencyFormatter.currencyCode = currencyCode
    currencyFormatter.maximumFractionDigits = 2
  }
  
  func string(from value: Float) -> String {
    return currencyFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
  }
}
