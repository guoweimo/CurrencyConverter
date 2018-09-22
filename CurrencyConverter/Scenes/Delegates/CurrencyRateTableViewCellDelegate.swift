
import Foundation
protocol CurrencyRateTableViewCellDelegate: class {
  func becomeBase(_ currency: String, with text: String)
  func rateTextChanged(to text: String)
}
