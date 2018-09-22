
import Foundation

// A CurrencyFormatter tailored for current requirement
struct CurrencyFormatter {
  
  private let currencyFormatter: NumberFormatter
  
  init(currencyCode: String, preferMaxFractionDigits: Int = 2) {
    currencyFormatter = NumberFormatter()
    currencyFormatter.currencyCode = currencyCode
    currencyFormatter.currencyDecimalSeparator = Locale.current.decimalSeparator ?? "."
    currencyFormatter.maximumFractionDigits = preferMaxFractionDigits
  }
  
  func string(from value: NSNumber) -> String {
    return currencyFormatter.string(from: value) ?? "\(value)"
  }
  
  func number(from text: String) -> NSNumber {
    return currencyFormatter.number(from: text) ?? 0
  }
}
