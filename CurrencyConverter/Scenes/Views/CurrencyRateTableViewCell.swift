import UIKit
import FlagKit

class CurrencyRateTableViewCell: UITableViewCell {
  
  @IBOutlet weak var iconView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var rateField: UITextField!

  var delegate: CurrencyRateTableViewCellDelegate?
  
  private var textFieldDelegate: UITextFieldDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    prepare()
  }
  
  func prepare() {
    
    rateField.addTarget(self, action: #selector(startEditing), for: .editingDidBegin)
    rateField.addTarget(self, action: #selector(editDidChange), for: .editingChanged)
  }
  
  func update(with rate: DisplayRate) {
    iconView.image = rate.flagId.flatMap { Flag(countryCode: $0)?.image(style: .circle) }
    titleLabel.text = rate.currencyCode
    detailLabel.text = rate.currencyName
    rateField.text = rate.formattedValue
    rateField.delegate = CurrencyTextFieldDelegate(currencyCode: rate.currencyCode)
  }
  
  @objc private func editDidChange() {
    delegate?.rateTextChanged(to: rateField.text ?? "")
  }
  
  @objc private func startEditing() {
    delegate?.becomeBase(currency: titleLabel.text!)
  }
}


protocol CurrencyRateTableViewCellDelegate {
  func becomeBase(currency: String)
  func rateTextChanged(to text: String)
}
