//
//  NetworkManager.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit

class NetworkManager {
  static let shared = NetworkManager()
  let decoder = JSONDecoder()
  private init() {
    decoder.dateDecodingStrategy = .secondsSince1970
    decoder.keyDecodingStrategy = .convertFromSnakeCase
  }

  func fetchLaunches (
    with route: XLaunchApi,
    page: Int,
    searchedText: String?,
    sortParameter: SortParameter,
    sortOrder: SortOrder
  )
  async throws -> Document {
  guard let request = route.getRequest(page: page, searchedText: searchedText, sortParameter: sortParameter, sortOrder: sortOrder) else {
    throw LaunchServiceError.invalidURL
    }
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
