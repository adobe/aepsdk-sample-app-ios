/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
import AdSupport

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coreVC = CoreViewController(rootView: CoreView())
        coreVC.tabBarItem = UITabBarItem(title: "Core", image: nil, selectedImage: nil)
        
        let assuranceVC = AssuranceViewController(rootView: AssuranceView())
        assuranceVC.tabBarItem = UITabBarItem(title: "Assurance", image: nil, selectedImage: nil)
        viewControllers = [coreVC, assuranceVC]
        
    }
}



