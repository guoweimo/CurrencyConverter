
import Foundation
import UIKit

enum Type: String {
  case error = "Error"
}

class AlertController {
  
  static func showError(with message: String, on viewController: UIViewController) {
    show(.error, message: message, on: viewController)
  }
  
  private static func show(_ type: Type, message: String, on viewController: UIViewController) {
    let alert = UIAlertController(title: type.rawValue, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    viewController.present(alert, animated: true)
  }
}
