//
//  QuitConfirmVC.swift
//  Orbscape
//
// Project: Orbscape
// EID: nmt736, rw28469, ss79767, nae596
// Course: CS371L

import UIKit

class QuitConfirmVC: UIGameplayVC {
    
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var levelDelegate: UIGameplayVC!
    var tapStartDelegate: UIGameplayVC!
    var gameDelegate: UIGameplayVC!
    var pauseDelegate: UIGameplayVC!
    var starCountRun: Int!
    var timeRun: String!
    var quitLevel: Bool!
    
    // updates the UI
    override func viewWillAppear(_ animated: Bool) {
        starsLabel.text = String(starCountRun) + " ★"
        timeLabel.text = timeRun
    }
    
    // dismiss to tap to start vc
    @IBAction func quitButton(_ sender: Any) {
        gameDelegate.dismiss(animated: true, completion: nil)
        pauseDelegate.removeBlurredBackgroundView()
        gameDelegate.removeBlurredBackgroundView()
        
        // moves to the respective view controller and stops the current game
        if levelDelegate != nil && tapStartDelegate != nil,
           let gameVCDelegate = gameDelegate as? GameViewController,
           let navController = gameDelegate.navigationController {
            if quitLevel {
                navController.popToViewController(levelDelegate, animated: false)
                gameVCDelegate.stopGame()
            } else {
                navController.popToViewController(tapStartDelegate, animated: false)
                gameVCDelegate.stopGame()
            }
        }
    }
    
    // dismiss to pause vc
    @IBAction func cancelButton(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
        pauseDelegate.removeBlurredBackgroundView()
     }
    
    // empty; so there would be no gradient applied in this view controller
    override func viewIsAppearing(_ animated: Bool) {
    }
}
