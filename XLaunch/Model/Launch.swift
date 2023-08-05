//
//  Launch.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit

struct Document: Codable {
  let docs: [Launch]
  let hasNextPage: Bool
  let page: Int
}


struct Launch: Codable {
  let id: String
  let name: String
  let dateUtc: Date
  let details: String?
  let success: Bool?
  let flightNumber: Int
  let links: Link?

  var imageUrlSmall: URL? {
    guard let url = links?.patch?.small else {
      return nil
    }
    return URL(string: url)
  }

  var imageUrlLarge: URL? {
    guard let url = links?.patch?.large else {
      return nil
    }
    return URL(string: url)
  }
}


struct Link: Codable {
  let patch: Patch?
}


struct Patch: Codable {
  let small: String?
  let large: String?
}
