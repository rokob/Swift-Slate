//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit


class SLFeedDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
  func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
    if !cell {
      cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
    }
    cell.textLabel.text = "Row: \(indexPath.row)"
    return cell
  }

  func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
    println(indexPath)
    if indexPath.row == 3 {
      var manager = AFHTTPRequestOperationManager()
      manager.GET("http://www.andrewledvina.com",
        parameters: nil,
        success: {(_: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
          println(response)
        },
        failure: {(_: AFHTTPRequestOperation!, error: NSError!) -> Void in
          println(error)
      })
    }
  }
}