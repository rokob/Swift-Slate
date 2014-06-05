//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit

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

  func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
    if !cell {
      cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
    }

    var repo = data.repos.filter({(r: Repo) -> Bool in return r.fork == (1 == indexPath.section)})[indexPath.row]
    cell.textLabel.text = "Name: \(repo.name)"
    cell.detailTextLabel.text = "Language: \(repo.language)"
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

    var manager = AFHTTPRequestOperationManager()
    manager.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.MutableContainers)
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
    var backgroundData = [] as Repo[]
    for dict in response {
      var ownerDict = dict["owner"]! as Dictionary<String, AnyObject!>
      var owner = Repo.Owner(
        login: ownerDict["login"]! as String,
        id: ownerDict["id"]! as UInt,
        avatar_url: ownerDict["avatar_url"]! as String,
        url: ownerDict["url"]! as String
      )
      var repo = Repo(
        id: dict["id"]! as UInt,
        name: dict["name"]! as String,
        owner: owner,
        fork: dict["fork"]! as Bool,
        language: dict["language"]! as String
      )
      backgroundData.append(repo)
    }
    return backgroundData
  }

  func handleData(username: String, repos: Repos) {
    dispatch_async(dispatch_get_main_queue()) {
      self.data = repos
      self.delegate?.didReceiveData()
    }
  }

  func handleUnknown(username: String) {

  }
}