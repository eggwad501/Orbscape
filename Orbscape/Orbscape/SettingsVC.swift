//
//  SettingsVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import UIKit

class SettingsVC: UIGameplayVC {

    @IBOutlet weak var soundSlider: UISlider!
    
    @IBOutlet weak var musicSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundSlider.value = soundVolume
        musicSlider.value = musicVolume
    }

    @IBAction func changedSoundSlider(_ sender: Any) {
        soundVolume = soundSlider.value
    }
    
    
    @IBAction func changedMusicSlider(_ sender: Any) {
        musicVolume = musicSlider.value
    }
}
