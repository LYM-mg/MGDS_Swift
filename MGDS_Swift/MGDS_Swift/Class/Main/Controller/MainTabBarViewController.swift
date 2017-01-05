//
//  MainTabBarViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.初始化所有的子控制器
        setUpChildViewController()
    }
}

// MARK: - setUpChildViewController
extension MainTabBarViewController {
    fileprivate func setUpChildViewController() {
        
        let homeVC = HomeViewController()
        setUpNavRootViewControllers(vc: homeVC, title: "首页", image: "home", selImage: "")
        
        let discoverVC = DiscoverViewController()
        setUpNavRootViewControllers(vc: discoverVC, title: "发现", image: "find", selImage: "")
        
        let mineVC = MineViewController()
        setUpNavRootViewControllers(vc: mineVC, title: "我的", image: "user", selImage: "")
    }
    
    // 初始化一个到导航控制器的控制器
    fileprivate func setUpNavRootViewControllers(vc: UIViewController, title:String, image: String, selImage: String) {
        vc.title = title
        vc.tabBarItem.image = UIImage(named: image)
//        vc.tabBarItem.selectedImage = UIImage.mg_RenderModeOriginal(imageName: selImage)
        
        self.addChildViewController(UINavigationController(rootViewController: vc))
    }
}
