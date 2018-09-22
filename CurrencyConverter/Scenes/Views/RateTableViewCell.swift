import UIKit
import FlagKit
import RxSwift

class RateTableViewCell: UITableViewCell {
  
  @IBOutlet weak var iconView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var valueField: TextField!
  
  @IBOutlet weak var valueFieldWidthConstraint: NSLayoutConstraint!
  private(set) var currencyId: String?
  private let textFieldDelegate = CurrencyTextFieldDelegate()
  private let bag = DisposeBag()
  weak var delegate: CurrencyRateTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    prepare()
  }
  
  override func draw(_ rect: CGRect) {
    valueField.addBottomBorder(width: valueFieldWidthConstraint.constant)
  }
  
  private func prepare() {
    valueField.delegate = textFieldDelegate
    valueField.rx.controlEvent(.editingDidBegin).bind { [weak self] in
      guard let `self` = self, let currencyId = self.currencyId else { return }
      let text = self.valueField.text ?? ""
      self.delegate?.becomeBase(currencyId, with: text)
      }.disposed(by: bag)
    
    valueField.rx.controlEvent(.editingChanged).bind { [weak self] in
      guard let `self` = self else { return }
      let text = self.valueField.text ?? ""
      self.delegate?.rateTextChanged(to: text)
    }.disposed(by: bag)
  }
  
  func startEditing() {
    valueField.becomeFirstResponder()
  }
  
  func update(with rate: DisplayRate) {
    currencyId = rate.currencyId
    iconView.image = rate.flagId.flatMap { Flag(countryCode: $0)?.image(style: .circle) }
    titleLabel.text = rate.currencyCode
    detailLabel.text = rate.currencyName
    if !valueField.isFirstResponder {
      valueField.text = rate.formattedValue
    }
  }
}
