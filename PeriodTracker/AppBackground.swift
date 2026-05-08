//
//  AppBackground.swift
//  PeriodTracker
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: gradientColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    // UIColor.systemPink / .systemBlue aren't available on watchOS,
    // so fall back to SwiftUI's built-in .pink / .blue there.
    private var gradientColors: [Color] {
        #if os(watchOS)
        [Color.pink.opacity(0.12), Color.blue.opacity(0.08)]
        #else
        [Color(.systemPink).opacity(0.12), Color(.systemBlue).opacity(0.08)]
        #endif
    }
}
