//
//  Item.swift
//  PeriodTracker
//
//  Created by 梁纪田 on 3/3/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
