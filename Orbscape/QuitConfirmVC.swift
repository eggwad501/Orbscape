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
<<<<<<< HEAD:Orbscape/Orbscape/QuitConfirmVC.swift
        starsLabel.text = String(starCountRun) + " ★"
=======
        starsLabel.text = String(starCountRun) + "★"
>>>>>>> 199cedf3904d64cdb36509fea842b6fe37dd1c1f:Orbscape/QuitConfirmVC.swift
        timeLabel.text = timeRun
    }
    
    // dismiss to tap to start vc
    @IBAction func quitButton(_ sender: Any) {
<<<<<<< HEAD:Orbscape/Orbscape/QuitConfirmVC.swift
        // WE need to stop the timer somewhere in here
=======
        
        // WE need to stop the timer somewhere in here
        
>>>>>>> 199cedf3904d64cdb36509fea842b6fe37dd1c1f:Orbscape/QuitConfirmVC.swift
        gameDelegate.dismiss(animated: true, completion: nil)
        pauseDelegate.removeBlurredBackgroundView()
        gameDelegate.removeBlurredBackgroundView()
        
        if levelDelegate != nil && tapStartDelegate != nil,
           let gameVCDelegate = gameDelegate as? GameViewController,
           let navController = gameDelegate.navigationController {
            if quitLevel {
<<<<<<< HEAD:Orbscape/Orbscape/QuitConfirmVC.swift
                navController.popToViewController(levelDelegate, animated: false)
                gameVCDelegate.stopGame()
            } else {
                navController.popToViewController(tapStartDelegate, animated: false)
=======
                print("Quit level")
                navController.popToViewController(levelDelegate, animated: true)
                gameVCDelegate.stopGame()
            } else {
                print("QCVC: else")
                navController.popToViewController(tapStartDelegate, animated: true)
>>>>>>> 199cedf3904d64cdb36509fea842b6fe37dd1c1f:Orbscape/QuitConfirmVC.swift
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
