
import Foundation
import RxSwift

final class StateProcessor<S: StateMachine> {
  private let state: Observable<S.State>
  
  init(wrapping base: S, events: Observable<S.Event>) {
    state = events.map(base.map(event:))
  }
  
  func process(with sideEffect: @escaping (S.State) -> Void) -> Disposable {
    return state
      .subscribeOn(MainScheduler.instance)
      .do(onNext: sideEffect).subscribe()
  }
}
