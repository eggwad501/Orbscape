//
//  SettingsVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

import UIKit

protocol settingChanger {
    func changeCredit(boolean: Bool)
}


class SettingsVC: UIGameplayVC, settingChanger {

    @IBOutlet weak var soundSlider: UISlider!
    @IBOutlet weak var musicSlider: UISlider!
    var localStore: PurchasableItems!
    
    var fromPause: Bool = false
    var pauseVC = "pauseVC"
    var creditsIdentifier = "creditsIdentifier"
    var gameDelegate: UIGameplayVC!
    var levelDelegate: UIGameplayVC!
    var tapStartDelegate: UIGameplayVC!
    var pauseDelegate: UIGameplayVC!
    
    var toCredits: Bool = false
    
    var createdPauseVC: UIViewController!
    var starCountRun: Int!
    var timeRun: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soundSlider.value = soundVolume
        musicSlider.value = musicVolume
        localStore = PurchasableItems()
        showNavigationBar()
    }

    // change the volume of the sound effects
    @IBAction func changedSoundSlider(_ sender: Any) {
        soundVolume = soundSlider.value
        localStore.retrieveItem(identifier: "Insets")[0].setValue(soundSlider.value, forKey: "soundVal")
        localStore.saveContext()
    }
    
    // change the volume of the background music
    @IBAction func changedMusicSlider(_ sender: Any) {
        musicVolume = musicSlider.value
        BackgroundMusic.shared.updateVolume()
        localStore.retrieveItem(identifier: "Insets")[0].setValue(musicSlider.value, forKey: "musicVal")
        localStore.saveContext()
    }
    
    // redisplaying the pause layout
    override func viewWillDisappear(_ animated: Bool) {
        if fromPause && !toCredits {
            let destinationVC = storyboard!.instantiateViewController(withIdentifier: pauseVC) as! PauseVC
            destinationVC.modalPresentationStyle = .overFullScreen
            
            destinationVC.gameDelegate = gameDelegate
            destinationVC.levelDelegate = levelDelegate
            destinationVC.tapStartDelegate = tapStartDelegate
            destinationVC.starCountRun = starCountRun
            destinationVC.timeRun = timeRun
            
            createdPauseVC = destinationVC
            
            navigationController!.present(destinationVC, animated: true, completion: { })
            destinationVC.view.backgroundColor = .clear
            gameDelegate.overlayBlurredBackgroundView()
        }
    }
    
    // send over necessary data to credits vc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == creditsIdentifier,
           let destination = segue.destination as? CreditsVC {
            toCredits = true
            destination.settingDelegate = self
        } 
    }
    
    // change condition so pause only appears after setting is closed
    func changeCredit(boolean: Bool) {
        toCredits = boolean
    }
    
}
