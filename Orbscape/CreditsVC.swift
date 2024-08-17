//
//  CreditsVC.swift
//  Orbscape
//
// Project: Orbscape
// EID: nmt736, rw28469, ss79767, nae596
// Course: CS371L

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
