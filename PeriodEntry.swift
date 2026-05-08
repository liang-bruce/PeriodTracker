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
    // CloudKit-backed SwiftData requires every non-optional property to have a default
    // value, because CloudKit may sync records with missing fields. The init still
    // overrides this, so creation behaviour is unchanged.
    var startDate: Date = Date()
    var endDate: Date?

    init(startDate: Date, endDate: Date? = nil) {
        self.startDate = startDate
        self.endDate = endDate
    }
}
