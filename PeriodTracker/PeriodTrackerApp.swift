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
    init() {
        // Register a system-locale-derived default for appLanguage. This only takes
        // effect on first launch (before the user has explicitly chosen a language).
        UserDefaults.standard.register(defaults: ["appLanguage": AppLanguage.systemDefault.rawValue])
    }

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
            ContentView()
                .environment(\.locale, Locale(identifier: appLanguageCode))
                .environment(\.appCopy, AppCopy(language: AppLanguage.from(code: appLanguageCode)))
        }
        .modelContainer(sharedModelContainer)
    }
}
