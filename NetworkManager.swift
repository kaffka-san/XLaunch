//
//  NetworkManager.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit

final class NetworkManager {
  static let shared = NetworkManager()
  private init() {}
  static func fetchLaunches (with route: XLaunchApi, page: Int, searchedText: String?, sortParameter: SortBy, sortOrder: SortOrder, completion: @escaping (Result <Document, LaunchServiceError>) -> Void) {
    guard let request = route.getRequest(page: page, searchedText: searchedText, sortParameter: sortParameter, sortOrder: sortOrder) else {
      completion(.failure(.invalidURL))
      return }
    URLSession.shared.dataTask(with: request) { data, response, error in
      if error != nil {
        completion(.failure(.invalidURL))
        return
      }
      if let response = response as? HTTPURLResponse, response.statusCode != 200 {
        completion(.failure(.invalidResponse))
      }
      if let data = data {
        do {
          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .secondsSince1970
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          let dataArray = try decoder.decode(Document.self, from: data)
          completion(.success(dataArray))
        } catch {
          completion(.failure(.invalidData))
        }
      } else {
        completion(.failure(.unableToComplete))
      }
    }
    .resume()
  }
}
