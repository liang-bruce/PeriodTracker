//
//  OvulationCalculator.swift
//  PeriodTracker
//

import Foundation

// Fertility / ovulation calculation based on the calendar method described in
// "Mayo Clinic Guide to Fertility and Conception" (《梅奥备孕全书》):
//
//   - The luteal phase (post-ovulation phase) is roughly fixed at 14 days.
//   - For a cycle of length L (measured start-of-period to start-of-period),
//     ovulation occurs approximately on day L - 14 of the cycle.
//   - The fertile window covers ~5 days before ovulation through ~1 day after,
//     since sperm survive a few days and the egg survives ~24 hours.
//     Concretely: cycle days [L - 18, L - 13] inclusive — a 6-day window.
//     (Example: L=30 → ovulation day 16, fertile window days 12-17.)
//
// A Georgetown University study referenced in the same book found that for
// women with regular 26-32 day cycles, the optimal window is days 8-19 of the
// cycle. We use the narrower, formula-based window above because it is what
// the book recommends as the general algorithm.
//
// The algorithm is only meaningful for cycles roughly in the 21-45 day range.
// Outside that range, the luteal-phase formula produces unreliable predictions
// (e.g., cycle length 14 would imply a "fertile window" of cycle days [-4, 1],
// which would falsely flag every cycle day 1 as fertile). We therefore clamp
// to plausible cycle lengths in both averaging and detection.
enum OvulationCalculator {
    static let defaultCycleLength = 30
    static let lutealPhaseDays = 14
    static let fertileWindowDaysBeforeOvulation = 4
    static let fertileWindowDaysAfterOvulation = 1

    // A real human menstrual cycle interval is typically 21-45 days. Anything
    // outside this is almost certainly test data, a backdated edit mistake, or
    // a long gap in tracking — not a true cycle. We ignore such intervals when
    // averaging so they don't poison the prediction.
    static let plausibleIntervalRange = 15...60
    static let plausibleCycleLengthRange = 21...45

    // Returns nil when there's not enough confident data to compute a real
    // average — i.e. fewer than 2 entries, or no intervals fall in the
    // plausible 15-60 day range. UI that should only render when grounded
    // in real history (e.g. the "average cycle" row) should use this.
    static func averageCycleLengthIfAvailable(from entries: [PeriodEntry]) -> Int? {
        let sortedStarts = entries.map(\.startDate).sorted()
        guard sortedStarts.count >= 2 else { return nil }

        var intervals: [Int] = []
        for i in 1..<sortedStarts.count {
            let days = Calendar.current.dateComponents(
                [.day],
                from: sortedStarts[i - 1],
                to: sortedStarts[i]
            ).day ?? 0
            if plausibleIntervalRange.contains(days) {
                intervals.append(days)
            }
        }

        guard !intervals.isEmpty else { return nil }
        let average = Double(intervals.reduce(0, +)) / Double(intervals.count)
        return Int(average.rounded())
    }

    static func averageCycleLength(from entries: [PeriodEntry]) -> Int {
        averageCycleLengthIfAvailable(from: entries) ?? defaultCycleLength
    }

    static func ovulationDay(cycleLength: Int) -> Int {
        cycleLength - lutealPhaseDays
    }

    static func fertileWindow(cycleLength: Int) -> ClosedRange<Int> {
        let ovulation = ovulationDay(cycleLength: cycleLength)
        let start = ovulation - fertileWindowDaysBeforeOvulation
        let end = ovulation + fertileWindowDaysAfterOvulation
        return start...end
    }

    static func isInFertileWindow(cycleDay: Int, cycleLength: Int) -> Bool {
        // Predictions are only reliable for cycle lengths in the plausible range.
        guard plausibleCycleLengthRange.contains(cycleLength) else { return false }
        return fertileWindow(cycleLength: cycleLength).contains(cycleDay)
    }

    // Cycle day = days elapsed since the most recent period start, plus one
    // (cycle day 1 is the first day of bleeding).
    static func cycleDay(from periodStart: Date, today: Date = Date()) -> Int {
        let days = Calendar.current.dateComponents(
            [.day],
            from: Calendar.current.startOfDay(for: periodStart),
            to: Calendar.current.startOfDay(for: today)
        ).day ?? 0
        return max(days + 1, 1)
    }
}
