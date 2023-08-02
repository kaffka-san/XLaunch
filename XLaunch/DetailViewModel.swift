//
//  DetailViewModel.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 02.08.2023.
//
import UIKit

class DetailLaunchViewModel: ObservableObject {
  // MARK: - Variables
  @Published var launch: Launch

  // MARK: - Initialisers
  init(_ launch: Launch) {
    self.launch = launch
  }

  // MARK: - String processing

  var date: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    dateFormatter.locale = Locale.current
    return "\(dateFormatter.string(from: self.launch.dateUnix))"
  }

  var launchStatus: RocketLaunchStatus {
    if let success = self.launch.success {
      if success {
        return .success
      } else {
        return .failure
      }
    } else {
      return .unknown
    }
  }

  var details: String {
    if let details = self.launch.details {
      return "\(details)"
    } else {
      return ""
    }
  }
}

enum RocketLaunchStatus: String {
  case success
  case failure
  case unknown
}

extension RocketLaunchStatus: RawRepresentable {
  init?(rawValue: (String, String)) {
    switch rawValue {
    case ("Success", "checkmark"): self = .success
    case ("failure", "xmark"): self = .failure
    case ("Unknown", "questionmark"): self = .unknown
    default: return nil
    }
  }

  var rawValue: (String, String) {
    switch self {
    case .success: return ("Success", "checkmark")
    case .failure: return  ("failure", "xmark")
    case .unknown: return ("Unknown", "questionmark")
    }
  }
}
