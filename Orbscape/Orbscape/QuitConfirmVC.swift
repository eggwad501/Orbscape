//
//  QuitConfirmVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/12/24.
//

import UIKit

class QuitConfirmVC: UIGameplayVC {
    var gameDelegate: UIGameplayVC!
    var pauseDelegate: UIGameplayVC!
    var starCountRun: Int!
    var timeRun: Float!

    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // dismiss to tap to start vc
    @IBAction func quitButton(_ sender: Any) {
        gameDelegate.dismiss(animated: true, completion: nil)
        pauseDelegate.removeBlurredBackgroundView()
        
        if let navController = gameDelegate.navigationController {
            navController.popViewController(animated: true)
            gameDelegate.removeBlurredBackgroundView()
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
