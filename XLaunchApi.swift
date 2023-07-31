//
//  XLaunchApi.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import Foundation
struct Message: Codable {
  var options: Option
}
struct Option: Codable {
  var limit: Int
  var page: Int
  var select: [String]
}
enum XLaunchApi {
  case fetchLaunches
  var request: URLRequest? {
    guard let url = self.url else {
      return nil }
    print("url \(url)")
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    let message = Message(options: Option(limit: 50, page: 1, select: ["id", "name", "date_utc","detail", "success","links.patch.large", "flight_number"]))

    do {
      let data = try JSONEncoder().encode(message)
      print("data \(data)")
      request.httpBody = data
      } catch {
        print("cant encode message")
        return nil
      }

    return request
  }

  private var path: String {
    switch self {
    case .fetchLaunches:
      return Constants.pathLaunches
    }
  }

  private var url: URL? {
    var components = URLComponents()
    components.scheme = Constants.scheme
    components.host = Constants.host
    components.path = self.path
    //components.queryItems = []
    print("url compo \(components.string)")
    return components.url
  }
}
