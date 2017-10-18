//
//  ArrowCell.swift
//  Organizer
//
//  Created by Oleksandr Glagoliev on 04/10/2017.
//  Copyright © 2017 io.limlab. All rights reserved.
//

import UIKit

class ArrowCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    enum Direction {
        case left
        case right
        case none
    }
    
    var direction: Direction = .none {
        didSet {
            switch direction {
            case .left:
                imageView.image = UIImage(named: "arrow_l")
            case .right:
                imageView.image = UIImage(named: "arrow_r")
            case .none:
                imageView.image = nil
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let sself = self else { return }
                sself.imageView.alpha = sself.isHighlighted ? 0.5 : 1
            }
        }
    }
}
