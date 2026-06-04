//
//  PeriodWidget.swift
//  PeriodWidget
//
//  Small home-screen widget. Reads the shared snapshot written by the main
//  app via the group.com.jitianliang.PeriodTracker App Group container.
//

import WidgetKit
import SwiftUI

struct PeriodWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "PeriodWidget", provider: PeriodWidgetProvider()) { entry in
      PeriodWidgetView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("Period Tracker")
    .description("Current cycle status at a glance.")
    .supportedFamilies([.systemSmall])
  }
}

struct PeriodWidgetEntry: TimelineEntry {
  let date: Date
  let snapshot: WidgetSnapshot
}

struct PeriodWidgetProvider: TimelineProvider {
  func placeholder(in context: Context) -> PeriodWidgetEntry {
    PeriodWidgetEntry(date: Date(), snapshot: WidgetSnapshot.load())
  }
  
  func getSnapshot(in context: Context, completion: @escaping (PeriodWidgetEntry) -> Void) {
    completion(PeriodWidgetEntry(date: Date(), snapshot: WidgetSnapshot.load()))
  }
  
  // Generate one entry per day for roughly one cycle ahead, so the widget
  // stays accurate without needing the main app to wake up. The snapshot
  // itself doesn't change between entries — only the rendering date
  // advances, which is what changes the displayed day count and the
  // fertile-window flag. A floor of 14 days protects against silly
  // tiny-cycle snapshots; we cap at 60 to bound memory.
  func getTimeline(in context: Context, completion: @escaping (Timeline<PeriodWidgetEntry>) -> Void) {
    let snapshot = WidgetSnapshot.load()
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let dayCount = min(max(snapshot.averageCycleLength, 14), 60)

    var entries: [PeriodWidgetEntry] = []
    for offset in 0..<dayCount {
      if let date = calendar.date(byAdding: .day, value: offset, to: today) {
        entries.append(PeriodWidgetEntry(date: date, snapshot: snapshot))
      }
    }

    let refreshAfter = calendar.date(byAdding: .day, value: dayCount, to: today) ?? today
    completion(Timeline(entries: entries, policy: .after(refreshAfter)))
  }
}

struct PeriodWidgetView: View {
  let entry: PeriodWidgetEntry
  
  private var copy: AppCopy {
    AppCopy(language: AppLanguage.from(code: entry.snapshot.languageCode))
  }
  
  private var isInPeriod: Bool {
    entry.snapshot.activePeriodStart != nil
  }
  
  private var hasAnyHistory: Bool {
    entry.snapshot.activePeriodStart != nil || entry.snapshot.lastEndedStart != nil
  }
  
  private var currentPeriodDay: Int? {
    guard let start = entry.snapshot.activePeriodStart else { return nil }
    return OvulationCalculator.cycleDay(from: start, today: entry.date)
  }
  
  private var daysSinceLastEnd: Int? {
    guard !isInPeriod, let end = entry.snapshot.lastEndedEnd else { return nil }
    let days = Calendar.current.dateComponents(
      [.day],
      from: Calendar.current.startOfDay(for: end),
      to: Calendar.current.startOfDay(for: entry.date)
    ).day ?? 0
    return max(days, 0)
  }
  
  private var isInFertileWindow: Bool {
    guard !isInPeriod, let lastEndedStart = entry.snapshot.lastEndedStart else { return false }
    let cycleDay = OvulationCalculator.cycleDay(from: lastEndedStart, today: entry.date)
    return OvulationCalculator.isInFertileWindow(
      cycleDay: cycleDay,
      cycleLength: entry.snapshot.averageCycleLength
    )
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      if !hasAnyHistory {
        Spacer()
        Text(copy.text(.widgetNoData))
          .font(.callout.weight(.medium))
          .foregroundStyle(.secondary)
        Spacer()
      } else if let day = currentPeriodDay {
        Text(copy.text(.widgetPeriodDayLabel))
          .font(.caption)
          .foregroundStyle(.secondary)
        Text("\(day)")
          .font(.system(size: 48, weight: .semibold, design: .rounded))
          .foregroundStyle(.primary)
          .minimumScaleFactor(0.6)
        Spacer(minLength: 0)
      } else if let days = daysSinceLastEnd {
        Text(copy.text(.widgetDaysSinceLabel))
          .font(.caption)
          .foregroundStyle(.secondary)
        Text("\(days)")
          .font(.system(size: 48, weight: .semibold, design: .rounded))
          .foregroundStyle(isInFertileWindow ? Color(.systemPink) : .primary)
          .minimumScaleFactor(0.6)
        Spacer(minLength: 0)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}

#Preview(as: .systemSmall) {
  PeriodWidget()
} timeline: {
  PeriodWidgetEntry(
    date: Date(),
    snapshot: WidgetSnapshot(
      activePeriodStart: nil,
      lastEndedStart: Calendar.current.date(byAdding: .day, value: -14, to: Date()),
      lastEndedEnd: Calendar.current.date(byAdding: .day, value: -9, to: Date()),
      averageCycleLength: 30,
      languageCode: "en"
    )
  )
}
