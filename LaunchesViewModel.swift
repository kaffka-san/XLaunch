//
//  LaunchesViewModel.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import Foundation

class LaunchesViewModel {
  var onLaunchesUpdated: (() -> Void)?
  var onLoadingsUpdated: (() -> Void)?
  var isLoading = false {
    didSet {
      self.onLoadingsUpdated?()
    }
  }
  private(set) var launches: [Launch] = [] {
    didSet {
      self.onLaunchesUpdated?()
    }
  }
  init() {
    self.fetchLaunches()
  }
  func fetchLaunches() {
    isLoading = true
    let route = XLaunchApi.fetchLaunches
    NetworkManager.fetchLaunches(with: route) {[weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
        switch result {
        case .success(let document):
          self?.launches = document.docs
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
