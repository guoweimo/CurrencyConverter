import UIKit
import RxSwift
import RxCocoa

class RatesListViewController: UITableViewController {
  
  private let cellId = String(describing: RateTableViewCell.self)
  private let viewModel: RatesViewModel
  private let bag = DisposeBag()
  private var displayRates: [DisplayRate] = []
  
  private let loadingView = LoadingView()
  
  init(viewModel: RatesViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorStyle = .none
    tableView.keyboardDismissMode = .interactive
    tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    updateViewOnRatesChanged()
  }
  
  func updateViewOnRatesChanged() {
    viewModel.requestRatesRegularly().subscribeNext {
      [weak self] state in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        self.loadingView.hide()
        switch state {
        case .initial(let rates):
          self.displayRates = rates
          self.tableView.reloadData()
        case .refresh(let rates):
          self.displayRates = rates
          self.updateTableView(with: rates)
        case .failToLoad(let error):
          AlertController.showError(with: error?.localizedDescription ?? .standardRatesError,
                                    on: self)
        case .loading:
          if self.displayRates.isEmpty {
            self.loadingView.show(onView: self.tableView)
          }
        }
      }
    }.disposed(by: bag)
  }
  
  func updateTableView(with rates: [DisplayRate]) {
    guard rates.count == tableView.numberOfRows(inSection: 0) else {
      fatalError(.unmatchedTableRowsCount)
    }
    rates.enumerated().forEach { index, rate in
      if let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? RateTableViewCell {
        cell.update(with: rate)
      }
    }
  }
  
  func baseCellDidChanged(with currencyId: String, and text: String, at indexPath: IndexPath) {
    viewModel.event.onNext(.baseRateChanged(to: currencyId, text: text))
    UIView.animate(withDuration: 0.5, animations: {
      self.tableView.moveRow(at: indexPath, to: .zero)
    })
  }
}

extension RatesListViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return displayRates.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? RateTableViewCell {
      cell.update(with: displayRates[indexPath.row])
      cell.delegate = self
      return cell
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if let cell = tableView.cellForRow(at: indexPath) as? RateTableViewCell {
      cell.startEditing()
    }
  }
}

extension RatesListViewController: RateTableViewCellDelegate {
  func becomeBase(_ currency: String, with text: String) {
    if let indexPath = viewModel.indexPath(for: currency) {
      baseCellDidChanged(with: currency, and: text, at: indexPath)
    }
  }
  
  func rateTextChanged(to text: String) {
    viewModel.event.onNext(.baseValueChanged(newValue: text))
  }
}
