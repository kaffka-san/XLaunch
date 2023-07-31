//
//  SortService.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 01.08.2023.
//

import Foundation

public class SortService {
  private var name = "✔ Name 🔼"
  private var date = "Date"
  private var flightNumber = "Flight number"
  private var sortOrder = SortOrder.asc
  private var sortBy = SortBy.name {
  didSet {
    if sortBy == oldValue {
      toggleSortOrder()
      }
    }
  }
  private var sortIcon = "🔼"
  private func toggleSortOrder() {
    sortOrder = sortOrder == .asc ? .desc : .asc
    sortIcon = sortOrder == .asc ? "🔼" : "🔽"
  }
  func setLabelTextActionSheet(for sortParameter: SortBy) {
    sortBy = sortParameter
    switch self.sortBy {
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
  func getSortParameter() -> SortBy {
    return sortBy
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
