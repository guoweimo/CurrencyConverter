
import UIKit
import RxSwift

class TextField: UITextField {
  let bag = DisposeBag()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func addBottomBorder(width: CGFloat) {
    let bottomBorder = CALayer()
    bottomBorder.frame = CGRect(x: 0, y: frame.height - 1, width: width, height: 1)
    bottomBorder.backgroundColor = UIColor.lightGray.cgColor
    layer.addSublayer(bottomBorder)
    
    rx.controlEvent(.editingDidBegin).bind {
      bottomBorder.backgroundColor = UIColor.blue.cgColor
    }.disposed(by: bag)
    
    rx.controlEvent(.editingDidEnd).bind {
      bottomBorder.backgroundColor = UIColor.lightGray.cgColor
    }.disposed(by: bag)
  }
}
