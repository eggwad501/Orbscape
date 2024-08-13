//
//  PauseVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/12/24.
//

import UIKit

class PauseVC: UIGameplayVC {
    var gameDelegate: UIGameplayVC!
    var confirmIdentifier = "confirmIdentifier"
    
    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // dismiss screen with cancel
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        gameDelegate.removeBlurredBackgroundView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == confirmIdentifier,
           let destination = segue.destination as? QuitConfirmVC {
            destination.gameDelegate = gameDelegate
            destination.pauseDelegate = self
            overlayBlurredBackgroundView()
        }
    }
    
    // empty; so there would be no gradient applied in this view controller
    override func viewIsAppearing(_ animated: Bool) {
    }
}
