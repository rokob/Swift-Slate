//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit

class SLRepoView: UIView {

  var repo: Repo?
  var views: Subviews? 
  var constructed: Bool = false

  struct Subviews {
    let ownerImage: UIImageView
    let ownerLoginLabel: UILabel
    let repoNameLabel: UILabel
    let repoForkImage: UIImageView
    let repoLanguageLabel: UILabel

    var all: UIView[] {
      get {
        return [
          ownerImage,
          ownerLoginLabel,
          repoNameLabel,
          repoForkImage,
          repoLanguageLabel
        ]
      }
    }
  }

  struct Metrics {
    struct Padding {
      let x: Float = 12.0
      let y: Float = 12.0
      let top: Float = 68.0 // Hack
      let left: Float = 4.0
      let right: Float = 4.0
      let bottom: Float = 4.0
    }
    let padding: Padding
  }

  let metrics = Metrics(padding: Metrics.Padding())

  func configureWithRepo(repo: Repo) {
    self.repo = repo
    constructViews()
    configureViewsWithRepo(repo)
    self.setNeedsDisplay()
  }

  override func layoutSubviews() {
    var bounds = self.frame.size

    var x = metrics.padding.left
    var y = metrics.padding.top
    var frame: CGRect

    frame = CGRectMake(x, y, 100, 100)
    views!.ownerImage.frame = frame

    y = CGRectGetMaxY(frame)
    x = CGRectGetMaxX(frame) + metrics.padding.x
    var maxSize = CGSizeMake(bounds.width - x, bounds.height)
    var labelSize = views!.ownerLoginLabel.sizeThatFits(maxSize)
    var descent = views!.ownerLoginLabel.font.descender
    frame = CGRectMake(x, y - labelSize.height - descent, labelSize.width, labelSize.height)
    views!.ownerLoginLabel.frame = frame

    y = CGRectGetMaxY(frame) + metrics.padding.y
    x = metrics.padding.left
    maxSize = CGSizeMake(bounds.width - x, bounds.height)
    labelSize = views!.repoNameLabel.sizeThatFits(maxSize)
    frame = CGRectMake(x, y, labelSize.width, labelSize.height)
    views!.repoNameLabel.frame = frame

    y = CGRectGetMaxY(frame) + metrics.padding.y
    x = metrics.padding.left
    maxSize = CGSizeMake(bounds.width - x, bounds.height)
    labelSize = views!.repoLanguageLabel.sizeThatFits(maxSize)
    frame = CGRectMake(x, y, labelSize.width, labelSize.height)
    views!.repoLanguageLabel.frame = frame

    if repo?.fork {
      y = CGRectGetMaxY(frame) + metrics.padding.y
      x = metrics.padding.left
      frame = CGRectMake(x, y, 40, 40)
      views!.repoForkImage.frame = frame
    } else {
      views!.repoForkImage.frame = CGRectZero
    }
  }

  func constructViews() {
    if constructed {
      return
    }
    constructed = true

    views = Subviews(
      ownerImage: UIImageView(),
      ownerLoginLabel: UILabel(frame: CGRectZero),
      repoNameLabel: UILabel(frame: CGRectZero),
      repoForkImage: UIImageView(image: UIImage(named: "git-fork")),
      repoLanguageLabel: UILabel(frame: CGRectZero)
    )

    for view in views!.all {
      self.addSubview(view)
    }
  }

  func configureViewsWithRepo(repo: Repo) {
    views!.ownerImage.setImageWithURL(NSURL(string: repo.owner.avatar_url))
    views!.ownerImage.contentMode = UIViewContentMode.ScaleAspectFit
    views!.ownerLoginLabel.text = repo.owner.login
    views!.repoNameLabel.text = repo.name
    views!.repoLanguageLabel.text = repo.language

    if repo.fork {
      views!.repoForkImage.contentMode = UIViewContentMode.ScaleAspectFit
    } else {
      views!.repoForkImage.removeFromSuperview()
    }
  }
}
