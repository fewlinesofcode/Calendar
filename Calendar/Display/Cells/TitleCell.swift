//
//  TitleCell.swift
//  Organizer
//
//  Created by Oleksandr Glagoliev on 9/22/17.
//  Copyright © 2017 io.limlab. All rights reserved.
//

import UIKit

class TitleCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = Config.Font.indicatorLabel
        titleLabel.textColor = Config.Color.Label.indicator
    }

}
