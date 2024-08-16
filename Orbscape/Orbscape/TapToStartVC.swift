//
//  TapToStartVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/12/24.
//

import UIKit

class TapToStartVC: UIGameplayVC {

    @IBOutlet weak var iconImageView: UIView!
    var toGameIdentifier = "toGameIdentifier"
    var levelDelegate: UIGameplayVC!


    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = imageView(view: iconImageView, image: currentSkin.skin)
        iconImageView.backgroundColor = UIColor.clear
        iconImageView.addSubview(image)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toGameIdentifier,
           let destination = segue.destination as? GameViewController {
            destination.tapStartDelegate = self
            destination.levelDelegate = levelDelegate
        }


    }
}
