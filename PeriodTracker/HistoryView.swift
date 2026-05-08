//
//  HistoryView.swift
//  PeriodTracker
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appCopy) private var copy
    @Query(sort: \PeriodEntry.startDate, order: .reverse) private var entries: [PeriodEntry]

    @State private var filterFrom: Date = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
    @State private var filterTo: Date = Date()
    @State private var editingEntry: PeriodEntry?

    // Filter criteria: an entry's period [entryStart, entryEnd] is included when it overlaps
    // the selected range [filterFrom, filterTo] — i.e. entryStart <= filterTo AND entryEnd >= filterFrom.
    // Example: entry 2024-12-30 → 2025-01-03 with filter 2025-01-01 → 2025-06-01:
    //   entryStart (2024-12-30) <= filterTo  (2025-06-01) ✓
    //   entryEnd   (2025-01-03) >= filterFrom (2025-01-01) ✓  → entry is shown.
    // Ongoing entries (endDate == nil) are excluded — history shows completed periods only;
    // the active period lives on the Home tab.
    private var filteredEntries: [PeriodEntry] {
        let calendar = Calendar.current
        let rangeStart = calendar.startOfDay(for: filterFrom)
        let rangeEnd = calendar.startOfDay(for: filterTo)
        return entries.filter { entry in
            guard let entryEndDate = entry.endDate else { return false }
            let entryStart = calendar.startOfDay(for: entry.startDate)
            let entryEnd = calendar.startOfDay(for: entryEndDate)
            return entryStart <= rangeEnd && entryEnd >= rangeStart
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                List {
                    Section(copy.text(.filterSection)) {
                        DatePicker(
                            copy.text(.filterFrom),
                            selection: $filterFrom,
                            in: ...filterTo,
                            displayedComponents: .date
                        )
                        DatePicker(
                            copy.text(.filterTo),
                            selection: $filterTo,
                            in: filterFrom...,
                            displayedComponents: .date
                        )
                    }

                    Section(copy.text(.entriesSection)) {
                        if filteredEntries.isEmpty {
                            Text(copy.text(.noEntries))
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(filteredEntries) { entry in
                                entryRow(for: entry)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button(role: .destructive) {
                                            modelContext.delete(entry)
                                        } label: {
                                            Label(copy.text(.delete), systemImage: "trash")
                                        }

                                        Button {
                                            editingEntry = entry
                                        } label: {
                                            Label(copy.text(.edit), systemImage: "pencil")
                                        }
                                        .tint(.blue)
                                    }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(copy.text(.historyTab))
            .sheet(item: $editingEntry) { entry in
                EditEntryView(entry: entry)
            }
        }
    }

    private func entryRow(for entry: PeriodEntry) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(DateFormatters.entryDate.string(from: entry.startDate))
                .font(.body.weight(.semibold))
                .foregroundStyle(.primary)

            HStack(spacing: 8) {
                Text(durationLabel(for: entry))
                if let gap = daysSincePrevious(for: entry) {
                    Text("·").foregroundStyle(.secondary)
                    Text(copy.sinceLastText(gap))
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }

    private func durationLabel(for entry: PeriodEntry) -> String {
        let endDate = entry.endDate ?? Date()
        let days = (Calendar.current.dateComponents([.day], from: entry.startDate, to: endDate).day ?? 0) + 1
        return copy.durationText(max(days, 1))
    }

    // Gap to the previous entry, measured start-to-start (matching the "经期间隔" / cycle-length concept).
    private func daysSincePrevious(for entry: PeriodEntry) -> Int? {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return nil }
        // entries are sorted newest-first, so the previous entry chronologically is at index + 1.
        let previousIndex = index + 1
        guard previousIndex < entries.count else { return nil }
        let previousStart = entries[previousIndex].startDate
        return Calendar.current.dateComponents([.day], from: previousStart, to: entry.startDate).day
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: PeriodEntry.self, inMemory: true)
}
