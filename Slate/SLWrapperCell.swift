//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit

class SLWrapperCell: UITableViewCell {

  var innerView: UIView

  init(identifier: String, view: UIView) {
    innerView = view
    super.init(style: .Default, reuseIdentifier: identifier)
    self.contentView.addSubview(view)
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  override func sizeThatFits(size: CGSize) -> CGSize {
    return innerView.sizeThatFits(size)
  }

  override func layoutSubviews() {
    innerView.frame = self.bounds
  }
}
