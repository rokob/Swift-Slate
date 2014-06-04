//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit

struct Repo {
  let id: UInt
  let name: String
  let owner: Owner
  let fork: Bool
  let language: String

  struct Owner {
    let login: String
    let id: UInt
    let avatar_url: NSURL
    let url: NSURL
  }
}

@objc protocol SLFeedDataSourceDelegate {
  func didReceiveData() -> Void
}

class SLFeedDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {

  var data: Repo[]
  var loaded: Bool
  weak var delegate: SLFeedDataSourceDelegate?

  init() {
    data = []
    loaded = false
    super.init()
  }

  func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
    if !cell {
      cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
    }

    var repo = data.filter({(r: Repo) -> Bool in return r.fork == (1 == indexPath.section)})[indexPath.row]
    cell.textLabel.text = "Name: \(repo.name)"
    cell.detailTextLabel.text = "Language: \(repo.language)"
    return cell
  }

  func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return data.filter({(r: Repo) -> Bool in return !r.fork}).count
    } else {
      return data.filter({(r: Repo) -> Bool in return r.fork}).count
    }
  }

  func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
    if section == 0 {
      return "Rokob's Repos"
    } else {
      return "Forks"
    }
  }

  func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
    return 2
  }

  func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
  }

  func loadData() {
    if loaded {
      return
    }

    var manager = AFHTTPRequestOperationManager()
    manager.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.MutableContainers)
    manager.GET("https://api.github.com/users/rokob/repos",
      parameters: nil,
      success: {(_: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        self.loaded = true
        self.parseResponse(response as Dictionary<String, AnyObject!>[])
      },
      failure: {(_: AFHTTPRequestOperation!, error: NSError!) -> Void in
        println(error)
      })
  }

  func parseResponse(response: Dictionary<String, AnyObject!>[]) {
    for dict in response {
      var ownerDict = dict["owner"]! as Dictionary<String, AnyObject!>
      var owner = Repo.Owner(
        login: ownerDict["login"]! as String,
        id: ownerDict["id"]! as UInt,
        avatar_url: NSURL(string: ownerDict["avatar_url"]! as String),
        url: NSURL(string: ownerDict["url"]! as String)
      )
      var repo = Repo(
        id: dict["id"]! as UInt,
        name: dict["name"]! as String,
        owner: owner,
        fork: dict["fork"]! as Bool,
        language: dict["language"]! as String
      )
      data.append(repo)
    }
    delegate?.didReceiveData()
  }
}