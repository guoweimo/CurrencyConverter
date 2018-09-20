import UIKit
import RxSwift

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
        case .baseCurrencyChanged:
          break
        case .baseValueChanged(let newValue):
          break
        case .failToLoad(let error):
          break
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
}

extension CurrencyListViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return displayRates.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CurrencyRateTableViewCell {
      cell.update(with: displayRates[indexPath.row])
      cell.delegate = self
      return cell
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if let cell = self.tableView.cellForRow(at: indexPath) as? CurrencyRateTableViewCell {
      becomeBase(currency: cell.titleLabel.text!)
    }
  }
}

extension CurrencyListViewController: CurrencyRateTableViewCellDelegate {
  
  func rateTextChanged(to value: String) {
    viewModel.state.onNext(.baseValueChanged(newValue: value))
  }
  
  func becomeBase(currency: String) {
    viewModel.state.onNext(.baseCurrencyChanged(newBase: currency))
  }
  
}

