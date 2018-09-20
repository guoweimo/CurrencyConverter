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
  let currencyCode: String
  
  init(currencyCode: String) {
    self.currencyCode = currencyCode
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text, !text.isEmpty || !string.isEmpty {
      let res = text + string
      return Float(res) != nil
    }
    return true
  }
  
//  func textFieldDidEndEditing(_ textField: UITextField) {
//    let currencyFormatter = CurrencyFormatter(currencyCode: currencyCode)
//    if let number = currencyFormatter.number(from: textField.text ?? "") {
//      textField.text = currencyFormatter.string(from: number)
//    }
//  }
}
