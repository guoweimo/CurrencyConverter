
import Foundation
import RxSwift

enum State {
  case initial(rates: [DisplayRate])
  case refresh(rates: [DisplayRate])
  case failToLoad(Error?)
}

enum Event {
  case baseCurrencyChanged(newBase: String)
  case baseValueChanged(newValue: String)
}

class CurrencyRowViewModel {
  
  private var timer: Timer?
  private let base = Variable<String>(.defaultCurrency)
  
  let baseValue = Variable<Float>(1)
  private var currentRates: [Rate] = []
  private let bag = DisposeBag()
  private let dispatcher = NetworkDispatcher<RawRates>(environment: Environment.test)
  
  let state: BehaviorSubject<State>
  let event = PublishSubject<Event>()
  
  init() {
    
    state = BehaviorSubject(value: .initial(rates: []))
    event.subscribeNext { [weak self] s in
      guard let `self` = self else { return }
      switch s {
      case .baseCurrencyChanged(let new):
        self.base.value = new
        self.updateRatesOnBaseCurrencyChanged(to: new)
      case .baseValueChanged(let newTextValue):
        let currencyFormatter = CurrencyFormatter(currencyCode: self.base.value)
        let newValue = currencyFormatter.number(from: newTextValue)
        self.baseValue.value = newValue.floatValue
        self.updateRatesOnBaseValueChanged(to: newValue)
      }
    }.disposed(by: bag)
  }
  
  func requestRates(on interval: Double = 1) {
    timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {
      [weak self] t in
      guard let `self` = self else {
        t.invalidate()
        return
      }
      do {
        try self.dispatcher.fetch(request: APIRequest.rates(base: self.base.value), completion: { (response) in
          switch response {
          case .data(let rawRates):
            let group = RatesGroup(with: rawRates)
            let countChanged = self.hasRatesCountChanged(newRates: group.rates)
            if countChanged {
              let displayRates = self.resetCurrentRates(with: group.rates)
              self.state.onNext(.initial(rates: displayRates))
            } else {
              let displayRates = self.updateCurrentRates(with: group.rates)
              self.state.onNext(.refresh(rates: displayRates))
            }
          case .error(let error):
            self.state.onNext(.failToLoad(error))
          }
        })
      } catch {
        self.state.onNext(.failToLoad(error))
      }
    }
  }
  
  private func updateRatesOnBaseCurrencyChanged(to newCurrency: String) {
    let basePrevIndex = currentRates.index {
      $0.currency == newCurrency
    }
    guard let prevIndex = basePrevIndex else { return }
    currentRates.swapAt(prevIndex, 0)
    baseValue.value = currentRates[0].value
    let displayRates = currentRates.map(DisplayRate.init)
    state.onNext(.refresh(rates: displayRates))
  }
  
  private func updateRatesOnBaseValueChanged(to newValue: NSNumber) {
    currentRates.forEach {
      $0.value *= newValue.floatValue
    }
    let displayRates = currentRates.map(DisplayRate.init)
    state.onNext(.refresh(rates: displayRates))
  }
  
  private func resetCurrentRates(with newRates: [Rate]) -> [DisplayRate] {
    currentRates = newRates
    return currentRates.map(DisplayRate.init)
  }
  
  private func updateCurrentRates(with newRates: [Rate]) -> [DisplayRate] {
    
    currentRates.forEach { rate in
      let target = newRates.first { $0 == rate }
      if let target = target {
         rate.value = target.value * baseValue.value
      }
    }
    return currentRates.map(DisplayRate.init)
  }
  
  //check if rates count change. should only happens in the first time from 0 to count.
  //if happens in other time, mean the API return different currencies.
  private func hasRatesCountChanged(newRates: [Rate]) -> Bool {
    return currentRates.count != newRates.count
  }
  
  deinit {
    timer?.invalidate()
  }
  
}
