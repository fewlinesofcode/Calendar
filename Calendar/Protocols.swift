//
//  Protocols.swift
//  Organizer
//
//  Created by Oleksandr Glagoliev on 14/10/2017.
//  Copyright © 2017 io.limlab. All rights reserved.
//

import UIKit

protocol CalendarDelegate: class {
    func calendarView(_ calendarView: CalendarView, didSelectDate date: Date)
}

protocol CalendarDataSource: class {
    func numberOfEventsForDate(date: Date) -> Int
}
