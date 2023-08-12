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
  var page = 1

  let searchTextPublisher = CurrentValueSubject<String, Never>("")
  var cancellables = Set<AnyCancellable>()

  var hasNextPage = true
  var launchesViewState = LaunchesViewState.empty {
    didSet {
      DispatchQueue.main.async {
        self.onLoadingsUpdated?()
      }
    }
  }
  var error: LaunchServiceError?

  private(set) var allLaunches: [Launch] = [] {
    didSet {
      if allLaunches.isEmpty && !searchTextPublisher.value.isEmpty && error == nil {
        launchesViewState = .noResults
      } else if allLaunches.isEmpty && searchTextPublisher.value.isEmpty && error == nil {
        launchesViewState = .empty
      } else if error == nil, !allLaunches.isEmpty {
        launchesViewState = .data
      }
    }
  }

  // MARK: - Init
  init() {
    self.fetchLaunchesInitial()
  }

  // MARK: - Fetching Functions
  func loadMoreData() {
    if hasNextPage {
      page += 1
      fetchLaunches()
    }
  }

  func searchTextPublisher(_ textString: String) -> AnyPublisher<Document, Error> {
    page = 1
    return fetchLaunchesPublisher()
  }

  func fetchLaunches() {
    error = nil
    launchesViewState = .loading
    print("fetching")
    Task {
      do {
        let document = try await NetworkManager.shared.fetchLaunches(
          page: page,
          searchedText: searchTextPublisher.value,
          sortParameter: sortService.getSortParameter(),
          sortOrder: sortService.getSortOrder()
        ).value

        if page == 1 {
          allLaunches = document.docs
        } else {
          allLaunches += document.docs
        }
        page = document.page
        hasNextPage = document.hasNextPage
      } catch {
        allLaunches = []
        launchesViewState = .error

        if let launchServiceError = error as? LaunchServiceError {
          self.error = launchServiceError
        } else {
          self.error = .genericError(error)
        }
      }
    }
  }

  func setupSearch() {
    searchTextPublisher
      .removeDuplicates()
      .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
      .map { [unowned self] searchText -> AnyPublisher<Document, Never> in
        self.searchTextPublisher(searchText)
          .catch { [weak self] error in
            self?.allLaunches = []
            self?.launchesViewState = .error

            if let knownError = error as? LaunchServiceError {
              self?.error = knownError
            } else {
              self?.error = LaunchServiceError.genericError(error)
            }

            return Empty<Document, Never>(completeImmediately: true)
          }
          .eraseToAnyPublisher()
      }
      .switchToLatest()
      .sink { [weak self] document in
        self?.allLaunches = document.docs
      }
      .store(in: &self.cancellables)
  }

  func fetchLaunchesPublisher() -> AnyPublisher<Document, Error> {
    error = nil
    launchesViewState = .loading
    return NetworkManager.shared.fetchLaunches(
      page: page,
      searchedText: searchTextPublisher.value,
      sortParameter: sortService.getSortParameter(),
      sortOrder: sortService.getSortOrder()
    )
    .eraseToAnyPublisher()
  }

  func fetchLaunchesInitial() {
    fetchLaunchesPublisher()
    .sink { [weak self] completion in
      switch completion {
      case .finished: break
      case .failure(let error):
        self?.allLaunches = []
        self?.launchesViewState = .error
        if let launchServiceError = error as? LaunchServiceError {
          self?.error = launchServiceError
        } else {
          self?.error = .genericError(error)
        }
      }
    } receiveValue: { [weak self] document in
      self?.launchesViewState = .data
      if self?.page == 1 {
        self?.allLaunches = document.docs
      } else {
        self?.allLaunches += document.docs
      }
      self?.page = document.page
      self?.hasNextPage = document.hasNextPage

      self?.setupSearch()
    }
    .store(in: &self.cancellables)
  }

  // MARK: - Sorting parameters
  func sortLaunches(by sortParameter: SortParameter) {
    sortService.setLabelTextActionSheet(for: sortParameter)
    page = 1
    fetchLaunches()
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
