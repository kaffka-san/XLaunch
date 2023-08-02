//
//  XLaunchApi.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import Foundation
struct BodyParameters: Codable {
  var options: Option
  var query: Query
}
struct Query: Codable {
  var name: Parameters
}
struct Parameters: Codable {
  var regex: String
  var options: String
  enum CodingKeys: String, CodingKey {
    case regex = "$regex"
    case options = "$options"
  }
}
struct Option: Codable {
  var limit: Int
  var page: Int
  var select: [String]
  var sort: [String: String]
}

struct XLaunchApi {
  func getRequest(page: Int, searchedText: String?, sortParameter: SortParameter, sortOrder: SortOrder) -> URLRequest? {
    var request = URLRequest(url: self.url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    let bodyParameters = BodyParameters(
      options: Option(
        limit: 12,
        page: page,
        select: ["id", "name", "date_unix", "date_utc", "details", "success", "links.patch.large", "flight_number"],
        sort: [sortParameter.rawValue: String(describing: sortOrder)]
      ),
      query: Query(name: Parameters(regex: (searchedText ?? ""), options: "i")))
    do {
      let data = try JSONEncoder().encode(bodyParameters)
      request.httpBody = data
      } catch {
        print("cant encode message")
        return nil
      }
    return request
  }


  private var url: URL {
    guard let url = URL(string: "https://api.spacexdata.com/v4/launches/query") else { fatalError("baseURL could not be configured.") }
    return url
  }
}

enum SortParameter: String, Codable {
  case name = "name"
  case flightNumber = "flight_number"
  case date = "date_unix"
}

enum SortOrder {
  case asc
  case desc
}
