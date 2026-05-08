//
//  PeriodEntry.swift
//  PeriodTracker
//
//  Created by Codex on 3/3/2026.
//

import Foundation
import SwiftData

@Model
final class PeriodEntry {
    var startDate: Date
    var endDate: Date?

    init(startDate: Date, endDate: Date? = nil) {
        self.startDate = startDate
        self.endDate = endDate
    }
}
