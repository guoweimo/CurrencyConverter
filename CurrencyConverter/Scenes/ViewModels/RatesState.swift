
import Foundation

enum RatesState {
  case initial(rates: [DisplayRate])
  case refresh(rates: [DisplayRate])
  case failToLoad(Error?)
  case loading
}
