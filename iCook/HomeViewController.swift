//
//  HomeViewController.swift
//  iCook
//
//  Created by Udumala, Mary on 6/22/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController {
    
    
    var categories: [Category] = {
        
        var kidsMeals = Category()
        kidsMeals.thumbnailImageName = "KidsRecipiesThumbnail"
        kidsMeals.title = "Kids Healthy Recipies"
        
        var ketoRecipies = Category()
        ketoRecipies.thumbnailImageName = "KetoRecipiesThumbnail"
        ketoRecipies.title = "Keto Recipies"
        
        var LunchBoxRecipies = Category()
        LunchBoxRecipies.thumbnailImageName = "LunchBoxRecipiesThumbnail"
        LunchBoxRecipies.title = "Lunch Box Recipies"
        
        var SaladRecipies = Category()
        SaladRecipies.thumbnailImageName = "SaladRecipiesThumbnail"
        SaladRecipies.title = "Salad Recipies"
        
        var KetoDessertRecipies = Category()
        KetoDessertRecipies.thumbnailImageName = "KetoDessertRecipiesThumbnail"
        KetoDessertRecipies.title = "Keto Desserts"
        
        return [ketoRecipies, SaladRecipies, KetoDessertRecipies, kidsMeals, LunchBoxRecipies]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "iCook"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(TypeCell.self, forCellWithReuseIdentifier: "typeCell")
        
        setUpNavBarItem()
        
    }
    
    func setUpNavBarItem() {
        let menuItem = UIImage(named: "Menu")?.withRenderingMode(.alwaysOriginal)
        let menuBarItem = UIBarButtonItem(image: menuItem, style: .plain, target: self, action: #selector(slideMenu))
        navigationItem.leftBarButtonItem = menuBarItem
        
        let logOutItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        logOutItem.tintColor = .black
        navigationItem.rightBarButtonItem = logOutItem
        
    }
    
    
    func logOut() -> Void {
        icookAddFBID(FBID:"")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as! TypeCell
        cell.category = categories[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ListViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.navigationItem.title = categories[indexPath.item].title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var menuLauncher: MenuLauncher  = {
        let launcher = MenuLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    func slideMenu() {
        menuLauncher.showMenu()
    }
    
    func showControllerForMenuItems(menuItem: Menu) {
        if menuItem.itemName == "FAVORITES" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
            vc.view.backgroundColor = UIColor.white
            vc.navigationItem.title = menuItem.itemName
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            self.navigationController?.pushViewController(vc, animated: true)
        }else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            vc.view.backgroundColor = UIColor.white
            vc.navigationItem.title = menuItem.itemName
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width: view.frame.width, height: height + 16 + 68)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

