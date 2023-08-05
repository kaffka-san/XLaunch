//
//  Persistance.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 04.08.2023.
//

import Foundation

final class Persistence {
  private let userDefaults = UserDefaults.standard

  func saveData(sortParameter: SortParameter ) {
    if let data = try? JSONEncoder().encode(sortParameter) {
      userDefaults.set(data, forKey: "SortingParameter")
    }
  }

  func getData() -> SortParameter {
    guard let savedData = userDefaults.data(forKey: "SortingParameter") else {
      return SortParameter.name
    }

    if let sortingParameter = try? JSONDecoder().decode(SortParameter.self, from: savedData) {
      return sortingParameter
    } else {
      return SortParameter.name
    }
  }
}
