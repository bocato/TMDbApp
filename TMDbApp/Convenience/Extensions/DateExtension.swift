//
//  DateExtension.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

extension Date {
  
  func stringWithFormat(_ format: String) -> String? {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
  
  static func new(from string: String, format: String) -> Date? {
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: string)
  }
  
  static func new(from string: String?, format: String!, timeZone: TimeZone!) -> Date? {
    guard let string = string else { return nil }
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = timeZone
    return dateFormatter.date(from: string)
  }
  
}
