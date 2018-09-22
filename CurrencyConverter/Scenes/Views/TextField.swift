
import UIKit
import RxSwift

class TextField: UITextField {
  let bag = DisposeBag()
//  let bottomBorder = CALayer()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func addBottomBorder() {
//    bottomBorder.frame = CGRect(x: 0, y: frame.height - 1, width: width, height: 1)
//    bottomBorder.backgroundColor = UIColor.lightGray.cgColor
//    layer.addSublayer(bottomBorder)
    
    rx.controlEvent(.editingDidBegin).bind {
//      self.bottomBorder.backgroundColor = UIColor.blue.cgColor
    }.disposed(by: bag)
    
    rx.controlEvent(.editingDidEnd).bind {
//      self.bottomBorder.backgroundColor = UIColor.lightGray.cgColor
    }.disposed(by: bag)
  }
}
