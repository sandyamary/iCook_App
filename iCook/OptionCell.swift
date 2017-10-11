//
//  OptionCell.swift
//  iCook
//
//  Created by Udumala, Mary on 7/15/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation
import UIKit

class OptionsCell: baseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.lightGray : UIColor.white
        }
    }
    
    var options: Options? {
        didSet {
            nameLabel.text = options?.optionName
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.red
        label.font = UIFont(name: "Arial", size: 22)
        return label
    }()
    
    let separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        return separator
    }()
    
    override func setUpViews() {
        super.setUpViews()
        addSubview(nameLabel)
        addSubview(separatorView)
        
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: nameLabel)
        //addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-[v1(1)]|", views: nameLabel, separatorView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        
    }
    
    
    
    
    
    

}
