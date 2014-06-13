//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit

class SLRepoConstraintView: UIView {

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
      let left: Float = 14.0
      let right: Float = 4.0
      let bottom: Float = 4.0
    }
    let padding: Padding
  }

  let metrics = Metrics(padding: Metrics.Padding())

  func configureWithRepo(repo: Repo) {
    self.repo = repo
    self.autoresizingMask = .FlexibleWidth | .FlexibleHeight
    constructViews()
    configureViewsWithRepo(repo)
    constructConstraints(repo)
    self.setNeedsDisplay()
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
      view.setTranslatesAutoresizingMaskIntoConstraints(false)
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

  func constructConstraints(repo: Repo) {
    self.addConstraint(
      NSLayoutConstraint(
        item: views!.ownerImage,
        attribute: .Top,
        relatedBy: .Equal,
        toItem: self,
        attribute: .Top,
        multiplier: 1.0,
        constant: metrics.padding.top
      )
    )
    self.addConstraint(
      NSLayoutConstraint(
        item: views!.ownerImage,
        attribute: .Height,
        relatedBy: .Equal,
        toItem: nil,
        attribute: .NotAnAttribute,
        multiplier: 1.0,
        constant: 100.0
      )
    )
    self.addConstraint(
      NSLayoutConstraint(
        item: views!.ownerImage,
        attribute: .Width,
        relatedBy: .Equal,
        toItem: views!.ownerImage,
        attribute: .Height,
        multiplier: 1.0,
        constant: 0
      )
    )
    self.addConstraint(
      NSLayoutConstraint(
        item: views!.ownerLoginLabel,
        attribute: .Left,
        relatedBy: .Equal,
        toItem: views!.ownerImage,
        attribute: .Right,
        multiplier: 1.0,
        constant: metrics.padding.x
      )
    )
    self.addConstraint(
      NSLayoutConstraint(
        item: views!.ownerLoginLabel,
        attribute: .Baseline,
        relatedBy: .Equal,
        toItem: views!.ownerImage,
        attribute: .Bottom,
        multiplier: 1.0,
        constant: 0
      )
    )
    self.addConstraint(
      NSLayoutConstraint(
        item: views!.repoNameLabel,
        attribute: .Top,
        relatedBy: .Equal,
        toItem: views!.ownerImage,
        attribute: .Bottom,
        multiplier: 1.0,
        constant: metrics.padding.y
      )
    )
    self.addConstraint(
      NSLayoutConstraint(
        item: views!.repoLanguageLabel,
        attribute: .Top,
        relatedBy: .Equal,
        toItem: views!.repoNameLabel,
        attribute: .Bottom,
        multiplier: 1.0,
        constant: metrics.padding.y
      )
    )
    if repo.fork {
      self.addConstraint(
        NSLayoutConstraint(
          item: views!.repoForkImage,
          attribute: .Top,
          relatedBy: .Equal,
          toItem: views!.repoLanguageLabel,
          attribute: .Bottom,
          multiplier: 1.0,
          constant: metrics.padding.y
        )
      )
      views!.repoForkImage.addConstraint(
        NSLayoutConstraint(
          item: views!.repoForkImage,
          attribute: .Height,
          relatedBy: .Equal,
          toItem: nil,
          attribute: .NotAnAttribute,
          multiplier: 1.0,
          constant: 40.0
        )
      )
      views!.repoForkImage.addConstraint(
        NSLayoutConstraint(
          item: views!.repoForkImage,
          attribute: .Width,
          relatedBy: .Equal,
          toItem: views!.repoForkImage,
          attribute: .Height,
          multiplier: 1.0,
          constant: 0
        )
      )
    }

    for view in views!.all {
      if view == views!.repoForkImage && !repo.fork {
        continue
      }
      if view == views!.ownerLoginLabel {
        continue
      }
      addConstraintForLeftEdge(view)
    }
  }

  func addConstraintForLeftEdge(view: UIView) {
    self.addConstraint(
      NSLayoutConstraint(
        item: view,
        attribute: .Left,
        relatedBy: .Equal,
        toItem: self,
        attribute: .Left,
        multiplier: 1.0,
        constant: metrics.padding.left
      )
    )
  }
}
