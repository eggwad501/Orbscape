//
//  LevelsVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import UIKit

class LevelsVC: UIGameplayVC {
    
    @IBOutlet weak var iconImageView: UIView!
    
    var startIdentifier = "startIdentifier"
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tapToStartVC = segue.destination as? TapToStartVC
        tapToStartVC!.levelDelegate = self

        if segue.identifier == "easySegue"{
            tapToStartVC!.difficulty = 5
        }
        else if segue.identifier == "mediumSegue"{
            tapToStartVC!.difficulty = 10
        }
        else if segue.identifier == "hardSegue"{
            tapToStartVC!.difficulty = 20
        }
    }
}
