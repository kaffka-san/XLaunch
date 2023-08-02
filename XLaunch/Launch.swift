//
//  Launch.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit

struct Document: Codable {
  var docs: [Launch]
  var hasNextPage: Bool
  var page: Int
}
struct Launch: Codable {
  var id: String
  var name: String
  var dateUnix: Date
  var details: String?
  var success: Bool?
  var flightNumber: Int
  var links: Link?
  public var imageUrl: URL? {
    if let url = links?.patch?.large {
      return URL(string: url)
    } else { return nil }
  }
}
struct Link: Codable {
  let patch: Patch?
}

struct Patch: Codable {
  var large: String?
}
