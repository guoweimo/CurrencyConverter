

import UIKit

class LoadingView {
  
  lazy private var indicator = { () -> UIActivityIndicatorView in
    let loadingView = UIActivityIndicatorView(style: .whiteLarge)
    return loadingView
  }()
  
  func show(onView view: UIView) {
    indicator.color = UIColor.gray
    indicator.hidesWhenStopped = true
    if(!view.subviews.contains(indicator)) {
      indicator.center = view.center
      view.addSubview(indicator)
    }
    indicator.startAnimating()
  }
  
  func hide(){
    indicator.stopAnimating()
  }
}
