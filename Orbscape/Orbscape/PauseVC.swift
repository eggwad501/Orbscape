//
//  PauseVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/12/24.
//

import UIKit

class PauseVC: UIGameplayVC {
    var levelDelegate: UIGameplayVC!
    var tapStartDelegate: UIGameplayVC!
    var gameDelegate: UIGameplayVC!
    var starCountRun: Int!
    var timeRun: Float!
    var retryConfirmIdentifier = "retryConfirmIdentifier"
    var levelConfirmIdentifier = "levelConfirmIdentifier"
    var settingIdentifier = "settingIdentifier"
    var settingsVC = "settingsVC"

    
    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popoverPresentationController?.backgroundColor = UIColor.clear
        
    }
    
    // dismiss screen with cancel
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        gameDelegate.removeBlurredBackgroundView()
        if let sceneDelegate = gameDelegate as? GameSceneDelegate {
            sceneDelegate.resumeGame()
        }
    }
    
    // dismiss screen with play icon button
    @IBAction func playButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        gameDelegate.removeBlurredBackgroundView()
        if let sceneDelegate = gameDelegate as? GameSceneDelegate {
            sceneDelegate.resumeGame()
        }
    }
    
    // sent over current vc to pause vc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == retryConfirmIdentifier || segue.identifier == levelConfirmIdentifier,
           let destination = segue.destination as? QuitConfirmVC {
            destination.levelDelegate = levelDelegate
            destination.gameDelegate = gameDelegate
            destination.tapStartDelegate = tapStartDelegate
            destination.pauseDelegate = self
            destination.starCountRun = self.starCountRun
            destination.timeRun = self.timeRun
            self.overlayBlurredBackgroundView()
            
            if segue.identifier == levelConfirmIdentifier {
                destination.quitLevel = true
            } else {
                destination.quitLevel = false
            }
        }
    }
    
    // setting button
    @IBAction func settingButton(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        gameDelegate.removeBlurredBackgroundView()
        
        let destinationViewController = storyboard!.instantiateViewController(withIdentifier: settingsVC) as! SettingsVC
        
        gameDelegate.navigationController!.pushViewController(destinationViewController, animated: true)
    }
    
    // empty; so there would be no gradient applied in this view controller
    override func viewIsAppearing(_ animated: Bool) {
    }
}
