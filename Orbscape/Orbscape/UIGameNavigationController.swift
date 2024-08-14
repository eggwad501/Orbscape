//
//  CustomNavigationBar.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/6/24.
//

import Foundation
import UIKit


class UIGameNavigationController: UINavigationController {
    // load in custom navigation bar
    override func viewDidLoad() {
        super.viewDidLoad()
        self.additionalSafeAreaInsets.top = 60
        let backButtonImage = UIImage(named: "backButton")
        self.navigationBar.backIndicatorImage = backButtonImage
        self.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        
        self.navigationBar.barTintColor = UIColor.clear
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white, // Set the title color
            .font: UIFont(name: "galvji", size: 37)
        ]
        
        // Apply this appearance when the scroll view's content reaches the edge
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.standardAppearance = appearance
    }
    
    func removeViewController() {
        self.viewControllers.remove(at: 1)
    }
    
    
}

