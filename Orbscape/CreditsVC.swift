//
//  CreditsVC.swift
//  Orbscape
//
//  Created by Nick Ensey on 8/16/24.
//

import UIKit

class CreditsVC: UIGameplayVC {
    
    var settingDelegate: UIGameplayVC!

    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // prevent pause vc from appearing
    override func viewWillAppear(_ animated: Bool) {
        if let sceneDelegate = settingDelegate as? settingChanger {
            sceneDelegate.changeCredit(boolean: false)
        }
    }
    
    

}
