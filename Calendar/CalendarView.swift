//
//  CalendarView.swift
//  Organizer
//
//  Created by Oleksandr Glagoliev on 27/11/2016.
//  Copyright © 2016 io.limlab. All rights reserved.
//

import UIKit

class CalendarView: UIView {
    fileprivate struct ReuseId {
        static let day = "DayCellId"
        static let dayName = "DayNameCellId"
        static let title = "TitleCellId"
    }
    
    fileprivate struct SupplementaryViewKind {
    }
    
    fileprivate enum Sections: Int {
        case heading
        case daysGrid
        
        static let values = [.heading, daysGrid]
    }
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var numItems: Int = 30 * 7
    
    private func registerNibs() {
        let dayCellNib = UINib(nibName: "DayCell", bundle:nil)
        collectionView.register(dayCellNib, forCellWithReuseIdentifier: ReuseId.day)
        
        let dayNameCellNib = UINib(nibName: "DayNameCell", bundle:nil)
        collectionView.register(dayNameCellNib, forCellWithReuseIdentifier: ReuseId.dayName)
        
        let titleCellNib = UINib(nibName: "TitleCell", bundle:nil)
        collectionView.register(titleCellNib, forCellWithReuseIdentifier: ReuseId.title)
    }
    
    fileprivate func insertTop(_ sender: Any? = nil) {
        (collectionView.collectionViewLayout as! CalendarLayout).isInsertingCellsToTop = true
        (collectionView.collectionViewLayout as! CalendarLayout).contentSizeWhenInsertingToTop = collectionView.collectionViewLayout.collectionViewContentSize
        
        let itemsToInsert = 7//Int(arc4random() % 10)
        numItems = itemsToInsert + numItems
        UIView.performWithoutAnimation {
            self.collectionView.insertItems(at: (0..<itemsToInsert).map { IndexPath(item: $0, section: 0) })
        }
    }
    
    fileprivate func insertBottom() {
        let itemsToInsert = 7//Int(arc4random() % 10)
        let itemsBeforeUpdate = numItems
        numItems = itemsToInsert + itemsBeforeUpdate
        UIView.performWithoutAnimation {
            self.collectionView.insertItems(at: (itemsBeforeUpdate..<numItems).map { IndexPath(item: $0, section: 0) })
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?.first as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        
        registerNibs()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(view)
        let views: [String : Any] = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .alignAllCenterX, metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: .alignAllCenterY, metrics: nil, views: views))
        
        
    }

}

extension CalendarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Sections.heading.rawValue == section {
            return 8
        } else if Sections.daysGrid.rawValue == section  {
            return numItems
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if Sections.heading.rawValue == indexPath.section {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseId.title, for: indexPath) as! TitleCell
            return cell
        } else if Sections.daysGrid.rawValue == indexPath.section  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseId.day, for: indexPath) as! DayCell
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Sections.values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
}

extension CalendarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        print("I-> \(indexPath)")
    }
    
}


extension CalendarView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y > collectionView.collectionViewLayout.collectionViewContentSize.height - bounds.height {
            insertBottom()
        }
        if scrollView.contentOffset.y < 0 {
            insertTop()
        }
    }
}
