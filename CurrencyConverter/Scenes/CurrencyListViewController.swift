import UIKit
import RxSwift
import RxCocoa

class CurrencyListViewController: UITableViewController {
  
  let cellId = NSStringFromClass(CurrencyRateTableViewCell.self)
  private let viewModel: CurrencyRowViewModel
  private let bag = DisposeBag()
  private var displayRates: [DisplayRate] = []
  
  init(viewModel: CurrencyRowViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "CurrencyRateTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    viewModel.requestRates()
    updateViewOnStateChanged()
  }
  
  func updateViewOnStateChanged() {
    viewModel.state.subscribeNext { [weak self] state in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        switch state {
        case .initial(let rates):
          self.displayRates = rates
          self.tableView.reloadData()
        case .refresh(let rates):
          self.updateTableView(with: rates)
        case .failToLoad(let error):
          AlertController.showError(with: error?.localizedDescription ?? .standardRatesError,
                                    on: self)
        }
      }
    }.disposed(by: bag)
  }
  
  func updateTableView(with rates: [DisplayRate]) {
    guard rates.count == tableView.numberOfRows(inSection: 0) else {
      fatalError("unmatched number of currencies and table rows!")
    }
    rates.enumerated().forEach { index, rate in
      if let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? CurrencyRateTableViewCell {
        cell.update(with: rate)
      }
    }
  }
  
  func baseCellDidChanged(with currencyId: String, at indexPath: IndexPath) {
    viewModel.event.onNext(.baseCurrencyChanged(newBase: currencyId))
    UIView.animate(withDuration: 0.5, animations: {
      self.tableView.moveRow(at: indexPath, to: .zero)
    })
  }
}

extension CurrencyListViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return displayRates.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CurrencyRateTableViewCell {
      cell.update(with: displayRates[indexPath.row])
      
      cell.valueField.rx.controlEvent(.editingDidBegin).bind { [weak self] in
        guard let `self` = self, let currencyId = cell.currencyId else { return }
        self.baseCellDidChanged(with: currencyId, at: indexPath)
      }.disposed(by: bag)
      
      cell.valueField.rx.controlEvent(.editingChanged).bind { [weak self] in
        guard let `self` = self else { return }
        let text = cell.valueField.text ?? ""
        self.viewModel.event.onNext(.baseValueChanged(newValue: text))
      }.disposed(by: bag)
      
      return cell
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if let cell = tableView.cellForRow(at: indexPath) as? CurrencyRateTableViewCell {
      guard let currencyId = cell.currencyId else { return }
      baseCellDidChanged(with: currencyId, at: indexPath)
    }
  }
}
