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
  var name: String
  var dateUtc: Date
  var details: String?
  var success: Bool?
  var flightNumber: Int?
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

extension Launch {
  public static func getMockArray() -> [Launch] {
    return [
      Launch(name: "DemoSat1", dateUtc: Date.now, details: "Successful first stage burn and transition to second stage.", success: true, flightNumber: 1, links: Link(patch: Patch(large: "https://images2.imgbox.com/5b/02/QcxHUb5V_o.png"))),
      Launch(name: "DemoSat2", dateUtc: Date.now, details: "Successful first stage burn and transition to second stage.", success: true, flightNumber: 2, links: Link(patch: Patch(large: "https://images2.imgbox.com/5b/02/QcxHUb5V_o.png"))),
      Launch(name: "DemoSat3", dateUtc: Date.now, details: "Successful first stage burn and transition to second stage.", success: true, flightNumber: 3, links: Link(patch: Patch(large: "https://images2.imgbox.com/5b/02/QcxHUb5V_o.png"))),
      Launch(name: "DemoSat4", dateUtc: Date.now, details: "Successful first stage burn and transition to second stage.", success: true, flightNumber: 4, links: Link(patch: Patch(large: "https://images2.imgbox.com/5b/02/QcxHUb5V_o.png")))
    ]
  }
}
