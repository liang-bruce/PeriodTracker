//
//  AppCopy.swift
//  PeriodTracker
//

import Foundation

enum CopyKey {
    case title
    case language
    case chinese
    case english
    case periodDuration
    case cycleLength
    case lastEndDate
    case daysSince
    case currentDay
    case startPeriod
    case endPeriod
    case todayTab
    case historyTab
    case filterFrom
    case filterTo
    case filterSection
    case entriesSection
    case noEntries
    case edit
    case delete
    case save
    case cancel
    case editEntryTitle
    case editStartDate
    case editEndDate
    case supportApp
    case supportSubtitle
    case tipThankYou
    case tipUnavailable
    case done
}

struct AppCopy {
    let language: AppLanguage

    func text(_ key: CopyKey) -> String {
        switch (language, key) {
        case (.chinese, .title): return "经期记录"
        case (.english, .title): return "Period Tracker"
        case (.chinese, .language): return "语言"
        case (.english, .language): return "Language"
        case (.chinese, .chinese): return "中文"
        case (.english, .chinese): return "Chinese"
        case (.chinese, .english): return "英文"
        case (.english, .english): return "English"
        case (.chinese, .periodDuration): return "经期时长"
        case (.english, .periodDuration): return "Period Length"
        case (.chinese, .cycleLength): return "经期间隔"
        case (.english, .cycleLength): return "Cycle Length"
        case (.chinese, .lastEndDate): return "上次记录经期结束:"
        case (.english, .lastEndDate): return "Last period ended:"
        case (.chinese, .daysSince): return "距今:"
        case (.english, .daysSince): return "Days since:"
        case (.chinese, .currentDay): return "经期第"
        case (.english, .currentDay): return "Period day"
        case (.chinese, .startPeriod): return "经期开始"
        case (.english, .startPeriod): return "Start Period"
        case (.chinese, .endPeriod): return "经期结束"
        case (.english, .endPeriod): return "End Period"
        case (.chinese, .todayTab): return "今日"
        case (.english, .todayTab): return "Today"
        case (.chinese, .historyTab): return "历史"
        case (.english, .historyTab): return "History"
        case (.chinese, .filterFrom): return "起始"
        case (.english, .filterFrom): return "From"
        case (.chinese, .filterTo): return "结束"
        case (.english, .filterTo): return "To"
        case (.chinese, .filterSection): return "筛选时间范围"
        case (.english, .filterSection): return "Date Range"
        case (.chinese, .entriesSection): return "记录"
        case (.english, .entriesSection): return "Entries"
        case (.chinese, .noEntries): return "暂无记录"
        case (.english, .noEntries): return "No entries"
        case (.chinese, .edit): return "编辑"
        case (.english, .edit): return "Edit"
        case (.chinese, .delete): return "删除"
        case (.english, .delete): return "Delete"
        case (.chinese, .save): return "保存"
        case (.english, .save): return "Save"
        case (.chinese, .cancel): return "取消"
        case (.english, .cancel): return "Cancel"
        case (.chinese, .editEntryTitle): return "编辑记录"
        case (.english, .editEntryTitle): return "Edit Entry"
        case (.chinese, .editStartDate): return "开始日期"
        case (.english, .editStartDate): return "Start Date"
        case (.chinese, .editEndDate): return "结束日期"
        case (.english, .editEndDate): return "End Date"
        case (.chinese, .supportApp): return "请作者喝杯咖啡"
        case (.english, .supportApp): return "Buy me a coffee"
        case (.chinese, .supportSubtitle): return "如果你喜欢这个 app，欢迎请作者喝杯咖啡"
        case (.english, .supportSubtitle): return "If you enjoy the app, consider supporting the developer"
        case (.chinese, .tipThankYou): return "谢谢支持！"
        case (.english, .tipThankYou): return "Thank you for your support!"
        case (.chinese, .tipUnavailable): return "暂时无法加载"
        case (.english, .tipUnavailable): return "Unavailable"
        case (.chinese, .done): return "完成"
        case (.english, .done): return "Done"
        }
    }

    func durationText(_ days: Int) -> String {
        if language == .english {
            return "\(days) day\(days == 1 ? "" : "s")"
        }
        return "持续\(days)天"
    }

    func sinceLastText(_ days: Int) -> String {
        if language == .english {
            return "\(days) day\(days == 1 ? "" : "s") since last"
        }
        return "距上次\(days)天"
    }

    func daysText(_ days: Int) -> String {
        if language == .english {
            return "\(days) day\(days == 1 ? "" : "s")"
        }
        return "\(days)天"
    }

    func currentDayText(_ day: Int) -> String {
        if language == .english {
            return "\(text(.currentDay)) \(day)"
        }
        return "\(text(.currentDay))\(day)天"
    }
}
