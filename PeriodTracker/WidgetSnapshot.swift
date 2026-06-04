//
//  WidgetSnapshot.swift
//  PeriodTracker
//
//  Shared between the main iOS app and the PeriodWidget extension via the
//  group.com.jitianliang.PeriodTracker App Group container. The main app writes
//  whenever entries change; the widget reads each timeline refresh.
//

import Foundation
#if canImport(WidgetKit)
import WidgetKit
#endif

struct WidgetSnapshot: Codable {
    // Three-state period status derived from the entries list:
    //   - activePeriodStart != nil           : currently in period
    //   - activePeriodStart == nil, lastEndedStart != nil : not in period, have history
    //   - both nil                            : no data
    var activePeriodStart: Date?
    var lastEndedStart: Date?
    var lastEndedEnd: Date?

    var averageCycleLength: Int
    var languageCode: String

    static let appGroupID = "group.com.jitianliang.PeriodTracker"
    private static let storageKey = "widgetSnapshot.v1"

    static func load() -> WidgetSnapshot {
        guard
            let defaults = UserDefaults(suiteName: appGroupID),
            let data = defaults.data(forKey: storageKey),
            let decoded = try? JSONDecoder().decode(WidgetSnapshot.self, from: data)
        else {
            return WidgetSnapshot(
                activePeriodStart: nil,
                lastEndedStart: nil,
                lastEndedEnd: nil,
                averageCycleLength: 30,
                languageCode: "en"
            )
        }
        return decoded
    }

    func save() {
        guard
            let defaults = UserDefaults(suiteName: WidgetSnapshot.appGroupID),
            let data = try? JSONEncoder().encode(self)
        else { return }
        defaults.set(data, forKey: WidgetSnapshot.storageKey)

        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
}
