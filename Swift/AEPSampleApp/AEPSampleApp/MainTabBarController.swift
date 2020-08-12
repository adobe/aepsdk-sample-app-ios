/*
Copyright 2020 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: - Work on getting images for the extensions if possible
        let griffonVC = GriffonViewController(rootView: GriffonView())
        griffonVC.tabBarItem = UITabBarItem(title: "Griffon", image: nil, selectedImage: nil)
        
        let analyticsVC = AnalyticsViewController(rootView: AnalyticsView())
        analyticsVC.tabBarItem = UITabBarItem(title: "Analytics", image: nil, selectedImage: nil)
        
        let placesVC = PlacesViewController(rootView: PlacesView())
        placesVC.tabBarItem = UITabBarItem(title: "Places", image: nil, selectedImage: nil)
        
        let mediaVC = MediaViewController()
        mediaVC.tabBarItem = UITabBarItem(title: "Media", image: nil, selectedImage: nil)
        
        let messagesVC = MessagesViewController(rootView: MessagesView())
        messagesVC.tabBarItem = UITabBarItem(title: "Messages", image: nil, selectedImage: nil)
        
        viewControllers = [griffonVC, analyticsVC, placesVC, mediaVC, messagesVC]
    }
    
    


}



