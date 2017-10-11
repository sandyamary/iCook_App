//
//  MenuCell.swift
//  iCook
//
//  Created by Udumala, Mary on 7/12/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation
import UIKit

class MenuCell: baseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
        }
    }
    
    var menu: Menu? {
        didSet {
            nameLabel.text = menu?.itemName
            if let icon = menu?.imageIcon {
                iconImageView.image = UIImage(named: icon)
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Home"
        return label
    }()
    
    let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "FavIcon")
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
    override func setUpViews() {
        super.setUpViews()
        addSubview(iconImageView)
        addSubview(nameLabel)

        addConstraintsWithFormat(format: "H:|-8-[v0(20)]-12-[v1]|", views: iconImageView, nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(20)]", views: iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
    
}
