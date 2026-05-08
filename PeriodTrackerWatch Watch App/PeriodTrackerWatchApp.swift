//
//  PeriodTrackerWatchApp.swift
//  PeriodTrackerWatch Watch App
//
//  Created by 梁纪田 on 8/5/2026.
//

import SwiftUI
import SwiftData

@main
struct PeriodTrackerWatchApp: App {
    @AppStorage("appLanguage") private var appLanguageCode: String = "en"

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PeriodEntry.self,
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            WatchHomeView()
                .environment(\.locale, Locale(identifier: appLanguageCode))
                .environment(\.appCopy, AppCopy(language: AppLanguage.from(code: appLanguageCode)))
        }
        .modelContainer(sharedModelContainer)
    }
}
