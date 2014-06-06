//  Copyright (c) 2014 rokob. All rights reserved.

struct Repo {
  let id: UInt
  let name: String
  let owner: Owner
  let fork: Bool
  let language: String

  struct Owner {
    let login: String
    let id: UInt
    let avatar_url: String
    let url: String
  }

  static func fromJSON(dict: Dictionary<String, AnyObject!>) -> Repo {
    var ownerDict = dict["owner"]! as Dictionary<String, AnyObject!>
    var owner = Repo.Owner(
      login: ownerDict["login"]! as String,
      id: ownerDict["id"]! as UInt,
      avatar_url: ownerDict["avatar_url"]! as String,
      url: ownerDict["url"]! as String
    )
    return Repo(
      id: dict["id"]! as UInt,
      name: dict["name"]! as String,
      owner: owner,
      fork: dict["fork"]! as Bool,
      language: dict["language"]! as String
    )
  }
}
