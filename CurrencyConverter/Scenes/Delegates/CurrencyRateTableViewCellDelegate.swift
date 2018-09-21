
import Foundation
protocol CurrencyRateTableViewCellDelegate {
  func becomeBase(_ currency: String, with text: String)
  func rateTextChanged(to text: String)
}
