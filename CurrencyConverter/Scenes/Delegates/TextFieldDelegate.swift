//
//  TextFieldDelegate.swift
//  CurrencyConverter
//
//  Created by Guowei Mo on 15/09/2018.
//  Copyright © 2018 Guowei Mo. All rights reserved.
//

import UIKit
import Foundation

class CurrencyTextFieldDelegate: NSObject, UITextFieldDelegate {
  
  let separator = Locale.current.decimalSeparator ?? "."
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if string.isEmpty {
      return true
    }
    if let text = textField.text,
      let textRange = Range(range, in: text) {
      
      let updatedText = text.replacingCharacters(in: textRange, with: string)
      let parts = updatedText.components(separatedBy: separator)
      if parts.count > 2 { // 20.00.1
        return false
      }
      if parts.count == 2 {
        if parts[1].count > 2 { //20.001
          return false
        }
        return true  // 20.
      }
      return Float(updatedText) != nil
    }
    return true
  }
}
