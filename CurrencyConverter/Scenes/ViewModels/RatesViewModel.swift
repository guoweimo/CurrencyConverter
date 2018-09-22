
import Foundation
import RxSwift

class RatesViewModel {
  
  private let initialBase = Rate(currency: .defaultCurrency, value: 1)
  private let baseRate: Variable<Rate>
  private let currentRates = Variable<[Rate]>([])
  private let state: BehaviorSubject<RatesState>
  let event = PublishSubject<RatesEvent>()
  private let bag = DisposeBag()
  
  private let dispatcher: Dispatcher
  
  init(dispatcher: Dispatcher) {
    
    self.dispatcher = dispatcher
    state = BehaviorSubject(value: .initial(rates: []))
    baseRate = Variable(initialBase)
    
    event.map { event -> Rate in
      switch event {
      case .baseRateChanged(let new, let text):
        let newValue = CurrencyFormatter(currencyCode: new).number(from: text)
        return Rate(currency: new, value: newValue.floatValue)
      case .baseValueChanged(let newTextValue):
        let currency = self.baseRate.value.currency
        let newValue = CurrencyFormatter(currencyCode: currency).number(from: newTextValue)
        return Rate(currency: currency, value: newValue.floatValue)
      }
    }.bind(to: baseRate)
    .disposed(by: bag)
    
    baseRate.asObservable().map { base -> [Rate] in
      let basePrevIndex = self.currentRates.value.index(of: base)
      var newRates = self.currentRates.value
      guard let prevIndex = basePrevIndex, prevIndex != 0 else { return newRates }
      newRates.insert(newRates.remove(at: prevIndex), at: 0)
      return newRates
    }.bind(to: currentRates)
    .disposed(by: bag)
      
    currentRates.asObservable().subscribeNext { rates in
      rates.forEach { $0.value *= self.baseRate.value.value }
      self.state.onNext(.refresh(rates: rates.map(DisplayRate.init)))
    }.disposed(by: bag)
  }
  
  func requestRates(on interval: Double = 1) -> Observable<RatesState> {
    return Observable<Int>.interval(interval, scheduler: MainScheduler.asyncInstance)
      .flatMap { [weak self] cnt -> Observable<RatesState> in
        guard let `self` = self else { return Observable.just(.loading) }
        let loadableRates = RatesWorker(base: self.baseRate.value.currency).doWork(in: self.dispatcher)
        return loadableRates.map { state in
          switch state {
          case .loaded(let rawRates):
            let group = RatesGroup(with: rawRates)
            let countChanged = self.currentRates.value.count != group.rates.count
            let displayRates = self.makeDisplayRates(with: group.rates, countChanged: countChanged)
            if countChanged {
              return .initial(rates: displayRates)
            } else {
              return .refresh(rates: displayRates)
            }
          case .failed(let error):
            return .failToLoad(error)
          case .loading:
            return .loading
          }
        }
    }
  }
  
  //MARK: refresh state
  private func makeDisplayRates(with newRates: [Rate], countChanged: Bool) -> [DisplayRate] {
    if countChanged {
      currentRates.value = newRates
    } 
    return currentRates.value.map { rate -> Rate in
      let target = newRates.first { $0 == rate }
      if let target = target {
        rate.value = target.value * baseRate.value.value
      }
      return rate
    }.map(DisplayRate.init)
  }
  
  func indexPath(for currencyId: String) -> IndexPath? {
    let index = currentRates.value.index { $0.currency == currencyId }
    return index.map { IndexPath(row: $0, section: 0) }
  }
}
