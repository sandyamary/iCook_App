//
//  OptionsLauncher.swift
//  iCook
//
//  Created by Udumala, Mary on 7/15/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation
import UIKit

class Options {
    
    var optionName: String
    
    init(name: String) {
        self.optionName = name
    }
}

class OptionsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OptionsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 60
    var optionItems = [Options]()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.layer.cornerRadius = 10
        cv.layer.borderWidth = 1
        cv.layer.borderColor = UIColor.clear.cgColor
        cv.layer.masksToBounds = true
        return cv
    }()
    
    let dimView = UIView()
    var listViewController: ListViewController?
    var favouritesViewController: FavoritesViewController?
    var searchViewController: SearchViewController?
    var controllerType = NSInteger()
    func showOptions(fav:Bool,type:NSInteger) {
        
        if let window = UIApplication.shared.keyWindow {
            controllerType = type
            if fav == false {
                optionItems = [Options(name: "Add to Favorites"), Options(name: "Share"), Options(name: "Cancel")]
            }else
            {
                optionItems = [Options(name: "Remove from Favorites"), Options(name: "Share"), Options(name: "Cancel")]
            }
            collectionView.reloadData()
            self.dimView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(dimView)
            window.addSubview(collectionView)
            let height: CGFloat = (CGFloat(optionItems.count) * cellHeight) + 40
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 20, y: window.frame.height, width: window.frame.width - 40, height: height)
            
            dimView.frame = window.frame
            dimView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.dimView.alpha = 1
                self.collectionView.frame = CGRect(x: 20, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.dimView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 20, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        })
    }
    
    
    
}

extension OptionsLauncher {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OptionsCell
        let optionItem = optionItems[indexPath.item]
        cell.options = optionItem
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.dimView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 20, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            
        }) { (completed: Bool) in
            let optionItem = self.optionItems[indexPath.item]
            if optionItem.optionName == "Add to Favorites" || optionItem.optionName == "Remove from Favorites" {
                if self.controllerType == 1
                {
                    self.listViewController?.showFavotitesAlert()
                }else
                if self.controllerType == 2
                {
                    self.searchViewController?.showFavotitesAlert()
                }else
                {
                    self.favouritesViewController?.showFavotitesAlert()
                }
                
            } else
            if optionItem.optionName != "CANCEL" && optionItem.optionName == "Share"  {
                if self.controllerType == 1
                {
                    self.listViewController?.showShareOptions()
                }else
                    if self.controllerType == 2
                    {
                        self.searchViewController?.showShareOptions()
                    }else
                    {
                        self.favouritesViewController?.showShareOptions()
                }
                
            }
            
        }
        
    }
    
}






