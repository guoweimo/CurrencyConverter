
import Foundation

struct RatesGroup {
  let rates: [Rate]
  
  init(with rawRates: RawRates) {
    let baseRate = Rate(currency: rawRates.base, value: 1)
    rates = [baseRate] + rawRates.rates.map { Rate(currency: $0.currency, value: $0.value) }
  }
}

class Rate {
  let currency: String
  var value: Float
  init(currency: String, value: Float) {
    self.currency = currency
    self.value = value
  }
}

extension Rate: Equatable {
  static func == (lhs: Rate, rhs: Rate) -> Bool {
    return lhs.currency == rhs.currency
  }
}
