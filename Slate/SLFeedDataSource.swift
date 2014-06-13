//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit

let FAKE_DATA = true

struct Repos {
  var repos: Repo[]
}

@objc protocol SLFeedDataSourceDelegate {
  func didReceiveData() -> Void
  func didSelectRepo(index: Int, fork: Bool) -> Void
}

class SLFeedDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {

  var data: Repos
  weak var delegate: SLFeedDataSourceDelegate?
  var cache: Dictionary<String, Repos>

  init() {
    data = Repos(repos: [])
    cache = [:]
    super.init()
  }

//  func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
//    var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
//    if !cell {
//      cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
//    }
//
//    var repo = data.repos.filter({(r: Repo) -> Bool in return r.fork == (1 == indexPath.section)})[indexPath.row]
//    cell.textLabel.text = "Name: \(repo.name)"
//    cell.detailTextLabel.text = "Language: \(repo.language)"
//    return cell
//  }

  func tableView(tableView: UITableView!, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    return 54.5
  }

  func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    var cell = tableView.dequeueReusableCellWithIdentifier("SLRepoCell") as SLWrapperCell!
    if !cell {
      cell = SLWrapperCell(identifier: "SLRepoCell", view: SLRepoCellView(frame: CGRectZero))
    }
    var repo = data.repos.filter({(r: Repo) -> Bool in return r.fork == (1 == indexPath.section)})[indexPath.row]

    (cell.view as SLRepoCellView).configure(repo)
    cell.setNeedsLayout()

    return cell
  }

  func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return data.repos.filter({(r: Repo) -> Bool in return !r.fork}).count
    } else {
      return data.repos.filter({(r: Repo) -> Bool in return r.fork}).count
    }
  }

  func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
    if section == 0 {
      return "User's Repos"
    } else {
      return "Forks"
    }
  }

  func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
    return 2
  }

  func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    delegate?.didSelectRepo(indexPath.row, fork: indexPath.section == 1)
  }

  func repoAtIndex(index: Int, fork: Bool) -> Repo {
    return data.repos.filter({(r: Repo) -> Bool in return r.fork == fork})[index]
  }

  func loadData(username: String) {
    if let result = cache[username] {
      handleData(username, repos: result)
      return
    }

    if FAKE_DATA {
      handleFakeData(username)
      return
    }

    var manager = AFHTTPRequestOperationManager()
    manager.responseSerializer = AFJSONResponseSerializer()
    manager.GET("https://api.github.com/users/\(username)/repos",
      parameters: nil,
      success: {(_: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        if response is Dictionary<String, AnyObject!>[] {
          var parsedData = self.parseResponse(response as Dictionary<String, AnyObject!>[])
          var repos = Repos(repos: parsedData)
          self.cache[username] = repos
          self.handleData(username, repos: repos)
        } else {
          self.cache[username] = Repos(repos: [])
          self.handleUnknown(username)
        }
      },
      failure: {(_: AFHTTPRequestOperation!, error: NSError!) -> Void in
        println(error)
      })
  }

  func parseResponse(response: Dictionary<String, AnyObject!>[]) -> Repo[] {
    return response.map(Repo.fromJSON)
  }

  func handleData(username: String, repos: Repos) {
    dispatch_async(dispatch_get_main_queue()) {
      self.data = repos
      self.delegate?.didReceiveData()
    }
  }

  func handleUnknown(username: String) {

  }

  func handleFakeData(username: String) {
    var path = NSBundle.mainBundle().pathForResource("rokob", ofType: "json")
    var rokobData = NSData.dataWithContentsOfFile(path, options: NSDataReadingOptions.DataReadingMapped, error: nil)
    var response: AnyObject! = NSJSONSerialization.JSONObjectWithData(rokobData, options: NSJSONReadingOptions.MutableContainers, error: nil)
    var parsedData = parseResponse(response as Dictionary<String, AnyObject!>[])
    var repos = Repos(repos: parsedData)
    self.cache[username] = repos
    handleData(username, repos: repos)
  }
}