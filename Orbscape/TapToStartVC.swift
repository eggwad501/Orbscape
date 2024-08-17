//
//  TapToStartVC.swift
//  Orbscape
//
// Project: Orbscape
// EID: nmt736, rw28469, ss79767, nae596
// Course: CS371L

import UIKit

class TapToStartVC: UIGameplayVC {

    var difficulty: Int!
    var delegate: UIGameplayVC?
    @IBOutlet weak var iconImageView: UIView!
    var toGameIdentifier = "toGameIdentifier"
    var levelDelegate: UIGameplayVC!
    var homeDelegete: UIGameplayVC!

    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = imageView(view: iconImageView, image: currentSkin.skin)
        iconImageView.backgroundColor = UIColor.clear
        iconImageView.addSubview(image)
    }
    
    // prepares segue to send over necessary data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameVC = segue.destination as? GameViewController
        if segue.identifier == "startSegue"{
            print("TTSVC: \(difficulty!)")
            gameVC!.levelDelegate = levelDelegate
            gameVC!.homeDelegete = homeDelegete
            gameVC!.tapStartDelegate = self
            gameVC!.difficulty = difficulty!
        }
    }
}
