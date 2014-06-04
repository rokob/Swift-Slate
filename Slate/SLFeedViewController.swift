//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit

class SLFeedViewController: UIViewController {

  var tableView: UITableView?
  var dataSource: protocol<UITableViewDataSource, UITableViewDelegate>?

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
    dataSource = SLFeedDataSource()
    tableView!.dataSource = dataSource as UITableViewDataSource
    tableView!.delegate = dataSource as UITableViewDelegate
    self.view = tableView
  }
}
