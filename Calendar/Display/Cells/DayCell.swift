//
//  DayNameCell.swift
//  Organizer
//
//  Created by Aleksandr Glagoliev on 3/29/16.
//  Copyright © 2016 io.limlab. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
	@IBOutlet weak var titleLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
        
        titleLabel.font = Config.Font.dayCellLabel
	}
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let sself = self else { return }
                if sself.isSelected {
                    sself.backgroundColor = Config.Color.Background.dayCellHighlighted
                    sself.titleLabel.textColor = Config.Color.Label.dayCellHighlighted
                } else {
                    sself.backgroundColor = Config.Color.Background.dayCellNormal
                    sself.titleLabel.textColor = Config.Color.Label.dayCellNormal
                }
            }
        }
    }
}
