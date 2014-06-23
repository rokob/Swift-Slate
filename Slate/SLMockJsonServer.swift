//  Copyright (c) 2014 rokob. All rights reserved.

import Foundation

class SLMockJsonServer {

  class func objectFromFile(filename: String) -> Dictionary<String, AnyObject!> {
    var path = NSBundle.mainBundle().pathForResource(filename, ofType: "json")
    var data = NSData.dataWithContentsOfFile(path, options: NSDataReadingOptions.DataReadingMapped, error: nil)
    var response: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
    return response as Dictionary<String, AnyObject!>
  }

  class func arrayFromFile(filename: String) -> Dictionary<String, AnyObject!>[] {
    var path = NSBundle.mainBundle().pathForResource(filename, ofType: "json")
    var data = NSData.dataWithContentsOfFile(path, options: NSDataReadingOptions.DataReadingMapped, error: nil)
    var response: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
    return response as Dictionary<String, AnyObject!>[]
  }

}