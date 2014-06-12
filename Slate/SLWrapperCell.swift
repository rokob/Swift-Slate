//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit

class SLWrapperCell: UITableViewCell {

  var view: UIView

  init(identifier: String, view: UIView) {
    self.view = view
    super.init(style: .Default, reuseIdentifier: identifier)
    self.contentView.addSubview(view)
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  override func sizeThatFits(size: CGSize) -> CGSize {
    return view.sizeThatFits(size)
  }

  override func layoutSubviews() {
    view.frame = self.bounds
  }
}
