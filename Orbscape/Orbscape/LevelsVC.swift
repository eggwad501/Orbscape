//
//  LevelsVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import UIKit

class LevelsVC: UIGameplayVC {
    
    @IBOutlet weak var iconImageView: UIView!
    
    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = imageView(view: iconImageView, image: currentSkin.skin)
        iconImageView.backgroundColor = UIColor.clear
        iconImageView.addSubview(image)
    }
    
    // play ball animation
    override func viewWillAppear(_ animated: Bool) {
        ballAnimation(view: self.iconImageView)
    }
}
