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
  case unknown

  var localizedDescription: String {
    switch self {
    case .genericError(let error):
      let message = NSLocalizedString("LaunchServiceError.GenericError", comment: "Generic error")
      return "\(message)\n\(error.localizedDescription)"
    case .unableToComplete:
      return NSLocalizedString("LaunchServiceError.UnableToComplete", comment: "Unable to complete the task")
    case .invalidURL:
      return NSLocalizedString("LaunchServiceError.InvalidURL", comment: "Invalid URL")
    case .invalidData:
      return NSLocalizedString("LaunchServiceError.InvalidData", comment: "Invalid data")
    case .invalidResponse:
      return NSLocalizedString("LaunchServiceError.InvalidResponse", comment: "There was an invalid response")
    case .unknown:
      return NSLocalizedString("LaunchServiceError.UnknownError", comment: "There was an unknown error")
      }
  }
}
