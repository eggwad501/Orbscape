//
//  LevelsVC.swift
//  Orbscape
//
// Project: Orbscape
// EID: nmt736, rw28469, ss79767, nae596
// Course: CS371L

import UIKit

class LevelsVC: UIGameplayVC {
    
    @IBOutlet weak var iconImageView: UIView!
    
    var startIdentifier = "startIdentifier"
    var homeDelegete: UIGameplayVC!
    
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
    
    // sends over necessary data to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tapToStartVC = segue.destination as? TapToStartVC
        tapToStartVC!.levelDelegate = self
        tapToStartVC!.homeDelegete = homeDelegete

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
