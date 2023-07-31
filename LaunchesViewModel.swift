//
//  LaunchesViewModel.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import Foundation

class LaunchesViewModel {
  // MARK: - Variables
  var onLoadingsUpdated: (() -> Void)?
  var page = 1
  var hasNextPage = true
  var isLoading = false {
    didSet {
      self.onLoadingsUpdated?()
    }
  }
    private(set) var launches: [Launch] = [] /*{
      didSet {
        self.onLaunchesUpdated?()
      }
    }*/
  // MARK: - Initializer
  init() {
    self.fetchLaunches()
  }
  func loadMoreData() {
    if hasNextPage {
      page += 1
      fetchLaunches()
    }
  }
  func fetchLaunches() {
    isLoading = true
    let route = XLaunchApi()
    NetworkManager.fetchLaunches(with: route, page: page) {[weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
        switch result {
        case .success(let document):
          if self?.page == 1 {
            self?.launches = document.docs
          } else {
            self?.launches += document.docs
          }
          self?.page = document.page
          self?.hasNextPage = document.hasNextPage

        case .failure(let error):
          switch error {
          case .invalidURL: print("invalid Url")
          case .invalidResponse:  print("invalid invalidResponse")
          case .invalidData: print("invalidDatal")
          case .unableToComplete: print("unableToComplete")
          }
        }
      }
    }
  }
}
