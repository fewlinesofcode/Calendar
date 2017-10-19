//
//  CalendarConfig.swift
//  Organizer
//
//  Created by Oleksandr Glagoliev on 04/10/2017.
//  Copyright © 2017 io.limlab. All rights reserved.
//

import UIKit

struct Config {
    struct Main {
        static let firstDayOfWeek = 1
        static let dayOffs: Set<Int> = Set<Int>([3, 4])
    }
    
    struct Metrics {
        static let insets = UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)
        static let headingHeight = CGFloat(35)
        static let headingButtonWidth = CGFloat(40)
        static let monthCellWidth = CGFloat(100)
        static let yearCellWidth = CGFloat(60)
        static let weekdayNameCellHeight = CGFloat(16)
        static let horizontalSpacing = CGFloat(1)
        static let verticalSpacing = CGFloat(1)
        static let dayCellHeight = CGFloat(35)
        
        static func contentHeight() -> CGFloat {
            return insets.top + insets.bottom + 6 * dayCellHeight + 7 * verticalSpacing + weekdayNameCellHeight + headingHeight
        }
    }
    
    struct Color {
        struct Background {
            static let main = UIColor.white
            static let weekdayNameCell = UIColor.white
            static let dayCellNormal = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
            static let dayCellHighlighted = UIColor.black
            static let dayCellBorder = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
            static let dayCellOtherMonth = UIColor.white
        }
    
        struct Label {
            static let indicator = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
            static let weekdayNameRegular = UIColor.black
            static let weekdayNameDayOff = UIColor.red
            
            static let dayCellNormal = UIColor.black
            static let dayCellHighlighted = UIColor.white
            static let dayCellOtherMonth = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0)
        }
    }
    
    struct Font {
        static let indicatorLabel = UIFont(name: "AvenirNext-Medium", size: 18)
        static let weekdayNameLabel = UIFont(name: "AvenirNext-Regular", size: 10)
        static let dayCellLabel = UIFont(name: "ProximaNova-Light", size: 18)
        static let todayLabel = UIFont(name: "AvenirNext-Regular", size: 12)
    }
}
