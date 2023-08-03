//
//  LaunchesViewModel.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit

class LaunchesViewModel {
  // MARK: - Variables
  var onLoadingsUpdated: (() -> Void)?
  var page = 1
  var searchedText = ""
  var hasNextPage = true
  var applicationState = ApplicationState.empty {
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
        applicationState = .noResults
      } else if allLaunches.isEmpty && searchedText.isEmpty && error == nil {
        applicationState = .empty
      } else if error == nil, !allLaunches.isEmpty {
        applicationState = .data
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
    applicationState = .loading
    let route = XLaunchAPI()
    Task {
      do {
        let document = try await NetworkManager.shared.fetchLaunches(
          with: route,
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
        applicationState = .error
        if let launchServiceError = error as? LaunchServiceError {
          self.error = launchServiceError
        } else {
          self.error = .genericError(error)
        }
      }
    }
  }

  // MARK: - Sorting parameters
  var sortService = SortService()
  func sortLaunches(by sortParameter: SortParameter) {
    sortService.setLabelTextActionSheet(for: sortParameter)
    page = 1
    fetchLaunches()
  }
}
