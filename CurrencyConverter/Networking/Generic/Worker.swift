
import Foundation
import RxSwift

protocol Worker {
  associatedtype Result
  
  var request: Request { get }
  
  func doWork(in dispatcher: Dispatcher) -> Observable<Loadable<Result>>
}
