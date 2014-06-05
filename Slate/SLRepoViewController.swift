//  Copyright (c) 2014 rokob. All rights reserved.

import UIKit

class SLRepoViewController: UIViewController {

  var repo: Repo

  init(repo: Repo) {
    self.repo = repo
    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    var view = SLRepoView(frame: CGRectZero)
    view.configureWithRepo(repo)
    self.view = view
  }

}
