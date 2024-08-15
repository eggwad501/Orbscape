//
//  PauseVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/12/24.
//

import UIKit

class PauseVC: UIGameplayVC {
    var gameDelegate: UIGameplayVC!
    var starCountRun: Int!
    var timeRun: Float!
    var confirmIdentifier = "confirmIdentifier"
    
    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popoverPresentationController?.backgroundColor = UIColor.clear
    }
    
    // dismiss screen with cancel
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        gameDelegate.removeBlurredBackgroundView()
    }
    
    // dismiss screen with play icon button
    @IBAction func playButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        gameDelegate.removeBlurredBackgroundView()
    }
    
    // sent over current vc to pause vc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == confirmIdentifier,
           let destination = segue.destination as? QuitConfirmVC {
            destination.gameDelegate = gameDelegate
            destination.pauseDelegate = self
            destination.starCountRun = self.starCountRun
            destination.timeRun = self.timeRun
            self.overlayBlurredBackgroundView()
        }
    }
    
    // empty; so there would be no gradient applied in this view controller
    override func viewIsAppearing(_ animated: Bool) {
    }
}
