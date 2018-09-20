import UIKit
import FlagKit

class CurrencyRateTableViewCell: UITableViewCell {
  
  @IBOutlet weak var iconView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var valueField: TextField!
  
  @IBOutlet weak var valueFieldWidthConstraint: NSLayoutConstraint!
  private(set) var currencyId: String?
  
  private var textFieldDelegate: UITextFieldDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    valueField.addBottomBorder(width: valueFieldWidthConstraint.constant)
  }
  
  override func draw(_ rect: CGRect) {
  }
  
  func update(with rate: DisplayRate) {
    if currencyId != rate.currencyId {
      currencyId = rate.currencyId
      iconView.image = rate.flagId.flatMap { Flag(countryCode: $0)?.image(style: .circle) }
      titleLabel.text = rate.currencyCode
      detailLabel.text = rate.currencyName
    }
    valueField.text = rate.formattedValue
    valueField.delegate = CurrencyTextFieldDelegate(currencyCode: rate.currencyCode)
  }
}
