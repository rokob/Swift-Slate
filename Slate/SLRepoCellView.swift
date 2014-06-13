//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit

// class variables are not supported so GLOBAL
var SLRepoCellViewSizeCache = Dictionary<String, CGSize>()

class SLRepoCellView: UIView {

  var repoNameLabel: UILabel!
  var repoLanguageLabel: UILabel!
  var otherLabel: UILabel!
  var cacheKey: String!

  let paddingY: CGFloat = 4.0
  let paddingX: CGFloat = 16.0

  init(frame: CGRect)  {
    super.init(frame: frame)
    constructSubviews()
  }

  func configure(repo: Repo) {
    cacheKey = repo.name
    repoNameLabel.text = repo.name
    repoLanguageLabel.text = repo.language
    otherLabel.text = ""
    if repo.fork {
      otherLabel.text = "This is meant to be some long text" +
        " that does not fit in one line inside a label."
    }
    self.setNeedsLayout()
  }

  func constructSubviews() {
    repoNameLabel = UILabel(frame: CGRectZero)
    repoLanguageLabel = UILabel(frame: CGRectZero)
    otherLabel = UILabel(frame: CGRectZero)

    repoNameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    repoLanguageLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)

    otherLabel.numberOfLines = 0
    otherLabel.lineBreakMode = .ByWordWrapping

    for view in [repoNameLabel, repoLanguageLabel, otherLabel] {
      self.addSubview(view)
    }
  }

  override func sizeThatFits(size: CGSize) -> CGSize {
    if let resultSize = SLRepoCellViewSizeCache[cacheKey] {
      if resultSize.width == size.width {
        return resultSize
      }
    }

    var result = size
    result.height = 0

    var adjustedSize = CGSizeMake(size.width - 2*paddingX, size.height)

    result.height += paddingY
    result.height += repoNameLabel.sizeThatFits(adjustedSize).height
    result.height += paddingY
    result.height += repoLanguageLabel.sizeThatFits(adjustedSize).height
    result.height += paddingY
    result.height += otherLabel.sizeThatFits(adjustedSize).height
    result.height += paddingY

    SLRepoCellViewSizeCache[cacheKey] = result
    return result
  }

  override func layoutSubviews() {
    var frame = self.bounds
    frame.size.width -= 2*paddingX

    var y = paddingY

    var labelFrame = repoNameLabel.sizeThatFits(frame.size)
    repoNameLabel.frame = CGRect(x: paddingX, y: y, width: labelFrame.width, height: labelFrame.height)

    y = CGRectGetMaxY(repoNameLabel.frame) + paddingY

    labelFrame = repoLanguageLabel.sizeThatFits(frame.size)
    repoLanguageLabel.frame = CGRect(x: paddingX, y: y, width: labelFrame.width, height: labelFrame.height)

    y = CGRectGetMaxY(repoLanguageLabel.frame) + paddingY

    labelFrame = otherLabel.sizeThatFits(frame.size)
    otherLabel.frame = CGRect(x: paddingX, y: y, width: labelFrame.width, height: labelFrame.height)
  }
}