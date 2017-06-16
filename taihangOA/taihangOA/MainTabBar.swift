//
//  MainTabBar.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import Hero

var TabIndex = 0


class MainTabBar: UITabBarController,UITabBarControllerDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
                return true
        
    }

    
    
    deinit {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}
