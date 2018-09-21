
import Foundation
protocol CurrencyRateTableViewCellDelegate {
  func becomeBase(_ currency: String)
  func rateTextChanged(to text: String)
}
