//
//  TabBarController.swift
//  FuTu
//
//  Created by Administrator1 on 21/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

//import UIKit
//
//class TabBarController: UITabBarController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.view.backgroundColor = UIColor.white
//        
//        let viewController = [HomeViewController(),TransferViewController() ,HomeViewController(),HomeViewController()]
//        let itmeNames = ["富途首页","转账","佣金","个人"]
//        let itmeImages = ["home_toolbar_home1","home_toolbar_transfer1","home_toolbar_money1","home_toolbar_my1"]
//        let itmeImagesSelect = ["home_toolbar_home2","home_toolbar_transfer2","home_toolbar_money2","home_toolbar_my2"]
//        let tabArray = NSMutableArray(capacity: itmeNames.count)
//        //字体
//        let attributes:Dictionary = [NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
//        for i in 0 ... 3 {
//            
//            let itemVC = viewController[i]
//            let item = UITabBarItem(title: itmeNames[i], image: UIImage(named:itmeImages[i]), selectedImage: UIImage(named: itmeImagesSelect[i])?.withRenderingMode(.alwaysOriginal))
//            item.setTitleTextAttributes(attributes, for: .normal)
//            itemVC.tabBarItem = item
//            tabArray.add(itemVC)
//        }
//        //将tab导入RootView
//        self.viewControllers = tabArray as NSArray as? [UIViewController]
//        
//        tlPrint(message: "********* tabBar frame: \(tabBar.frame)")
//        //改变图片和文字颜色
//        //self.tabBar.tintColor = UIColor.colorWithCustom(r: 211, g: 18, b: 0)
//        //只改变文字颜色
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.colorWithCustom(r: 211, g: 18, b: 0)], for: .selected)
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.colorWithCustom(r: 129, g: 129, b: 129)], for: .normal)
//        self.tabBar.barTintColor = UIColor.colorWithCustom(r: 241, g: 241, b: 241)
// 
//        
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = true
//    }
//    
//
//
//
//}
