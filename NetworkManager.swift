//
//  NetworkManager.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit

final class NetworkManager {
  static let shared = NetworkManager()
  let decoder = JSONDecoder()
  private init() {
    decoder.dateDecodingStrategy = .secondsSince1970
    decoder.keyDecodingStrategy = .convertFromSnakeCase
  }

  func fetchLaunches (
    page: Int,
    searchedText: String?,
    sortParameter: SortParameter,
    sortOrder: SortOrder
  ) async throws -> Document {
    let bodyParameterOption = Option(
      limit: 50,
      page: page,
      select: ["id", "name", "date_unix", "date_utc", "details", "success", "links.patch", "flight_number"],
      sort: [sortParameter.rawValue: sortOrder.rawValue]
        )
      let bodyParameterQuery = Query(
        name: Parameters(regex: (searchedText ?? ""), options: "i"))

    let request = try LaunchesRequest.launches(.init(options: bodyParameterOption, query: bodyParameterQuery)).asURLRequest()

    let (data, response) = try await URLSession.shared.data(for: request)

    if let response = response as? HTTPURLResponse, response.statusCode != 200 {
      throw LaunchServiceError.invalidResponse(statusCode: response.statusCode)
    }

    do {
      return try decoder.decode(Document.self, from: data)
    } catch {
      throw LaunchServiceError.invalidData
    }
  }
}
