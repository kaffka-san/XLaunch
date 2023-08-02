//
//  LaunchError.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import Foundation

enum LaunchServiceError: Error {
  case invalidURL
  case invalidResponse
  case invalidData
  case unableToComplete
}

enum ApplicationState: String {
  case data
  case error = "Error"
  case loading
  case empty = "No launches to show 🚀"
  case noResults = "No results 👀"
}
