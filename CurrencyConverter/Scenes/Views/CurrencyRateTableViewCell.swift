import UIKit
import FlagKit

class CurrencyRateTableViewCell: UITableViewCell {
  
  @IBOutlet weak var iconView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var rateField: UITextField!

  var delegate: CurrencyRateTableViewCellDelegate?
  
  private let textFieldDelegate = CurrencyTextFieldDelegate()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    prepare()
  }
  
  func prepare() {
    
    rateField.delegate = textFieldDelegate
    rateField.addTarget(self, action: #selector(startEditing), for: .editingDidBegin)
    rateField.addTarget(textFieldDelegate, action: #selector(CurrencyTextFieldDelegate.editDidChange), for: .editingChanged)
    textFieldDelegate.editChanged = { [weak self] number in
      guard let `self` = self else {
        return
      }
      self.delegate?.rateValueChanged(to: number?.floatValue ?? 0)
    }
  }
  
  func update(with rate: DisplayRate) {
    iconView.image = rate.flagId.flatMap { Flag(countryCode: $0)?.image(style: .circle) }
    titleLabel.text = rate.currencyCode
    detailLabel.text = rate.currencyName
    rateField.text = rate.formattedValue
  }
  
  @objc private func startEditing() {
    delegate?.becomeBase(currency: titleLabel.text!, value: Float(rateField.text!)!)
  }
}


protocol CurrencyRateTableViewCellDelegate {
  func becomeBase(currency: String, value: Float)
  func rateValueChanged(to value: Float)
}
