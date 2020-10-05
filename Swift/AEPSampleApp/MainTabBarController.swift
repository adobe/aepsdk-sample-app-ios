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

         let experiencePlatformVC = ExperiencePlatformViewController(rootView: ExperiencePlatformView())
         experiencePlatformVC.tabBarItem = UITabBarItem(title: "AEP", image: nil, selectedImage: nil)

        let griffonVC = GriffonViewController(rootView: GriffonView())
        griffonVC.tabBarItem = UITabBarItem(title: "Griffon", image: nil, selectedImage: nil)
        viewControllers = [coreVC, experiencePlatformVC, griffonVC]

    }
}



