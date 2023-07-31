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
  var onChangeSortParameterUpdated: (() -> Void)?
  var page = 1
  var searchedText = ""
  var hasNextPage = true
  var applicationState = ApplicationState.empty
  var error: LaunchServiceError?
  var isLoading = false {
    didSet {
      self.onLoadingsUpdated?()
    }
  }
  private(set) var allLaunches: [Launch] = [] {
    didSet {
      if allLaunches.isEmpty && !searchedText.isEmpty && error == nil {
        applicationState = .noResults
      } else if allLaunches.isEmpty && searchedText.isEmpty && error == nil {
        applicationState = .empty
      } else if error == nil, !isLoading, !allLaunches.isEmpty {
        applicationState = .data
      }
      print("application state: === \(applicationState)")
    }
  }
  // private(set) var filteredLaunches: [Launch] = []
  // MARK: - Init
  init() {
    self.fetchLaunches()
  }
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
    isLoading = true
    let route = XLaunchApi()
    NetworkManager.fetchLaunches(with: route, page: page, searchedText: searchedText, sortParameter: sortService.getSortParameter(), sortOrder: sortService.getSortOrder()) {[weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
        switch result {
        case .success(let document):
          if self?.page == 1 {
            self?.allLaunches = document.docs
          } else {
            self?.allLaunches += document.docs
          }
          self?.page = document.page
          self?.hasNextPage = document.hasNextPage

        case .failure(let error):
          self?.error = error
          self?.applicationState = .error
          switch error {
          case .invalidURL: print("invalid Url")
          case .invalidResponse:  print("invalid invalidResponse")
          case .invalidData: print("invalidData")
          case .unableToComplete: print("unableToComplete")
          }
        }
      }
    }
  }
  // MARK: - Sorting parameters
  var sortService = SortService()
  func sortLaunches(by sortParameter: SortBy) {
    sortService.setLabelTextActionSheet(for: sortParameter)
    page = 1
    fetchLaunches()
  }
}
// MARK: - Search functions
extension LaunchesViewModel {
  public func inSearchMode(_ searchController: UISearchController) -> Bool {
    let isActive = searchController.isActive
    let searchText = searchController.searchBar.text ?? ""
    return isActive && !searchText.isEmpty
  }
  public func updateSearchController(searchBarText: String?) {
    // self.filteredLaunches = allLaunches
  }
}

