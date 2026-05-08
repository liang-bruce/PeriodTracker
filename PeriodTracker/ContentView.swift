//
//  ContentView.swift
//  PeriodTracker
//
//  Created by 梁纪田 on 3/3/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.appCopy) private var copy

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label(copy.text(.todayTab), systemImage: "drop.fill")
                }

            HistoryView()
                .tabItem {
                    Label(copy.text(.historyTab), systemImage: "list.bullet.rectangle")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: PeriodEntry.self, inMemory: true)
}
