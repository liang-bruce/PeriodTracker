//
//  EditEntryView.swift
//  PeriodTracker
//

import SwiftUI
import SwiftData

struct EditEntryView: View {
    let entry: PeriodEntry

    @Environment(\.dismiss) private var dismiss
    @Environment(\.appCopy) private var copy

    @State private var startDate: Date
    @State private var endDate: Date

    init(entry: PeriodEntry) {
        self.entry = entry
        _startDate = State(initialValue: entry.startDate)
        _endDate = State(initialValue: entry.endDate ?? Date())
    }

    var body: some View {
        NavigationStack {
            Form {
                DatePicker(
                    copy.text(.editStartDate),
                    selection: $startDate,
                    displayedComponents: .date
                )

                DatePicker(
                    copy.text(.editEndDate),
                    selection: $endDate,
                    in: startDate...,
                    displayedComponents: .date
                )
            }
            .navigationTitle(copy.text(.editEntryTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(copy.text(.cancel)) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(copy.text(.save)) { save() }
                }
            }
            .onChange(of: startDate) { _, newStart in
                if endDate < newStart {
                    endDate = newStart
                }
            }
        }
    }

    private func save() {
        entry.startDate = startDate
        entry.endDate = max(endDate, startDate)
        dismiss()
    }
}
