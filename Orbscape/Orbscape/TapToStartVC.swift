//
//  TapToStartVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/12/24.
//

import UIKit

class TapToStartVC: UIGameplayVC {

    var difficulty: Int!
    var delegate: UIGameplayVC?
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
        let gameVC = segue.destination as? GameViewController
        if segue.identifier == "startSegue"{
            print("TTSVC: \(difficulty!)")
            gameVC!.levelDelegate = levelDelegate
            gameVC!.tapStartDelegate = self
            gameVC!.difficulty = difficulty!
        }
    }
}
