
import UIKit

class TextFieldController {
  private let textFieldDelegate: TextFieldDelegate
  
  var textField: UITextField? {
    didSet {
      if let oldValue = oldValue {
        disassociate(with: oldValue)
      }
      if let textField = textField {
        associate(with: textField)
      }
    }
  }
  
  init(delegate: TextFieldDelegate) {
    self.textFieldDelegate = delegate
  }
  
  private func associate(with textfield: UITextField) {
    textField?.delegate = textFieldDelegate
    textField?.addTarget(self, action: #selector(editDidChange), for: .editingChanged)
  }
  
  private func disassociate(with textField: UITextField) {
    textField.delegate = nil
    textField.removeTarget(self, action: nil, for: .allEvents)
  }
  
  func startEditing() {
    guard let textField = textField else { return }
    textField.becomeFirstResponder()
    _ = textFieldDelegate.textField?(textField,
                                     shouldChangeCharactersIn: NSRange(location: 0, length: textField.text?.count ?? 0),
                                     replacementString: "")
  }
  
  @objc private func editDidChange() {
    guard let textField = textField else { return }
    textFieldDelegate.editDidChange(textField: textField)
  }
  
}
