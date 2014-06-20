//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit

class SLDraggableMenu: UIView, SLMenuItemDelegate {

  let visibleButtonSize: CGFloat = 60
  let compactButtonSize: CGFloat = 40
  let buttonSpacing: CGFloat = 8
  let visibleFirstOrigin = CGPointMake(8, 64+8)
  var compactOrigin: CGPoint
  let animationDuration: CFTimeInterval = 1.1

  struct Buttons {
    var all: SLMenuItem[]
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
        var view = SLMenuItem(frame: frame, name: "\(x)", visibleSize: visibleSize, compactSize: compactSize, duration: animationDuration)
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
      var tappy = UITapGestureRecognizer(target: self, action: Selector("didTap:"))
      view.addGestureRecognizer(tappy)
      view.delegate = self
      self.addSubview(view)
    }
  }

  func didTap(gestureRecognizer: UITapGestureRecognizer) {
    visible = !visible
    var item = gestureRecognizer.view
    var origSize = item.frame.size.width
    var bigSize = origSize*1.1
    var smallSize = origSize*0.9
    var duration: NSTimeInterval = 0.2
    if !visible {
      didSelectItem(item as SLMenuItem)
      UIView.animateWithDuration(
        duration*2,
        animations: {
          item.frame.size = CGSizeMake(bigSize, bigSize)
          item.layer.cornerRadius = bigSize/2
          item.backgroundColor = UIColor.blueColor()
        },
        completion: {(finished: Bool) in
          UIView.animateWithDuration(
            duration,
            animations: {
              item.frame.size = CGSizeMake(smallSize, smallSize)
              item.layer.cornerRadius = smallSize/2
            },
            completion: {(finished: Bool) in
              self.animateItems(velocity: 3)
            }
          )
        }
      )
    } else {
      animateItems(velocity: 3)
    }
  }

  func clamped(velocity: CGFloat) -> CGFloat {
    return velocity < 1 ? 1 : velocity > 10 ? 10 : velocity
  }

  func animateItems(#velocity: CGFloat) {
    UIView.animateWithDuration(animationDuration,
      delay: 0,
      usingSpringWithDamping: 1.2,
      initialSpringVelocity: clamped(velocity),
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
          button.center = CGPointMake(self.visibleFirstOrigin.x + size/2, 64 + 8 + offset)
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

  func menuItemDidBeginDragging(item: SLMenuItem) {
    if visible {
      didSelectItem(item)
      UIView.animateWithDuration(0.2) {
        item.backgroundColor = UIColor.greenColor()
      }
    }
  }

  func menuItemDidDrag(item: SLMenuItem, point: CGPoint, timestamp: NSTimeInterval) {
    item.center = point
  }

  func menuItemDidEndDragging(item: SLMenuItem, velocity: CGPoint) {
    visible = velocity.y < 0
    animateItems(velocity: fabsf(velocity.y))
  }

  func didSelectItem(item: SLMenuItem) {
    println("SELECTED \(item.name)")
  }

}
