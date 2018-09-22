
import Foundation
import IGListKit

struct DisplayRate {
  let currencyId: String
  let flagId: String?
  let currencyCode: String
  let currencyName: String
  let formattedValue: String
}

extension DisplayRate {
  
  init(with rate: Rate) {
    let regionCode = Locale.countryCode(from: rate.currency)
    let currencyName = rate.currency.localizedCurrencyString()
    let formattedValue = CurrencyFormatter(currencyCode: rate.currency).string(from: NSNumber(value: rate.value))
    self.init(currencyId: rate.currency,
              flagId: regionCode,
              currencyCode: rate.currency,
              currencyName: currencyName,
              formattedValue: formattedValue)
  }
}
