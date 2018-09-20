//
//  Locale.swift
//  CurrencyConverter
//
//  Created by Guowei Mo on 19/09/2018.
//  Copyright © 2018 Guowei Mo. All rights reserved.
//

import Foundation

extension Locale {
  
  private static func fromCurrencyCode(_ currencyCode: String) -> Locale? {
    let allLocales = Locale.availableIdentifiers.map(Locale.init)
    let locale = allLocales.first { $0.currencyCode == currencyCode }
    return locale
  }
  
  static func countryCode(from currencyCode: String) -> String? {
    if currencyCode == .defaultCurrency {
      return String.defaultRegion
    }
    let locale = fromCurrencyCode(currencyCode)
    return locale?.regionCode ?? ""
  }
  
}

extension String {
  static let defaultCurrency = "EUR"
  static let defaultRegion = "EU"
  
  func localizedCurrencyString() -> String {
    return Locale.current.localizedString(forCurrencyCode: self) ?? self
  }
}
