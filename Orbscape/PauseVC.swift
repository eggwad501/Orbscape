//
//  PauseVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/12/24.
//

import UIKit

class PauseVC: UIGameplayVC {
    
    
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var levelDelegate: UIGameplayVC!
    var tapStartDelegate: UIGameplayVC!
    var gameDelegate: UIGameplayVC!
    var starCountRun: Int!
    var timeRun: String!
    var retryConfirmIdentifier = "retryConfirmIdentifier"
    var levelConfirmIdentifier = "levelConfirmIdentifier"
    var settingIdentifier = "settingIdentifier"
    var settingsVC = "settingsVC"
    
    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popoverPresentationController?.backgroundColor = UIColor.clear
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("PauseVC died")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if starCountRun != nil {
            // not nil
            starsLabel.text = String(starCountRun) + "★"
        } else {
            // is nil
            starsLabel.text = "0" + "★"
            starCountRun = 0
        }
        timeLabel.text = timeRun
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
        let destinationVC = storyboard!.instantiateViewController(withIdentifier: settingsVC) as! SettingsVC
        destinationVC.fromPause = true
        destinationVC.gameDelegate = gameDelegate
        destinationVC.levelDelegate = levelDelegate
        destinationVC.tapStartDelegate = tapStartDelegate
        
        // We should just pass in the text, not the actual values. It'd be easier
        destinationVC.starCountRun = starCountRun
        destinationVC.timeRun = timeRun
        destinationVC.pauseDelegate = self
        gameDelegate.navigationController!.pushViewController(destinationVC, animated: true)
        self.dismiss(animated: true, completion: nil)
        gameDelegate.removeBlurredBackgroundView()


    }
    
    // empty; so there would be no gradient applied in this view controller
    override func viewIsAppearing(_ animated: Bool) {
    }
}
