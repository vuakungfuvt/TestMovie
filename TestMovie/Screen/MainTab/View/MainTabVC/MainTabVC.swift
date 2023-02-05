//
//  MainTabVC.swift
//  TestMovie
//
//  Created by Tung Phan on 02/02/2023.
//

import UIKit

class MainTabVC: UITabBarController , XibViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupTabbarView() {
        tabBar.barTintColor = R.color.appTintColor()
        tabBar.isTranslucent = false
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 3
        tabBar.layer.shadowColor =  UIColor.white.cgColor
        tabBar.layer.shadowOpacity = 0.3
    }
    
    func setupView() {
        setupTabbarView()
        let vc1 = HomeVC.create()
        let navNV1 = UINavigationController(rootViewController: vc1)
        vc1.setTabbarItem("Home", activeIcon: R.image.icTabHomeActive.name, deactiveIcon: R.image.icTabHome.name)
        
        let vc2 = FavoriteMovieVC.create()
        let navNV2 = UINavigationController(rootViewController: vc2)
        vc2.setTabbarItem("Favorite", activeIcon: R.image.icTabPersonalActive.name, deactiveIcon: R.image.icTabPersonal.name)
        
        self.viewControllers = [navNV1, navNV2]
        self.selectedIndex = 0
    }
}
