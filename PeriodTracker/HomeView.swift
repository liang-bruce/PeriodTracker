//
//  HomeView.swift
//  PeriodTracker
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appCopy) private var copy
    @Query(sort: \PeriodEntry.startDate, order: .reverse) private var entries: [PeriodEntry]

    // Picker needs a writable binding, so this stays even though reads come from `copy`.
    @AppStorage("appLanguage") private var appLanguageCode: String = "zh-Hans"
    @AppStorage("periodDurationDays") private var periodDurationDays: Int = 5
    @AppStorage("cycleLengthDays") private var cycleLengthDays: Int = 30

    // Auto-derived average cycle length used for ovulation/fertile-window calculation.
    // Each device computes this from the same CloudKit-synced PeriodEntry data, so the
    // value converges to the same number on iPhone and Watch without explicit sync.
    @AppStorage("averageCycleLengthDays") private var averageCycleLengthDays: Int = OvulationCalculator.defaultCycleLength

    @State private var showTipJar = false
    @State private var showFertileInfo = false

    private var currentPeriodEntry: PeriodEntry? {
        entries.first(where: { $0.endDate == nil })
    }

    private var latestEndedPeriod: PeriodEntry? {
        entries.first(where: { $0.endDate != nil })
    }

    private var isInPeriod: Bool {
        currentPeriodEntry != nil
    }

    private var lastEndDateString: String? {
        guard !isInPeriod, let endDate = latestEndedPeriod?.endDate else {
            return nil
        }
        return DateFormatters.entryDate.string(from: endDate)
    }

    private var daysSinceLastEnd: Int? {
        guard !isInPeriod, let endDate = latestEndedPeriod?.endDate else {
            return nil
        }

        return Calendar.current.dateComponents([.day], from: endDate, to: Date()).day
    }

    private var currentPeriodDay: Int? {
        guard let startDate = currentPeriodEntry?.startDate else {
            return nil
        }

        let rawValue = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        return max(rawValue + 1, 1)
    }

    // The actually-measured average from entries, or nil if we don't have
    // enough plausible data yet. Used for the optional "Average cycle" row
    // so that row only appears when grounded in real history (not the
    // 30-day default that powers the fertile-window calculation).
    private var measuredAverageCycleLength: Int? {
        OvulationCalculator.averageCycleLengthIfAvailable(from: entries)
    }

    private var isInFertileWindow: Bool {
        guard !isInPeriod, let mostRecentStart = latestEndedPeriod?.startDate else {
            return false
        }
        let cycleDay = OvulationCalculator.cycleDay(from: mostRecentStart)
        return OvulationCalculator.isInFertileWindow(
            cycleDay: cycleDay,
            cycleLength: averageCycleLengthDays
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                VStack(alignment: .leading, spacing: 16) {
                    if let dateText = lastEndDateString {
                        infoRow(title: copy.text(.lastEndDate), value: dateText)
                    }

                    if let days = daysSinceLastEnd {
                        daysSinceRow(days: days)
                    }

                    if let day = currentPeriodDay {
                        Text(copy.currentDayText(day))
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.primary)
                    }

                    if let avg = measuredAverageCycleLength {
                        infoRow(title: copy.text(.averageCycle), value: copy.daysText(avg))
                    }

                    Button(action: handlePeriodButtonTapped) {
                        Text(isInPeriod ? copy.text(.endPeriod) : copy.text(.startPeriod))
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(.systemPink))
                            )
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)

                    Spacer(minLength: 0)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.regularMaterial)
                )
                .padding()
            }
            .navigationTitle(copy.text(.title))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    menuButton
                }
            }
            .sheet(isPresented: $showTipJar) {
                TipJarView()
            }
            .sheet(isPresented: $showFertileInfo) {
                FertileWindowInfoView()
            }
            .task {
                recomputeAverageCycleLength()
                updateWidgetSnapshot()
            }
            .onChange(of: entries) { _, _ in
                recomputeAverageCycleLength()
                updateWidgetSnapshot()
            }
            .onChange(of: averageCycleLengthDays) { _, _ in updateWidgetSnapshot() }
            .onChange(of: appLanguageCode) { _, _ in updateWidgetSnapshot() }
        }
    }

    private var menuButton: some View {
        Menu {
            Picker(copy.text(.language), selection: $appLanguageCode) {
                Text(copy.text(.chinese)).tag(AppLanguage.chinese.rawValue)
                Text(copy.text(.english)).tag(AppLanguage.english.rawValue)
            }

            Divider()

            Stepper(value: $periodDurationDays, in: 1...15) {
                Text("\(copy.text(.periodDuration)): \(copy.daysText(periodDurationDays))")
            }

            Stepper(value: $cycleLengthDays, in: 15...150) {
                Text("\(copy.text(.cycleLength)): \(copy.daysText(cycleLengthDays))")
            }

            Divider()

            Button {
                showTipJar = true
            } label: {
                Label(copy.text(.supportApp), systemImage: "heart")
            }
        } label: {
            Image(systemName: "line.3.horizontal")
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text(title)
                .foregroundStyle(.secondary)
            Text(value)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .font(.body)
    }

    private func daysSinceRow(days: Int) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text(copy.text(.daysSince))
                .foregroundStyle(.secondary)
            Text(copy.daysText(days))
                .fontWeight(.semibold)
                .foregroundStyle(isInFertileWindow ? Color(.systemPink) : .primary)
            if isInFertileWindow {
                Button {
                    showFertileInfo = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(copy.text(.fertileWindowInfoLabel))
            }
        }
        .font(.body)
    }

    private func handlePeriodButtonTapped() {
        if let activeEntry = currentPeriodEntry {
            activeEntry.endDate = Date()
            return
        }

        let newEntry = PeriodEntry(startDate: Date())
        modelContext.insert(newEntry)
    }

    private func recomputeAverageCycleLength() {
        averageCycleLengthDays = OvulationCalculator.averageCycleLength(from: entries)
    }

    private func updateWidgetSnapshot() {
        WidgetSnapshot(
            activePeriodStart: currentPeriodEntry?.startDate,
            lastEndedStart: latestEndedPeriod?.startDate,
            lastEndedEnd: latestEndedPeriod?.endDate,
            averageCycleLength: averageCycleLengthDays,
            languageCode: appLanguageCode
        ).save()
    }
}

#Preview {
    HomeView()
        .modelContainer(for: PeriodEntry.self, inMemory: true)
}
