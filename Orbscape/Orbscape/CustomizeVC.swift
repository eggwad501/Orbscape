//
//  CustomizeVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import UIKit

enum CustomizeTypes {
  case skins, soundEffects, themes
}

class CustomizeVC: UIGameplayVC {
    
    var skinsIdentifier = "skinsIdentifier"
    var soundEffectsIdentifier = "soundEffectsIdentifier"
    var themesIdentifier = "themesIdentifier"

    @IBOutlet weak var skinDisplayView: UIView!
    
    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // display ball
    override func viewWillAppear(_ animated: Bool) {
        let image = imageView(view: skinDisplayView, image: currentSkin.skin)
        skinDisplayView.backgroundColor = UIColor.clear
        skinDisplayView.addSubview(image)
        ballAnimation(view: self.skinDisplayView)
    }
    
    // pass information on what type of customization
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case skinsIdentifier:
            let destination = segue.destination as? ThemesVC
            destination?.types = CustomizeTypes.skins
            
        case soundEffectsIdentifier:
            let destination = segue.destination as? ThemesVC
            destination?.types = CustomizeTypes.soundEffects

        case themesIdentifier:
            let destination = segue.destination as? ThemesVC
            destination?.types = CustomizeTypes.themes
        
        default:
            break
        }
    }
}
