//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit
import QuartzCore

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
  var duration: CFTimeInterval

  init(frame: CGRect, visibleSize: CGFloat, compactSize: CGFloat, duration: CFTimeInterval) {
    self.visibleSize = visibleSize
    self.compactSize = compactSize
    self.duration = duration
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

}