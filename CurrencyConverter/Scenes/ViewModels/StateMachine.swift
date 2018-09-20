
import Foundation

public protocol StateMachine {
  associatedtype State
  associatedtype Event
  
  func map(event: Event) -> State
}
