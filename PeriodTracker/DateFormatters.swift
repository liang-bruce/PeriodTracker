//
//  DateFormatters.swift
//  PeriodTracker
//

import Foundation

enum DateFormatters {
    static let entryDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd-MM-yyyy"
        return f
    }()
}
