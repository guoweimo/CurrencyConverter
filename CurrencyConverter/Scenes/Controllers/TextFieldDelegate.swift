//
//  TextFieldDelegate.swift
//  CurrencyConverter
//
//  Created by Guowei Mo on 15/09/2018.
//  Copyright © 2018 Guowei Mo. All rights reserved.
//

import UIKit
import Foundation

protocol TextFieldDelegate: UITextFieldDelegate {
  func editDidChange(textField: UITextField)
}

class CurrencyTextFieldDelegate: NSObject, TextFieldDelegate {
  
  var editChanged: ((NSNumber?) -> Void)?
  
  @objc func editDidChange(textField: UITextField) {
    if let number = numberFrom(textField.text) {
      editChanged?(number)
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text, !text.isEmpty || !string.isEmpty {
      let res = text + string
      return Float(res) != nil
    }
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.numberStyle = .currency
    currencyFormatter.currencyCode = "EUR"
//    currencyFormatter.decimalSeparator = ","
    if let number = numberFrom(textField.text) {
      textField.text = currencyFormatter.string(from: number)
    }
  }
  
  private func numberFrom(_ text: String?) -> NSNumber? {
    if let text = text, let Float = Float(text) {
      return NSNumber(value: Float)
    }
    return nil
  }
}
