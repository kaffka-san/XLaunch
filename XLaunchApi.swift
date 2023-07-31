//
//  XLaunchApi.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import Foundation
struct BodyParameters: Codable {
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
    let bodyParameters = BodyParameters(options: Option(limit: 50, page: 1, select: ["id", "name", "date_unix", "date_utc", "detail", "success", "links.patch.large", "flight_number"]))

    do {
      let data = try JSONEncoder().encode(bodyParameters)
      print("data \(data)")
      request.httpBody = data
      } catch {
        print("cant encode message")
        return nil
      }
    return request
  }


  private var url: URL? {
    guard let url = URL(string: "https://api.spacexdata.com/v4/launches/query") else { fatalError("baseURL could not be configured.") }
    return url
  }
}
