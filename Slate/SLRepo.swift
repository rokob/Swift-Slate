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
}
