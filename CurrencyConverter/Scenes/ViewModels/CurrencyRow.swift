import Foundation
import UIKit

struct CurrencyRow {
  enum Content {
    case input(value: String, controller: TextFieldController?)
  }
  
  var image: UIImage
  var title: String
  var detail: String
  var content: Content
}
