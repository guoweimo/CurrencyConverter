import Foundation

struct Rates: Decodable {
  
  let base: String
  let date: String
  
  let rates: [Rate]
  
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
        Rate(currency: $0.key, value: $0.value)
      }.sorted { $0.currency < $1.currency }
    } else {
      rates = []
    }
  }
}

struct Rate {
  let currency: String
  let value: Float
}
