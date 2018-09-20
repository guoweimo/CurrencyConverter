
import Foundation

enum CurrencyState {
  case initial([DisplayRate])
  case refreshed([DisplayRate])
  case refreshedBase(String)
  case refreshedBaseValue(String)
  case failToLoad(Error?)
}

enum CurrencyEvent {
  case unmatchedDataReturn([DisplayRate])
  case matchedDataReturn([DisplayRate])
  case errorReturn(Error?)
  case changeBase(newBase: String)
  case changeBaseValue(newValue: String)
}


struct CurrencyStateMachine: StateMachine {
  typealias State = CurrencyState
  typealias Event = CurrencyEvent
  
  func map(event: Event) -> State {
    switch (event) {
    case (.unmatchedDataReturn(let rates)):
      return .initial(rates)
    case (.matchedDataReturn(let rates)):
      return .refreshed(rates)
    case (.changeBase(let newBase)):
      return .refreshedBase(newBase)
    case (.changeBaseValue(let newValue)):
      return .refreshedBaseValue(newValue)
    case (.errorReturn(let error)):
      return .failToLoad(error)
    }
  }
}
