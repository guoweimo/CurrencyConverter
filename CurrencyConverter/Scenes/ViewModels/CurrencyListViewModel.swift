
import Foundation
import RxSwift

enum State {
  case initial(rates: [DisplayRate])
  case refresh(rates: [DisplayRate])
  case baseCurrencyChanged(newBase: String)
  case baseValueChanged(newValue: String)
  case failToLoad(Error?)
}

class CurrencyRowViewModel {
  
  private var timer: Timer?
  private let base = Variable<String>(.defaultCurrency)
  private var baseValue: Float = 1
  private(set) var currentRates: [Rate] = []
  private let bag = DisposeBag()
  private let dispatcher = NetworkDispatcher<RawRates>(environment: Environment.test)
  
  let state: BehaviorSubject<State>
  
  init() {
    
    state = BehaviorSubject(value: .initial(rates: []))
    state.subscribeNext { [weak self] s in
      guard let `self` = self else { return }
      switch s {
      case .baseCurrencyChanged(let new):
        self.updateRatesOnBaseCurrencyChange(to: new)
      default:
        break
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
  
  private func updateRatesOnBaseCurrencyChange(to newCurrency: String) {
      let basePrevIndex = self.currentRates.index {
        $0.currency == newCurrency
      }
      guard let prevIndex = basePrevIndex else { return }
      self.currentRates.swapAt(prevIndex, 0)
  }
  
  private func resetCurrentRates(with newRates: [Rate]) -> [DisplayRate] {
    currentRates = newRates
    return currentRates.map(DisplayRate.init)
  }
  
  private func updateCurrentRates(with newRates: [Rate]) -> [DisplayRate] {
    
    currentRates.forEach { rate in
      let target = newRates.first { $0 == rate }
      if let target = target {
         rate.value = target.value
      }
    }
    return currentRates.map(DisplayRate.init)
  }
  
  //check if rates count change. should only happens in the first time from 0 to count.
  //if happens in other time, mean the API return different currencies.
  private func hasRatesCountChanged(newRates: [Rate]) -> Bool {
    return self.currentRates.count != newRates.count
  }
  
  deinit {
    timer?.invalidate()
  }
  
}
