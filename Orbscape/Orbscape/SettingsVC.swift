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
    
    var fromPause: Bool = false
    var pauseVC = "pauseVC"
    var gameDelegate: UIGameplayVC!
    var levelDelegate: UIGameplayVC!
    var tapStartDelegate: UIGameplayVC!
    var pauseDelegate: UIGameplayVC!
    var starCountRun: Int!
    var timeRun: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soundSlider.value = soundVolume
        musicSlider.value = musicVolume
        localStore = PurchasableItems()
        showNavigationBar()
    }

    @IBAction func changedSoundSlider(_ sender: Any) {
        soundVolume = soundSlider.value
        localStore.retrieveItem(identifier: "Insets")[0].setValue(soundSlider.value, forKey: "soundVal")
        localStore.saveContext()
    }
    
    
    @IBAction func changedMusicSlider(_ sender: Any) {
        musicVolume = musicSlider.value
        BackgroundMusic.shared.updateVolume()
        localStore.retrieveItem(identifier: "Insets")[0].setValue(musicSlider.value, forKey: "musicVal")
        localStore.saveContext()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if fromPause {
            let destinationVC = storyboard!.instantiateViewController(withIdentifier: pauseVC) as! PauseVC
            destinationVC.modalPresentationStyle = .overFullScreen
            
            destinationVC.gameDelegate = gameDelegate
            destinationVC.levelDelegate = levelDelegate
            destinationVC.tapStartDelegate = tapStartDelegate
            destinationVC.starCountRun = starCountRun
            destinationVC.timeRun = timeRun
            
            navigationController!.present(destinationVC, animated: true, completion: { })
            destinationVC.view.backgroundColor = .clear
            gameDelegate.overlayBlurredBackgroundView()

        }
    }
    
}
