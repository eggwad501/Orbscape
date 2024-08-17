//
//  QuitConfirmVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/12/24.
//

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

    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        starsLabel.text = String(starCountRun) + "★"
        timeLabel.text = timeRun
    }
    
    // dismiss to tap to start vc
    @IBAction func quitButton(_ sender: Any) {
        
        // WE need to stop the timer somewhere in here
        
        gameDelegate.dismiss(animated: true, completion: nil)
        pauseDelegate.removeBlurredBackgroundView()
        gameDelegate.removeBlurredBackgroundView()
        
        if levelDelegate != nil && tapStartDelegate != nil,
           let gameVCDelegate = gameDelegate as? GameViewController,
           let navController = gameDelegate.navigationController {
            if quitLevel {
                print("Quit level")
                navController.popToViewController(levelDelegate, animated: true)
                gameVCDelegate.stopGame()
            } else {
                print("QCVC: else")
                navController.popToViewController(tapStartDelegate, animated: true)
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
