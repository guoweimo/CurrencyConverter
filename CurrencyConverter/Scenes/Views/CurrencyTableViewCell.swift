import UIKit

final class CurrencyTableViewCell: UITableViewCell {
  private let flagView = UIImageView()
  private let currencyShortLabel = UILabel()
  private let currencyFullLabel = UILabel()
  private let valueInputField = UITextField()
  private let stackView = UIStackView()
  
  struct Model: TypedCellHandler {
    
    var currencyName: String
    var currencyDetail: String
    var value: String
    var controller: TextFieldController?
    
    var select: Action? {
      guard let controller = controller else {
        return nil
      }
      return {
        controller.startEditing()
      }
    }

    func prepare(_ cell: CurrencyTableViewCell) {
      cell.currencyShortLabel.text = currencyName
      cell.currencyFullLabel.text = currencyDetail
      cell.valueInputField.text = value
    }
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    prepare()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepare()
  }
  
  private func prepare() {
    let currencyStackView = UIStackView(arrangedSubviews: [currencyShortLabel, currencyFullLabel])
    currencyStackView.axis = .vertical
    currencyStackView.alignment = .leading
    
    valueInputField.setContentHuggingPriority(.almostRequired, for: .horizontal)
    valueInputField.setContentCompressionResistancePriority(.almostRequired, for: .horizontal)
    valueInputField.textAlignment = .right
    valueInputField.borderStyle = .line
    valueInputField.keyboardType = .decimalPad
    
    [flagView, currencyStackView, valueInputField].forEach(stackView.addArrangedSubview)
    
    contentView.addSubview(stackView)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentView.layoutMarginsGuide.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
      contentView.layoutMarginsGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
      contentView.layoutMarginsGuide.topAnchor.constraint(equalTo: stackView.topAnchor),
      contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
    ])

  }
}


extension UILayoutPriority {
  static let almostRequired = UILayoutPriority(rawValue: 950)
}
