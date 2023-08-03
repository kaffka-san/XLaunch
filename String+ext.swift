//
//  String+ext.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 03.08.2023.
//

import Foundation

extension String {
  func localize(comment: String = "") -> String {
    let defaultLanguage = "en"
    let value = NSLocalizedString(self, comment: comment)
    if value != self || NSLocale.preferredLanguages.first == defaultLanguage {
      return value
    }
    guard let path = Bundle.main.path(forResource: defaultLanguage, ofType: "lproj"), let bundle = Bundle(path: path) else {
      return value
    }
    return NSLocalizedString(self, bundle: bundle, comment: "")
  }
}
