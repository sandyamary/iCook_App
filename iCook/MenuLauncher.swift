//
//  MenuLauncher.swift
//  iCook
//
//  Created by Udumala, Mary on 7/11/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation
import UIKit

class Menu {
    var itemName: String
    var imageIcon: String
    
    init(item: String, imageIcon: String) {
        self.itemName = item
        self.imageIcon = imageIcon
    }
}

class MenuLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    let dimView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        layout.sectionInset = UIEdgeInsets(top: 100.0, left: 0.0, bottom: 0.0, right: 0.0)
        return cv
    }()
    
    let cellId = "cellId"
    
    let menuItems: [Menu] = {
        return [Menu(item: "HOME", imageIcon: "HomeIcon"), Menu(item: "FAVORITES", imageIcon: "FavIcon"), Menu(item: "SEARCH", imageIcon: "SearchIcon"), Menu(item: "CANCEL", imageIcon: "CancelIcon")]
    }()
    
    var homeController: HomeViewController?
    
    func showMenu() {
        
        if let window = UIApplication.shared.keyWindow {
            self.dimView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(dimView)
            window.addSubview(collectionView)
            collectionView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            
            dimView.frame = window.frame
            dimView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.dimView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: 280, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.dimView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            }
        })
    }
    
}

extension MenuLauncher {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        let menuItem = menuItems[indexPath.item]
        cell.menu = menuItem
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            
            self.dimView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            }
            
        }) { (completed: Bool) in
            let menuItem = self.menuItems[indexPath.item]
            if menuItem.itemName != "CANCEL" && menuItem.itemName != "HOME" {
                self.homeController?.showControllerForMenuItems(menuItem: menuItem)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 50)
    }
    
}
