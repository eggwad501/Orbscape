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
    var localStore: PurchasableItems!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundSlider.value = soundVolume
        musicSlider.value = musicVolume
        localStore = PurchasableItems()
    }

    @IBAction func changedSoundSlider(_ sender: Any) {
        soundVolume = soundSlider.value
        localStore.retrieveItem(identifier: "Insets")[1].setValue(soundSlider.value, forKey: "soundVal")
        localStore.saveContext()
    }
    
    
    @IBAction func changedMusicSlider(_ sender: Any) {
        musicVolume = musicSlider.value
        BackgroundMusic.shared.updateVolume()
        localStore.retrieveItem(identifier: "Insets")[1].setValue(musicSlider.value, forKey: "musicVal")
        localStore.saveContext()
    }
}
