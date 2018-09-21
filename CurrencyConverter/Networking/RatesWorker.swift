
import Foundation
import RxSwift

class RatesWorker: Worker {
  
  private let base: String
  init(base: String = .defaultCurrency) {
    self.base = base
  }
  
  var request: Request {
    return APIRequest.rates(base: base)
  }
  
  typealias Result = RawRates
  
  func doWork(in dispatcher: Dispatcher) -> Observable<Loadable<RawRates>> {
    let loadable = BehaviorSubject<Loadable<RawRates>>(value: .loading)
    do {
      try dispatcher.fetch(request: request) { (response) in
        switch response {
        case .error(let error)?:
          loadable.onNext(.failed(error))
        case .data(let data)?:
          guard let data = data,
            let ret = try? JSONDecoder().decode(RawRates.self, from: data) else {
              loadable.onNext(.failed(Errors.malformedData))
              return
          }
          loadable.onNext(.loaded(ret))
        default:
          loadable.onNext(.loading)
        }
      }
    } catch(let error) {
      loadable.onNext(.failed(error))
    }
    return loadable
  }
}
