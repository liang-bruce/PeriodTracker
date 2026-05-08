//
//  AppCopyEnvironment.swift
//  PeriodTracker
//

import SwiftUI

private struct AppCopyKey: EnvironmentKey {
    static let defaultValue = AppCopy(language: .chinese)
}

extension EnvironmentValues {
    var appCopy: AppCopy {
        get { self[AppCopyKey.self] }
        set { self[AppCopyKey.self] = newValue }
    }
}
