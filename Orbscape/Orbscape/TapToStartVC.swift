//
//  TapToStartVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/12/24.
//

import UIKit

class TapToStartVC: UIGameplayVC {

    @IBOutlet weak var iconImageView: UIView!
    
    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = imageView(view: iconImageView, image: currentSkin.skin)
        iconImageView.backgroundColor = UIColor.clear
        iconImageView.addSubview(image)
    }
}
