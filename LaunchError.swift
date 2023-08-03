//
//  LaunchError.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import Foundation

enum LaunchServiceError: Error {
  case invalidURL
  case invalidResponse(statusCode: Int)
  case invalidData
  case unableToComplete
  case genericError(Error)

  var localizedDescription: String {
    switch self {
    case .genericError(let error): return "There was an error:\n\(error.localizedDescription)"
    case .unableToComplete: return "Unable to complete a task"
    case .invalidURL: return "Unable to complete your request"
    case .invalidData:
      return "The data received from the server was invalid. Please try again"
    case .invalidResponse(statusCode: let statusCode):
      return "Invalid response with status code \(statusCode) from the server. Please try again"
      }
  }
}

enum ApplicationState: String {
  case data
  case error
  case loading
  case empty = "No launches to show 🚀"
  case noResults = "No results 👀"
}
