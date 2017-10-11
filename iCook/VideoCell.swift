//
//  VideoCell.swift
//  iCook
//
//  Created by Udumala, Mary on 7/11/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit

class VideoCell: baseCell {
    
    var video: Video? {
        didSet {
            name.text = video?.title
            loadThumbnailImage()
            views.text = ""
            channel.text = video?.channelTitle
        }
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray
        return imageView
    }()
    
    let separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        return separator
    }()
    
    let name: UITextField = {
        let nameText = UITextField()
        nameText.font = UIFont.systemFont(ofSize: 16)
        nameText.isUserInteractionEnabled = false
        return nameText
    }()
    
    let views: UITextField = {
        let viewsText = UITextField()
        viewsText.font = UIFont.systemFont(ofSize: 12)
        viewsText.textColor = UIColor.lightGray
        viewsText.isUserInteractionEnabled = false
        return viewsText
    }()
    
    let channel: UITextField = {
        let channelText = UITextField()
        channelText.font = UIFont.systemFont(ofSize: 12)
        channelText.textColor = UIColor.lightGray
        channelText.isUserInteractionEnabled = false
        return channelText
    }()
    
    func loadThumbnailImage() {
        if let thumbnailImageUrl = video?.thumbnailUrl {
            thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailImageUrl)
        }
    }
    
    let options: UIButton = {
        let optionsButton = UIButton()
        optionsButton.setImage(UIImage(named: "MoreButton"), for: .normal)
        return optionsButton
    }()
        
    override func setUpViews() {
        super.setUpViews()
        addSubview(thumbnailImageView)
        addSubview(name)
        addSubview(views)
        addSubview(channel)
        addSubview(options)
        addSubview(separatorView)
        
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-[v1(1)]|", views: thumbnailImageView, separatorView)
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-[v1]-2-[v2]-8-|", views: name, views, channel)
        //addConstraintsWithFormat(format: "H:|-16-[v0]-8-[v1(280)]-16-|", views: thumbnailImageView, name)
        addConstraintsWithFormat(format: "H:|-16-[v0]-8-[v1(260)]-8-[v2(20)]", views: thumbnailImageView, name, options)
        addConstraintsWithFormat(format: "H:|-16-[v0]-8-[v1(280)]-16-|", views: thumbnailImageView, views)
        //addConstraintsWithFormat(format: "H:|-16-[v0]-8-[v1(280)]-16-|", views: thumbnailImageView, options)
        addConstraintsWithFormat(format: "V:|-8-[v0(20)]", views: options)
        addConstraintsWithFormat(format: "H:|-16-[v0]-8-[v1(280)]-16-|", views: thumbnailImageView, channel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
    }
}








