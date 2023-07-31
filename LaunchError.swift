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
enum ApplicationState {
  case data, error, loading, empty, noResults
}
