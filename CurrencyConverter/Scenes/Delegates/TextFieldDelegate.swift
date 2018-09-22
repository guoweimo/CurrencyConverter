
import UIKit
import Foundation

class CurrencyTextFieldDelegate: NSObject, UITextFieldDelegate {
  
  let separator = Locale.current.decimalSeparator ?? "."
  
  private let maxFractionDigits: Int
  init(preferMaxFractionDigits: Int = 2) {
    self.maxFractionDigits = preferMaxFractionDigits
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return textField.resignFirstResponder()
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if string.isEmpty {
      return true
    }
    if let text = textField.text,
      let textRange = Range(range, in: text) {
      let updatedText = text.replacingCharacters(in: textRange, with: string)
      let parts = updatedText.components(separatedBy: separator)
      if parts.count == 2 {
        if parts[1].count > maxFractionDigits { //20.001
          return false
        }
        return true  // e.g 20.1 or 20.
      }
      return Float(updatedText) != nil
    }
    return true
  }
}
