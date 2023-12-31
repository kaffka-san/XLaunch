//
//  LaunchesViewModel.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit

final class LaunchesViewModel {
  // MARK: - Variables
  var sortService = SortService()
  var onLoadingsUpdated: (() -> Void)?
  var page = 1
  var searchedText = ""
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
      if allLaunches.isEmpty && !searchedText.isEmpty && error == nil {
        launchesViewState = .noResults
      } else if allLaunches.isEmpty && searchedText.isEmpty && error == nil {
        launchesViewState = .empty
      } else if error == nil, !allLaunches.isEmpty {
        launchesViewState = .data
      }
    }
  }

  // MARK: - Init
  init() {
    self.fetchLaunches()
  }

  // MARK: - Fetching Functions
  func loadMoreData() {
    if hasNextPage {
      page += 1
      fetchLaunches()
    }
  }

  func searchText(textString: String?) {
    if let textString {
      page = 1
      searchedText = textString
      fetchLaunches()
    }
  }

  func fetchLaunches() {
    error = nil
    launchesViewState = .loading

    Task {
      do {
        let document = try await NetworkManager.shared.fetchLaunches(
          page: page,
          searchedText:
          searchedText,
          sortParameter: sortService.getSortParameter(),
          sortOrder: sortService.getSortOrder()
        )

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
