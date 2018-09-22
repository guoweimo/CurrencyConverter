import UIKit

extension UITextField {
  open override var accessibilityValue: String? {
    get {
      return text
    }
    set {
      
    }
  }
}
