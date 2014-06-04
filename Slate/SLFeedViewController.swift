//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit

class SLFeedViewController: UIViewController, SLFeedDataSourceDelegate {

  var tableView: UITableView?
  var dataSource: SLFeedDataSource?

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
    dataSource = SLFeedDataSource()
    dataSource!.delegate = self
    tableView!.dataSource = dataSource as UITableViewDataSource
    tableView!.delegate = dataSource as UITableViewDelegate
    self.view = tableView
  }

  override func viewDidLoad() {
    dataSource!.loadData()
  }

  func didReceiveData() {
    self.tableView?.reloadData()
  }
}
