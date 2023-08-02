//
//  SortService.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 01.08.2023.
//

import Foundation

class SortService {
  private var name = "✔ Name 🔼"
  private var date = "Date"
  private var flightNumber = "Flight number"
  private var sortOrder = SortOrder.asc
  private let userDefaults = UserDefaults.standard
  private var sortParameter = SortParameter.name {
    didSet {
      if sortParameter == oldValue {
        toggleSortOrder()
      }
      if let data = try? JSONEncoder().encode(sortParameter) {
        userDefaults.set(data, forKey: "SortingParameter")
      }
    }
  }
  init() {
    guard let savedData = userDefaults.data(forKey: "SortingParameter") else {
      setLabelTextActionSheet(for: SortParameter.name)
      return
    }
    if let sortingParameter = try? JSONDecoder().decode(SortParameter.self, from: savedData) {
      setLabelTextActionSheet(for: sortingParameter)
    } else {
      setLabelTextActionSheet(for: SortParameter.name)
    }
  }
  private var sortIcon = "🔼"
  private func toggleSortOrder() {
    sortOrder = sortOrder == .asc ? .desc : .asc
    sortIcon = sortOrder == .asc ? "🔼" : "🔽"
  }
  func setLabelTextActionSheet(for sortParameter: SortParameter) {
    self.sortParameter = sortParameter
    switch self.sortParameter {
    case .name:
      name = "✔ Name \(sortIcon)"
      date = "Date"
      flightNumber = "Flight number"
    case .flightNumber:
      name = "Name"
      date = "Date"
      flightNumber = "✔ Flight number \(sortIcon)"
    case .date:
      name = "Name"
      date = "✔ Date \(sortIcon)"
      flightNumber = "Flight number"
    }
  }
  func getSortParameter() -> SortParameter {
    return sortParameter
  }
  func getSortOrder() -> SortOrder {
    return sortOrder
  }
  func getNameLabelText() -> String {
    return name
  }
  func getFlightNumberLabelText() -> String {
    return flightNumber
  }
  func getDateLabelText() -> String {
    return date
  }
}
