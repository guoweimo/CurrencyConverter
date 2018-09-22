
import Foundation

enum RatesEvent {
  case baseRateChanged(to: String, text: String)
  case baseValueChanged(newValue: String)
}
