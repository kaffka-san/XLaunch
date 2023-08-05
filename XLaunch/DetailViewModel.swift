//
//  DetailViewModel.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 02.08.2023.
//
import SwiftUI

class DetailLaunchViewModel: ObservableObject {
  // MARK: - Variables
  @Published var launch: Launch
  var date: String {
    return self.launch.dateUtc.formatted(date: .abbreviated, time: .omitted)
  }
  var time: String {
    return self.launch.dateUtc.formatted(date: .omitted, time: .shortened)
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

  var flightNumber: String {
    let text = (NSLocalizedString("DetailView.FlightNumber", comment: ""))
    return "\(launch.flightNumber)"
  }

  var details: String {
    if let details = self.launch.details {
      return "\(details)"
    } else {
      return ""
    }
  }

  // MARK: - Initialisers
  init(_ launch: Launch) {
    self.launch = launch
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
    case ("Success", "checkmark.circle"): self = .success
    case ("failure", "xmark.circle"): self = .failure
    case ("Unknown", "questionmark"): self = .unknown
    default: return nil
    }
  }

  var textValue: (String, String) {
    switch self {
    case .success: return (
      NSLocalizedString("DetailView.LaunchStatus.success", comment: "Launch status is success"),
      "checkmark")
    case .failure: return  (
      NSLocalizedString(
        "DetailView.LaunchStatus.failure",
        comment: "Launch status is failure"),
      "xmark")
    case .unknown: return (
      NSLocalizedString(
        "DetailView.LaunchStatus.unknown",
        comment: "Launch status is unknown"),
      "questionmark")
    }
  }
}
