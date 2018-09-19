import Foundation

struct RawRates: Decodable {
  
  let base: String
  let date: String
  
  let rates: [RawRate]
  
  enum CodingKeys: String, CodingKey {
    case base
    case date
    case rates
  }
  
  init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    base = try container.decode(String.self, forKey: .base)
    date = try container.decode(String.self, forKey: .date)
    
    if let ratesObj = try? container.decode([String: Float].self, forKey: .rates) {
      rates = ratesObj.map {
        RawRate(currency: $0.key, value: $0.value)
      }.sorted { $0.currency < $1.currency }
    } else {
      rates = []
    }
  }
}

struct RawRate {
  let currency: String
  let value: Float
}
