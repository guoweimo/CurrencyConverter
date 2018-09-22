

import UIKit

class LoadingView {
  lazy private var indicator = {
    UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  }()
  
  func show(onView view: UIView) {
    indicator.color = UIColor.gray
    indicator.hidesWhenStopped = true
    if(!view.subviews.contains(indicator)) {
      indicator.center = view.center
      indicator.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin,.flexibleTopMargin]
      view.addSubview(indicator)
    }
    indicator.startAnimating()
  }
  
  func hide(){
    indicator.stopAnimating()
  }
}
