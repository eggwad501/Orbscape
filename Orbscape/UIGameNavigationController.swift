//
//  CustomNavigationBar.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/6/24.
//

import Foundation
import UIKit

// custom navigation bar for the app
class UIGameNavigationController: UINavigationController {
    // load in custom navigation bar
    override func viewDidLoad() {
        super.viewDidLoad()
        self.additionalSafeAreaInsets.top = 60
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "galvji", size: 37)!
        ]
        
        // added custom image for back button
        let backButtonImage = UIImage(named: "backButton")
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        // Apply this appearance when the scroll view's content reaches the edge
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.standardAppearance = appearance
        
    }
}

