//
//  AppLanguage.swift
//  PeriodTracker
//

import Foundation

enum AppLanguage: String {
    case chinese = "zh-Hans"
    case english = "en"

    static func from(code: String) -> AppLanguage {
        AppLanguage(rawValue: code) ?? systemDefault
    }

    // The user's preferred system language, mapped to a language we support.
    // Used as the first-launch default so the app doesn't always open in Chinese
    // on devices with non-Chinese locales.
    static var systemDefault: AppLanguage {
        let preferred = Locale.preferredLanguages.first ?? "en"
        return preferred.hasPrefix("zh") ? .chinese : .english
    }
}
