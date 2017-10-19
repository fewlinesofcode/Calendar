//
//  CalendarData.swift
//  Organizer
//
//  Created by Oleksandr Glagoliev on 23/09/2017.
//  Copyright © 2017 io.limlab. All rights reserved.
//

import UIKit

struct WeekdayDisplayData {
    var title: String
    var isDayOff: Bool
}

struct DayDisplayData {
    var title: String = "Not set"
    var numTasks: Int = 0
    var isToday: Bool = false
    var isDayOff: Bool = false
    var belongsToShownPeriod: Bool = true
}

enum CalendarContent {
    case prevMonthButton
    case monthIndicator(String)
    case nextMonthButton
    case prevYearButton
    case yearIndicator(String)
    case nextYearButton
    case weekday(WeekdayDisplayData)
    case day(DayDisplayData)
}

class CalendarData {
    let numWeeksToShow: Int = 6
    let numberOfDaysInWeek: Int = 7
    
    private let calendar = CalendarCore.calendar
    
    private (set) var heading: [CalendarContent] = []
    private (set) var weekdayNames: [CalendarContent] = []
    private (set) var days: [CalendarContent] = []
    
    let daysSection: Int = 2
    let headingSection: Int = 0
    let indicatorIndices: [Int] = [1, 4]
    
    private var seedDate: Date = Date() {
        didSet {
            heading = [
                .prevMonthButton,
                .monthIndicator(seedDate.monthName),
                .nextMonthButton,
                .prevYearButton,
                .yearIndicator(seedDate.year),
                .nextYearButton
            ]
            
            weekdayNames = [CalendarContent]()
            let names = CalendarCore.calendar.shortWeekdayNames
            for i in 0..<names.count {
                weekdayNames.append(.weekday(WeekdayDisplayData(title: names[i], isDayOff: Config.Main.dayOffs.contains(i))))
            }
            
            days = CalendarData.daysFor(seed: seedDate)
        }
    }
    
    init() {
    }
    
    // MARK: Public functions
    func showToday() {
        self.seedDate = Date()
    }
    
    func showDate(date: Date) {
        self.seedDate = date
    }
    
    func switchToPrevYear() {
        seedDate = calendar.firstDayOfMonth(for: calendar.date(byAdding: (-1).years, to: seedDate)!)
    }
    
    func switchToNextYear() {
        seedDate = calendar.firstDayOfMonth(for: calendar.date(byAdding: (1).years, to: seedDate)!)
    }
    
    func switchToPrevMonth() {
        seedDate = calendar.firstDayOfMonth(for: calendar.date(byAdding: (-1).months, to: seedDate)!)
    }
    
    func switchToNextMonth() {
        seedDate = calendar.firstDayOfMonth(for: calendar.date(byAdding: (1).months, to: seedDate)!)
    }
    
    var sections: [[CalendarContent]] {
        return [heading, weekdayNames, days]
    }
    
    // MARK: Private functions
    private static func daysFor(seed: Date, numWeeks: Int = 6) -> [CalendarContent] {
        return CalendarCore.calendar.monthDates(for: seed, weeks: numWeeks).map({ date in
            var dayData = DayDisplayData()
            dayData.title = date.day
            dayData.belongsToShownPeriod = date.isInSameMonth(date: seed)
            dayData.isDayOff = false
            dayData.isToday = date.isInToday
            return .day(dayData)
        })
    }
}
