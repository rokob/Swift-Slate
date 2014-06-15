//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit

class SLDraggableMenu: UIView {

  let visibleButtonSize: CGFloat = 60
  let compactButtonSize: CGFloat = 40
  let buttonSpacing: CGFloat = 8
  let visibleFirstOrigin = CGPointMake(8, 64+8)
  var compactOrigin: CGPoint
  let animationDuration: CFTimeInterval = 1.1

  struct Buttons {
    var all: UIView[]
    let count: Int

    init(count: Int, size: CGFloat,
      firstPosition: CGPoint, spacing: CGFloat,
      visibleSize: CGFloat, compactSize: CGFloat,
      animationDuration: CFTimeInterval) {
      self.count = count
      all = []
      var offset: CGFloat = 0
      for x in 0..count {
        var frame = CGRectMake(firstPosition.x, firstPosition.y+offset, size, size)
        var view = SLMenuItem(frame: frame, visibleSize: visibleSize, compactSize: compactSize, duration: animationDuration)
        view.backgroundColor = UIColor.blackColor()
        all.append(view)
        offset += size + spacing
      }
    }
  }

  var buttons: Buttons
  var visible: Bool

  init(frame: CGRect) {
    buttons = Buttons(
      count: 5,
      size: visibleButtonSize,
      firstPosition: visibleFirstOrigin,
      spacing: buttonSpacing,
      visibleSize: visibleButtonSize,
      compactSize: compactButtonSize,
      animationDuration: animationDuration
    )
    visible = true
    var compactOriginY = UIScreen.mainScreen().bounds.size.height - compactButtonSize - buttonSpacing - visibleFirstOrigin.y
    compactOrigin = CGPointMake(visibleFirstOrigin.x, compactOriginY)
    super.init(frame: frame)
    for view in buttons.all {
      self.addSubview(view)
      var tappy = UITapGestureRecognizer(target: self, action: Selector("didTap:"))
      view.addGestureRecognizer(tappy)
    }
  }

  func didTap(gestureRecognizer: UITapGestureRecognizer) {
    visible = !visible
    UIView.animateWithDuration(animationDuration,
      delay: 0,
      usingSpringWithDamping: 1.2,
      initialSpringVelocity: 3,
      options: .AllowUserInteraction,
      animations: {
        var offset: CGFloat = self.visible ? self.visibleButtonSize/2 : self.compactOrigin.y + self.compactButtonSize/2
        var color = self.visible ? UIColor.blackColor() : UIColor.lightGrayColor()
        var alpha: CGFloat = self.visible ? 1.0 : 0.3
        var oldSize: CGFloat = !self.visible ? self.visibleButtonSize : self.compactButtonSize
        var size: CGFloat = self.visible ? self.visibleButtonSize : self.compactButtonSize
        for button in self.buttons.all {
          button.backgroundColor = color
          button.alpha = alpha
          button.frame.size = CGSizeMake(size, size)
          button.center = CGPointMake(button.center.x, 64 + 8 + offset)
          button.layer.cornerRadius = size/2
          if self.visible {
            offset += self.visibleButtonSize + self.buttonSpacing
          }
        }
      },
      completion: {(finished: Bool) -> Void in
      }
    )
  }

  override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView! {
    for button in buttons.all {
      var bounds = button.layer.presentationLayer().frame
      if CGRectContainsPoint(bounds, point) {
        return button
      }
    }
    return super.hitTest(point, withEvent: event)
  }

}
