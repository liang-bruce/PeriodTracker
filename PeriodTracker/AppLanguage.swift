//
//  AppLanguage.swift
//  PeriodTracker
//

import Foundation

enum AppLanguage: String {
    case chinese = "zh-Hans"
    case english = "en"

    static func from(code: String) -> AppLanguage {
        AppLanguage(rawValue: code) ?? .chinese
    }
}
