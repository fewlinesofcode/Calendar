//
//  CalendarCore.swift
//  Organizer
//
//  Created by Oleksandr Glagoliev on 09/10/2017.
//  Copyright © 2017 io.limlab. All rights reserved.
//

import UIKit

struct CalendarCore {
    static let calendar = Calendar(identifier: .gregorian)
}

extension Calendar {
    static let numDaysInWeek: Int = 7
    
    var shortWeekdayNames: [String] {
        var names = shortWeekdaySymbols
        Array.shiftRight(array: &names, numPositions: firstWeekday)
        return names
    }
    
    func endOfDay(for date: Date) -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return self.date(byAdding: components, to: startOfDay(for: date))!
    }
    
    func lastDayOfMonth(for date: Date) -> Date {
        let dayRange = range(of: .day, in: .month, for: date)
        let dayCount = dayRange!.count
        var comps = dateComponents([.year, .month, .day], from: date)
        
        comps.day = dayCount
        
        return self.date(from: comps)!
    }
    
    func firstDayOfMonth(for date: Date) -> Date {
        var comps = dateComponents([.year, .month, .day], from: date)
        comps.setValue(1, for: .day)
        return self.date(from: comps)!
    }
    
    
    
    
    
    func firstDayOfWeek(for date: Date) -> Date {
        let posInWeek = dayIndexInWeek(for: date)
        if posInWeek == 0 {
            return startOfDay(for: date)
        }
        let res = self.date(byAdding: (-posInWeek).days, to: date)
        return startOfDay(for: res!)
    }
    
    func lastDayOfWeek(for date: Date) -> Date {
        let posInWeek = dayIndexInWeek(for: date)
        if posInWeek == 6 {
            return startOfDay(for: date)
        }
        let res = self.date(byAdding: (6-posInWeek).days, to: date)
        return endOfDay(for: res!)
    }
    
    
    func monthDates(for date: Date, weeks: Int = 0) -> [Date] {
        //CalendarCore.calendar.firstDayOfWeek(for: firstDayOfMonth(for: date))
        let fst, lst: Date
        if weeks == 0 {
            fst = firstDayOfMonth(for: date)
            lst = lastDayOfMonth(for: date)
        } else {
            fst = CalendarCore.calendar.firstDayOfWeek(for: firstDayOfMonth(for: date))
            lst = CalendarCore.calendar.date(byAdding: (weeks * Calendar.numDaysInWeek).days, to: fst)!
        }
        let components = dateComponents([.day], from: fst, to: lst)
        print(components)
        var dates = [Date]()
        
        for i in 0..<components.day! {
            let day = self.startOfDay(for: self.date(byAdding: i.days, to: fst)!)
            dates.append(day)
        }
        return dates
    }
    
    func rangeGrid(from startDate: Date, endDate: Date) -> [[Date]] {
        let fst = startOfDay(for: startDate)
        let lst = endOfDay(for: endDate)
        let components = dateComponents([.day], from: fst, to: lst)

        var grid: [[Date]] = []

        var dates = [Date]()
        for i in 0...components.day! {
            let day = self.startOfDay(for: self.date(byAdding: i.days, to: fst)!)
            dates.append(day)
        }

        var lastWeek = [Date]()
        for i in 0..<dates.count {
            let date = dates[i]
            let pos = dayIndexInWeek(for: date)
            if pos == 0 {
                if lastWeek.count > 0 {
                    grid.append(lastWeek)
                }
                lastWeek.removeAll()
                lastWeek.append(date)
            } else {
                lastWeek.append(date)
            }
        }
        if lastWeek.count > 0 {
            grid.append(lastWeek)
        }

        for week in grid {
            let strWeek = week.reduce("", {
                $0 + "[\($1.day)]"
            })
            print(strWeek)
        }
        return grid
    }

    func monthGrid(for date: Date) -> [[Date]] {
        let fst = firstDayOfMonth(for: date)
        let lst = lastDayOfMonth(for: date)
        return rangeGrid(from: fst, endDate: lst)
    }
    
    func dayIndexInMonth(for date: Date) -> Int? {
        let comps = dateComponents([.day], from: date)
        return comps.day
    }
    
    func dayIndexInWeek(for date: Date) -> Int {
        let index = dateComponents([.weekday], from: date).weekday! - firstWeekday - 1
        if index < 0 {
            return index + 7
        }
        return index
    }
    
    
}


extension Date {
    var weekdayName: String {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "EEE"
        return df.string(from: self)
    }
    
    var monthName: String {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "MMMM"
        return df.string(from: self)
    }
    
    var day: String {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "d"
        return df.string(from: self)
    }
    
    var year: String {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy"
        return df.string(from: self)
    }
    
    static func fromString(str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-M-yyyy"
        let date = dateFormatter.date(from: str)
        return date
    }
}

extension Date {
    func isInSameWeek(date: Date) -> Bool {
        return CalendarCore.calendar.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }
    func isInSameMonth(date: Date) -> Bool {
        return CalendarCore.calendar.isDate(self, equalTo: date, toGranularity: .month)
    }
    func isInSameYear(date: Date) -> Bool {
        return CalendarCore.calendar.isDate(self, equalTo: date, toGranularity: .year)
    }
    func isInSameDay(date: Date) -> Bool {
        return CalendarCore.calendar.isDate(self, equalTo: date, toGranularity: .day)
    }
    var isInThisWeek: Bool {
        return isInSameWeek(date: Date())
    }
    var isInToday: Bool {
        return CalendarCore.calendar.isDateInToday(self)
    }
}

extension Array {
    static func shiftRight(array: inout Array, numPositions: Int) {
        var pos = numPositions
        while pos > 0 {
            pos -= 1
            array.append(array.removeFirst())
        }
    }
}

extension Int {
    public var days: DateComponents {
        return calendarComponent(comp: .day)
    }
    
    public var months: DateComponents {
        return calendarComponent(comp: .month)
    }
    
    public var years: DateComponents {
        return calendarComponent(comp: .year)
    }
    
    private func calendarComponent(comp: Calendar.Component) -> DateComponents {
        var dateComponents = DateComponents()
        dateComponents.setValue(self, for: comp)
        return dateComponents
    }
}

