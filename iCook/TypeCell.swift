//
//  TypeCell.swift
//  iCook
//
//  Created by Udumala, Mary on 6/29/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit

class baseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
    }
    
}

class TypeCell: baseCell {
    
    var video: Video? {
        didSet {
            typeLabel.text = video?.title
        }
    }
    
    var category: Category? {
        didSet {
            typeLabel.text = category?.title
            if let thumbnailImageName = category?.thumbnailImageName {
                thumbnailImageView.image = UIImage(named: thumbnailImageName)
            }
        }
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.cyan
        return imageView
    }()
    
    let separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        return separator
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    
    override func setUpViews() {
        super.setUpViews()
        addSubview(thumbnailImageView)
        addSubview(typeLabel)
        addSubview(separatorView)
        
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-16-[v2(1)]|", views: thumbnailImageView, typeLabel, separatorView)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: typeLabel)
    }
}


extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat:format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
        
    }
    
}









