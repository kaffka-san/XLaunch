//
//  NetworkManager.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit
import Combine

final class NetworkManager {
  static let shared = NetworkManager()
  private var cancellables = Set<AnyCancellable>()
  let decoder = JSONDecoder()
  private init() {
    let fullISO8610Formatter = DateFormatter()
    fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    decoder.dateDecodingStrategy = .formatted(fullISO8610Formatter)
    decoder.keyDecodingStrategy = .convertFromSnakeCase
  }

  func fetchLaunches (
    page: Int,
    searchedText: String?,
    sortParameter: SortParameter,
    sortOrder: SortOrder
  )
  -> Future<Document, Error> {
    return Future<Document, Error> { [weak self] promise in
      guard let self = self else { return }

      let bodyParameterOption = Option(
        limit: 50,
        page: page,
        select: ["id", "name", "date_utc", "details", "success", "links.patch", "flight_number"],
        sort: [sortParameter.rawValue: sortOrder.rawValue]
      )
      let bodyParameterQuery = Query(
        name: Parameters(regex: (searchedText ?? ""), options: "i"))

      guard let request = try? LaunchesRequest.launches(.init(
        options: bodyParameterOption,
        query: bodyParameterQuery))
        .asURLRequest() else {
        return promise(.failure(LaunchServiceError.invalidURL))
      }

      URLSession.shared.dataTaskPublisher(for: request)
        .tryMap { data, response -> Document in
          guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw LaunchServiceError.invalidResponse(statusCode: nil)
          }
          guard let document = try? self.decoder.decode(Document.self, from: data) else {
            throw LaunchServiceError.invalidData
          }
          return document
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
          if case let .failure(error) = completion {
            switch error {
            case let launchError as LaunchServiceError: promise(.failure(launchError))
            default: promise(.failure(LaunchServiceError.genericError(error)))
            }
          }
        }, receiveValue: { promise(.success($0)) })
        .store(in: &self.cancellables)

    }
  }
}
