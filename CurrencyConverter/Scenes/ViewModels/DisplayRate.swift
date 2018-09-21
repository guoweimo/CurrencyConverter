
import Foundation
import IGListKit

class DisplayRate {
  let currencyId: String
  let flagId: String?
  let currencyCode: String
  let currencyName: String
  let formattedValue: String
  
  init(currencyId: String, flagId: String?, currencyCode: String, currencyName: String, formattedValue: String) {
    self.currencyId = currencyId
    self.flagId = flagId
    self.currencyCode = currencyCode
    self.currencyName = currencyName
    self.formattedValue = formattedValue
  }
}

extension DisplayRate {
  
  convenience init(with rate: Rate) {
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

extension DisplayRate: ListDiffable {
  func diffIdentifier() -> NSObjectProtocol {
    return currencyId as NSString
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? DisplayRate else {
      return false
    }
    return currencyId == object.currencyId &&
    formattedValue == object.formattedValue
  }
}
