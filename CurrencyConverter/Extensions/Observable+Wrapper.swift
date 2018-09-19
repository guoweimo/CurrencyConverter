import Foundation
import RxSwift

extension Observable {
  
  /**
   Rx wrapper method.
   Subscribes an element handler, only interested in next non-optional element, not event.
   
   - parameter next: Action to invoke for each element in the observable sequence.
   - returns: Subscription object used to unsubscribe from the observable sequence.
   */
  func subscribeNext(next: ((Element) -> Void)?) -> Disposable {
    return subscribe(onNext: { (e) in
      next?(e)
    }, onError: nil, onCompleted: nil, onDisposed: nil)
  }
}
