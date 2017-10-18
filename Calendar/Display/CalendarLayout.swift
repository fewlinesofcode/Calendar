//
//  CalendarLayout.swift
//  OnoffVoIP
//
//  Created by Oleksandr Glagoliev on 10/10/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import UIKit

class CalendarLayout: UICollectionViewLayout {
    weak var dataSource: CalendarLayoutDataSource?
    
    fileprivate var attributesCache = [IndexPath: UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        attributesCache = [IndexPath: UICollectionViewLayoutAttributes]()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard  let collectionView = self.collectionView else {
            return nil
        }
        
        var updatedAttributes = [UICollectionViewLayoutAttributes]()
        let sectionsCount = collectionView.numberOfSections
        
        for section in 0..<sectionsCount {
            let rowsCount = collectionView.numberOfItems(inSection: section)
            
            for row in 0..<rowsCount {
                let indexPath = IndexPath(row: row, section: section)
                
                if let itemAttrs = layoutAttributesForItem(at: indexPath)  {
                    if itemAttrs.frame.intersects(rect) {
                        updatedAttributes.append(itemAttrs)
                    }
                }
            }
        }
        
        return updatedAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collView = collectionView else {
            return false
        }
        let oldBounds = collView.bounds
        return oldBounds != newBounds
    }
    
    // Helpers
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attrs = attributesCache[indexPath] {
            return attrs
        }
        
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        if let content = dataSource?.contentTypeForCell(at: indexPath) {
            switch content {
            case .prevMonthButton:
                layoutAttributes.frame = prevMonthButtonFrame()
                layoutAttributes.zIndex = Int.max
            case .monthIndicator:
                layoutAttributes.frame = monthIndicatorFrame()
                layoutAttributes.zIndex = Int.max
            case .nextMonthButton:
                layoutAttributes.frame = nextMonthButtonFrame()
                layoutAttributes.zIndex = Int.max
            case .prevYearButton:
                layoutAttributes.frame = prevYearButtonFrame()
                layoutAttributes.zIndex = Int.max
            case .yearIndicator:
                layoutAttributes.frame = yearIndicatorFrame()
                layoutAttributes.zIndex = Int.max
            case .nextYearButton:
                layoutAttributes.frame = nextYearButtonFrame()
                layoutAttributes.zIndex = Int.max
            case .weekday:
                layoutAttributes.frame = frameForWeekdayNameCell(at: indexPath.row)
                layoutAttributes.zIndex = Int.max
            case .day:
                layoutAttributes.frame = frameForDayCell(at: indexPath)
            }
        }
        attributesCache[indexPath] = layoutAttributes
        return layoutAttributes
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return CGSize.zero
        }
        let size = CGSize(width: collectionView.bounds.size.width, height: 256)
        return size
    }
}

extension CalendarLayout {
    fileprivate func prevMonthButtonFrame() -> CGRect {
        let x = Config.Metrics.insets.left
        let y = Config.Metrics.insets.top
        let w = Config.Metrics.headingButtonWidth
        let h = Config.Metrics.headingHeight
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    fileprivate func monthIndicatorFrame() -> CGRect {
        let x = prevMonthButtonFrame().maxX + Config.Metrics.horizontalSpacing
        let y = Config.Metrics.insets.top
        let w = Config.Metrics.monthCellWidth
        let h = Config.Metrics.headingHeight
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    fileprivate func nextMonthButtonFrame() -> CGRect {
        let x = monthIndicatorFrame().maxX + Config.Metrics.horizontalSpacing
        let y = Config.Metrics.insets.top
        let w = Config.Metrics.headingButtonWidth
        let h = Config.Metrics.headingHeight
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    fileprivate func prevYearButtonFrame() -> CGRect {
        let x = yearIndicatorFrame().minX - Config.Metrics.horizontalSpacing - Config.Metrics.headingButtonWidth
        let y = Config.Metrics.insets.top
        let w = Config.Metrics.headingButtonWidth
        let h = Config.Metrics.headingHeight
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    fileprivate func yearIndicatorFrame() -> CGRect {
        let x = nextYearButtonFrame().minX - Config.Metrics.horizontalSpacing - Config.Metrics.yearCellWidth
        let y = Config.Metrics.insets.top
        let w = Config.Metrics.yearCellWidth
        let h = Config.Metrics.headingHeight
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    fileprivate func nextYearButtonFrame() -> CGRect {
        let x = collectionViewContentSize.width - Config.Metrics.headingButtonWidth - Config.Metrics.insets.right
        let y = Config.Metrics.insets.top
        let w = Config.Metrics.headingButtonWidth
        let h = Config.Metrics.headingHeight
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    fileprivate func frameForWeekdayNameCell(at index: Int) -> CGRect {
        let x = xPositionForItem(col: index)
        let y = Config.Metrics.insets.top + Config.Metrics.headingHeight + Config.Metrics.verticalSpacing
        let w = colWidth(numCols: dataSource?.numberOfColumns ?? 0)
        let h = Config.Metrics.weekdayNameCellHeight
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    fileprivate func frameForDayCell(at indexPath: IndexPath) -> CGRect {
        guard let delegate = self.dataSource else { return CGRect.zero }
        
        let x = xPositionForItem(col: indexPath.row % delegate.numberOfColumns)
        let y = yPositionForItem(row: indexPath.row / delegate.numberOfColumns)
        let w = colWidth(numCols: delegate.numberOfColumns)
        let h = Config.Metrics.dayCellHeight
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    private func xPositionForItem(col: Int) -> CGFloat {
        return Config.Metrics.insets.right
                + (colWidth(numCols: dataSource?.numberOfColumns ?? 0 )
                + Config.Metrics.horizontalSpacing) * CGFloat(col)
    }
    
    private func yPositionForItem(row: Int) -> CGFloat {
        return Config.Metrics.insets.top
                + Config.Metrics.headingHeight
                + Config.Metrics.verticalSpacing
                + Config.Metrics.weekdayNameCellHeight
                + Config.Metrics.verticalSpacing
                + (Config.Metrics.dayCellHeight + Config.Metrics.verticalSpacing) * CGFloat(row)
    }
    
    private func colWidth(numCols: Int) -> CGFloat {
        let usefulWidth = collectionViewContentSize.width
            - Config.Metrics.insets.right
            - Config.Metrics.insets.left
            - CGFloat(numCols - 1) * Config.Metrics.horizontalSpacing
        return usefulWidth / CGFloat(numCols)
    }
}

