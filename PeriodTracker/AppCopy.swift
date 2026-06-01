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
    case tipSmall
    case tipMedium
    case tipLarge
    case fertileWindowTitle
    case fertileWindowAlgorithm
    case fertileWindowBookCitation
    case fertileWindowDefaultNote
    case fertileWindowInfoLabel
    case close
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
        case (.chinese, .tipSmall): return "小杯咖啡"
        case (.english, .tipSmall): return "Small coffee"
        case (.chinese, .tipMedium): return "中杯咖啡"
        case (.english, .tipMedium): return "Medium coffee"
        case (.chinese, .tipLarge): return "大杯咖啡"
        case (.english, .tipLarge): return "Large coffee"
        case (.chinese, .fertileWindowTitle): return "受孕窗口"
        case (.english, .fertileWindowTitle): return "Fertile Window"
        case (.chinese, .fertileWindowAlgorithm):
            return """
            日历法

            日历法有助于判断月经周期的平均天数及大概的排卵时间。如果你并不清楚自己的月经周期，就记录几个月——连续记录 6~12 个月准确性更高。

            确定了月经周期的平均天数后，就能大概估计排卵期了。需要牢记黄体期——也就是排卵后身体准备怀孕的阶段——通常固定为 14 天。因此，如果月经周期是 30 天，那么排卵期差不多在月经的第 16 天（30 天 - 14 天 = 16 天）。那么，最佳的受孕时机就是月经第 12~17 天。如果在这段时间内隔日同房，精子就有机会与卵母细胞相遇。

            如果你觉得这种方法太复杂，乔治城大学的研究者开发了一种计算机模型，能够计算月经周期不同时间的受孕率。研究发现，对于月经周期规律，26~32 天的女性，最佳的受孕时机为月经的第 8~19 天。
            """
        case (.english, .fertileWindowAlgorithm):
            return """
            Calendar method

            The calendar method helps estimate your average cycle length and approximate ovulation timing. If you don't know your cycle yet, log a few months — six to twelve consecutive months gives better accuracy.

            Once you know the average cycle length, you can estimate ovulation. Remember that the luteal phase — the post-ovulation phase when the body prepares for pregnancy — is generally a fixed 14 days. So if the cycle is 30 days, ovulation is roughly on cycle day 16 (30 - 14 = 16). The best window for conception is therefore around cycle days 12 to 17. Having intercourse every other day in this window gives sperm a chance to meet the egg.

            If this feels too complex, researchers at Georgetown University developed a computational model that calculates the probability of conception across the cycle. For women with regular cycles of 26-32 days, the model identifies cycle days 8 to 19 as the optimal window.
            """
        case (.chinese, .fertileWindowBookCitation):
            return "出处：《梅奥备孕全书 提高生育力的全方位医学权威指南》"
        case (.english, .fertileWindowBookCitation):
            return "Source: Mayo Clinic Guide to Fertility and Conception"
        case (.chinese, .fertileWindowDefaultNote):
            return "记录不足时，平均经期间隔默认为 30 天。"
        case (.english, .fertileWindowDefaultNote):
            return "When there are not enough records yet, the average cycle interval defaults to 30 days."
        case (.chinese, .fertileWindowInfoLabel): return "了解排卵期"
        case (.english, .fertileWindowInfoLabel): return "About fertile window"
        case (.chinese, .close): return "关闭"
        case (.english, .close): return "Close"
        }
    }

    // StoreKit's `product.displayName` follows the user's App Store account language,
    // not the app's internal language toggle. Map our product IDs to AppCopy strings
    // so the tip jar respects the in-app language setting.
    func tipDisplayName(for productID: String) -> String {
        switch productID {
        case "com.jitianliang.PeriodTracker.tip.small": return text(.tipSmall)
        case "com.jitianliang.PeriodTracker.tip.medium": return text(.tipMedium)
        case "com.jitianliang.PeriodTracker.tip.large": return text(.tipLarge)
        default: return text(.tipSmall) // fallback
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
