//
//  PeriodTrackerApp.swift
//  PeriodTracker
//
//  Created by 梁纪田 on 3/3/2026.
//

import SwiftUI
import SwiftData

@main
struct PeriodTrackerApp: App {
    @AppStorage("appLanguage") private var appLanguageCode: String = "zh-Hans"

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
            ContentView()
                .environment(\.locale, Locale(identifier: appLanguageCode))
                .environment(\.appCopy, AppCopy(language: AppLanguage.from(code: appLanguageCode)))
        }
        .modelContainer(sharedModelContainer)
    }
}
