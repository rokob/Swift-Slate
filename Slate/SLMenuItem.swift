//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit
import QuartzCore

@objc protocol SLMenuItemDelegate {
  func menuItemDidBeginDragging(item: SLMenuItem)
  func menuItemDidDrag(item: SLMenuItem, point: CGPoint, timestamp: NSTimeInterval)
  func menuItemDidEndDragging(item: SLMenuItem, velocity: CGPoint)
}

class SLMenuItem: UIView {

  class CornerRadiusAction: NSObject, CAAction {

    var visibleSize: CGFloat
    var compactSize: CGFloat
    var timingFunction: CAMediaTimingFunction
    var duration: CFTimeInterval

    init(visibleSize: CGFloat, compactSize: CGFloat, timingFunction: CAMediaTimingFunction, duration: CFTimeInterval) {
      self.visibleSize = visibleSize
      self.compactSize = compactSize
      self.timingFunction = timingFunction
      self.duration = duration
      super.init()
    }

    func runActionForKey(event: String!, object anObject: AnyObject!, arguments dict: NSDictionary!) {
      if event == "cornerRadius" {
        var layer = anObject as CALayer
        if !layer.presentationLayer() {
          return
        }
        var size = layer.bounds.size.width
        var oldSize = size == visibleSize ? compactSize : visibleSize
        var animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = timingFunction
        animation.fromValue = oldSize/2
        animation.toValue = size/2
        animation.duration = duration*0.7
        layer.addAnimation(animation, forKey: "cornerRadius")
        animation.removedOnCompletion = false
      }

    }
  }

  var visibleSize: CGFloat
  var compactSize: CGFloat
  var name: String
  var duration: CFTimeInterval
  var touches: (CGPoint, CGPoint)
  var timestamps: (NSTimeInterval, NSTimeInterval)
  weak var delegate: SLMenuItemDelegate?
  var dragging: Bool

  init(frame: CGRect, name: String, visibleSize: CGFloat, compactSize: CGFloat, duration: CFTimeInterval) {
    self.visibleSize = visibleSize
    self.compactSize = compactSize
    self.name = name
    self.duration = duration
    self.touches = (CGPointZero, CGPointZero)
    self.timestamps = (0, 0)
    self.dragging = false
    super.init(frame: frame)
    self.layer.cornerRadius = visibleSize/2
  }

  override func actionForLayer(layer: CALayer!, forKey event: String!) -> CAAction!  {
    if event == "cornerRadius" {
      return CornerRadiusAction(
        visibleSize: visibleSize,
        compactSize: compactSize,
        timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault),
        duration: duration
      )
    }

    return super.actionForLayer(layer, forKey: event)
  }

  override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
    self.touches.1 = touches.anyObject().locationInView(superview)
    self.timestamps.1 = event.timestamp
  }

  override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
    if !dragging {
      dragging = true
      delegate?.menuItemDidBeginDragging(self)
    }
    var location = touches.anyObject().locationInView(superview)
    self.touches = (self.touches.1, location)
    self.timestamps = (self.timestamps.1, event.timestamp)
    delegate?.menuItemDidDrag(self, point: self.touches.1, timestamp: self.timestamps.1)
  }

  override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
    dragging = false
    var velocityX: CGFloat = (self.touches.1.x - self.touches.0.x) / CGFloat(self.timestamps.1 - self.timestamps.0)
    var velocityY: CGFloat = (self.touches.1.y - self.touches.0.y) / CGFloat(self.timestamps.1 - self.timestamps.0)
    delegate?.menuItemDidEndDragging(self, velocity: CGPointMake(velocityX, velocityY))
  }

}