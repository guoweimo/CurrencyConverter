
import Foundation

protocol RateTableViewCellDelegate: class {
  func becomeBase(_ currency: String, with text: String)
  func rateTextChanged(to text: String)
}
