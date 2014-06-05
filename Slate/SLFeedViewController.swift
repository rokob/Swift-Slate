//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit

class SLFeedViewController: UIViewController, SLFeedDataSourceDelegate {

  var tableView: UITableView?
  var dataSource: SLFeedDataSource?

  override func loadView() {
    tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
    dataSource = SLFeedDataSource()
    dataSource!.delegate = self
    tableView!.dataSource = dataSource as UITableViewDataSource
    tableView!.delegate = dataSource as UITableViewDelegate

    self.view = tableView
  }

  override func viewDidLoad() {
    dataSource!.loadData("rokob")
  }

  func didReceiveData() {
    self.tableView?.reloadData()
  }

  func didSelectRepo(index: Int, fork: Bool) {
    var repo = dataSource!.repoAtIndex(index, fork: fork)
    var repoVC = SLRepoViewController(repo: repo)
    self.navigationController.pushViewController(repoVC, animated: true)
  }
}
