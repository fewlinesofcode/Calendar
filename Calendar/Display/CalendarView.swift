//
//  CalendarView.swift
//  Organizer
//
//  Created by Oleksandr Glagoliev on 27/11/2016.
//  Copyright © 2016 io.limlab. All rights reserved.
//

import UIKit

class CalendarView: UIView {
    struct ReuseId {
        struct Cell {
            static let arrow = "ArrowCellId"
            static let day = "DayCellId"
            static let dayName = "DayNameCellId"
            static let title = "TitleCellId"
        }
        struct SupplementaryView {
            static let plash = "BackingViewIdReuseId"
        }
    }
    
    struct SupplementaryViewKind {
        static let plash = "PlashSupplementaryViewKind"
    }
    
    @IBOutlet var view: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    fileprivate let data = CalendarData()
    
    private func configureUI() {
        collectionView.backgroundColor = Config.Color.Background.main
    }
    
    private func registerNibs() {
        let arrowCellNib = UINib(nibName: "ArrowCell", bundle:nil)
        collectionView.register(arrowCellNib, forCellWithReuseIdentifier: ReuseId.Cell.arrow)
        
        let dayCellNib = UINib(nibName: "DayCell", bundle:nil)
        collectionView.register(dayCellNib, forCellWithReuseIdentifier: ReuseId.Cell.day)
        
        let dayNameCellNib = UINib(nibName: "DayNameCell", bundle:nil)
        collectionView.register(dayNameCellNib, forCellWithReuseIdentifier: ReuseId.Cell.dayName)
        
        let titleCellNib = UINib(nibName: "TitleCell", bundle:nil)
        collectionView.register(titleCellNib, forCellWithReuseIdentifier: ReuseId.Cell.title)
        
        let backingViewNib = UINib(nibName: "BackingView", bundle:nil)
        collectionView.register(backingViewNib, forSupplementaryViewOfKind: SupplementaryViewKind.plash, withReuseIdentifier: ReuseId.SupplementaryView.plash)
    }
    
    private func setupReferences() {
        collectionView.dataSource = self
        collectionView.delegate = self
        (collectionView.collectionViewLayout as! CalendarLayout).dataSource = self
    }
    
    private func update() {
        collectionView.reloadItems(at: data.indicatorIndices.map {
            IndexPath(row: $0, section: data.headingSection)
        })
        collectionView.reloadSections([data.daysSection])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?.first as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        
        configureUI()
        registerNibs()
        setupReferences()
        
        addSubview(view)
        let views: [String: Any] = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .alignAllCenterX, metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: .alignAllCenterY, metrics: nil, views: views))
        
        data.showToday()
        collectionView.reloadData()
    }

}

// MARK: UICollectionViewDataSource
extension CalendarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.sections[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let content = data.sections[indexPath.section][indexPath.row]
        
        switch content {
        case .prevMonthButton:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseId.Cell.arrow, for: indexPath) as! ArrowCell
            cell.direction = .left
            return cell
        case .monthIndicator(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseId.Cell.title, for: indexPath) as! TitleCell
            cell.titleLabel.text = data
            return cell
        case .nextMonthButton:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseId.Cell.arrow, for: indexPath) as! ArrowCell
            cell.direction = .right
            return cell
        case .prevYearButton:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseId.Cell.arrow, for: indexPath) as! ArrowCell
            cell.direction = .left
            return cell
        case .yearIndicator(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseId.Cell.title, for: indexPath) as! TitleCell
            cell.titleLabel.text = data
            return cell
        case .nextYearButton:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseId.Cell.arrow, for: indexPath) as! ArrowCell
            cell.direction = .right
            return cell
        case .weekday(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseId.Cell.dayName, for: indexPath) as! DayNameCell
            cell.titleLabel.text = data.title.uppercased()
            if data.isDayOff {
                cell.titleLabel.textColor = Config.Color.Label.weekdayNameDayOff
            } else {
                cell.titleLabel.textColor = Config.Color.Label.weekdayNameRegular
            }
            return cell
        case .day(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseId.Cell.day, for: indexPath) as! DayCell
            cell.titleLabel.text = data.title
            if data.isToday {
                cell.layer.borderWidth = 1
                cell.layer.borderColor = Config.Color.Background.dayCellBorder.cgColor
            } else {
                layer.borderWidth = 0
            }
            if data.belongsToShownPeriod {
                cell.titleLabel.textColor = Config.Color.Label.dayCellNormal
                cell.backgroundColor = Config.Color.Background.dayCellNormal
            } else {
                cell.titleLabel.textColor = Config.Color.Label.dayCellOtherMonth
                cell.backgroundColor = Config.Color.Background.dayCellOtherMonth
            }
            return cell
        }
    }
    
}


// MARK: UICollectionViewDelegate
extension CalendarView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = data.sections[indexPath.section][indexPath.row]
        
        switch content {
        case .prevMonthButton:
            data.switchToPrevMonth()
            update()
        case .nextMonthButton:
            data.switchToNextMonth()
            update()
        case .prevYearButton:
            data.switchToPrevYear()
            update()
        case .nextYearButton:
            data.switchToNextYear()
            update()
        case .day:
            print("Info-> \(indexPath)")
        default: break
        }
    }
    
}

// MARK: CalendarLayoutDataSource
extension CalendarView: CalendarLayoutDataSource {
    var numberOfColumns: Int {
        return data.numberOfDaysInWeek
    }
    
    func contentTypeForCell(at indexPath: IndexPath) -> CalendarContent? {
        return data.sections[indexPath.section][indexPath.row]
    }    
}
