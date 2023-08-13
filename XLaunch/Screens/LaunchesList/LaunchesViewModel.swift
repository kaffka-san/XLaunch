//
//  LaunchesViewModel.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit
import Combine

final class LaunchesViewModel {
  // MARK: - Variables
  var sortService = SortService()
  var onLoadingsUpdated: (() -> Void)?
  private var page = 1
  var hasNextPage = true

  let searchText = CurrentValueSubject<String, Never>("")
  let sortParameter = CurrentValueSubject<SortParameter, Never>(.name)

  var cancellables = Set<AnyCancellable>()

  var error: LaunchServiceError?
  var launchesViewState = CurrentValueSubject <LaunchesViewState, Never>(.empty)

  private(set) var allLaunches: [Launch] = [] {
    didSet {
      if allLaunches.isEmpty && !searchText.value.isEmpty && error == nil {
        launchesViewState.value = .noResults
      } else if allLaunches.isEmpty && searchText.value.isEmpty && error == nil {
        launchesViewState.value = .empty
      } else if error == nil, !allLaunches.isEmpty {
        launchesViewState.value = .data
      }
    }
  }

  // MARK: - Init
  init() {
    Publishers.Merge3(
      self.fetchLaunches(),
      self.setupSearch(),
      self.setupSort()
    )
    .sink { self.handleDocument($0) }
    .store(in: &self.cancellables)
  }

  // MARK: - Fetching Functions
  func refresh() {
    page = 1
    fetchLaunches()
      .sink { self.handleDocument($0) }
      .store(in: &self.cancellables)
  }

  func loadMoreData() {
    if hasNextPage {
      page += 1
      fetchLaunches()
        .sink { self.handleDocument($0) }
        .store(in: &self.cancellables)
    }
  }

  func fetchLaunches() -> AnyPublisher<Document, Never> {
    error = nil
    launchesViewState.value = .loading

    return NetworkManager.shared.fetchLaunches(
      page: page,
      searchedText: searchText.value,
      sortParameter: sortService.getSortParameter(),
      sortOrder: sortService.getSortOrder()
    )
    .catch { self.handleError(error: $0) }
    .eraseToAnyPublisher()
  }

  func setupSearch() -> AnyPublisher<Document, Never> {
    searchText
      .dropFirst()
      .removeDuplicates()
      .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
      .map { [unowned self] _ -> AnyPublisher<Document, Never> in
        self.page = 1

        return fetchLaunches()
      }
      .switchToLatest()
      .eraseToAnyPublisher()
  }

  func setupSort() -> AnyPublisher<Document, Never> {
    sortParameter
      .dropFirst()
      .map { [unowned self] sortParam -> AnyPublisher<Document, Never> in
        self.sortService.setLabelTextActionSheet(for: sortParam)
        self.page = 1

        return fetchLaunches()
      }
      .switchToLatest()
      .eraseToAnyPublisher()
  }


  // MARK: - Handlers
  func handleDocument(_ document: Document) {
    self.error = nil
    launchesViewState.value = .data
    if page == 1 {
      allLaunches = document.docs
    } else {
      allLaunches += document.docs
    }
    page = document.page
    hasNextPage = document.hasNextPage
  }

  func handleError(error: Error) -> AnyPublisher<Document, Never> {
    launchesViewState.value = .error
    if let serviceError = error as? LaunchServiceError {
      self.error = serviceError
    } else {
      self.error = LaunchServiceError.genericError(error)
    }

    return Empty<Document, Never>(completeImmediately: true)
      .eraseToAnyPublisher()
  }
}

// MARK: - Define state of the TableView Launches
enum LaunchesViewState: String {
  case data
  case error
  case loading
  case empty = "ApplicationState.Empty"
  case noResults = "ApplicationState.NoResults"

  var localizedString: String {
    NSLocalizedString(self.rawValue, comment: "")
  }
  var title: String {
    localizedString
  }
}
