//
//  WatchHomeView.swift
//  PeriodTrackerWatch Watch App
//

import SwiftUI
import SwiftData

struct WatchHomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appCopy) private var copy
    @Query(sort: \PeriodEntry.startDate, order: .reverse) private var entries: [PeriodEntry]

    private var currentPeriodEntry: PeriodEntry? {
        entries.first(where: { $0.endDate == nil })
    }

    private var latestEndedPeriod: PeriodEntry? {
        entries.first(where: { $0.endDate != nil })
    }

    private var isInPeriod: Bool {
        currentPeriodEntry != nil
    }

    private var currentPeriodDay: Int? {
        guard let startDate = currentPeriodEntry?.startDate else { return nil }
        let raw = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        return max(raw + 1, 1)
    }

    private var daysSinceLastEnd: Int? {
        guard !isInPeriod, let endDate = latestEndedPeriod?.endDate else { return nil }
        return Calendar.current.dateComponents([.day], from: endDate, to: Date()).day
    }

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 8) {
                Spacer(minLength: 0)

                statusBlock

                Spacer(minLength: 0)

                Button(action: handleButtonTapped) {
                    Text(isInPeriod ? copy.text(.endPeriod) : copy.text(.startPeriod))
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
            }
            .padding(.vertical, 4)
        }
    }

    @ViewBuilder
    private var statusBlock: some View {
        if let day = currentPeriodDay {
            Text(copy.currentDayText(day))
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
        } else if let days = daysSinceLastEnd {
            VStack(spacing: 2) {
                Text(copy.text(.daysSince))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(copy.daysText(days))
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
            }
        }
        // Empty state (no records yet): no status text, just the start button below.
    }

    private func handleButtonTapped() {
        if let active = currentPeriodEntry {
            active.endDate = Date()
            return
        }
        let newEntry = PeriodEntry(startDate: Date())
        modelContext.insert(newEntry)
    }
}

#Preview {
    WatchHomeView()
        .modelContainer(for: PeriodEntry.self, inMemory: true)
}
