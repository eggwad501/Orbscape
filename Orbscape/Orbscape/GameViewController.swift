//
//  GameViewController.swift
//  ballTest
//
//  Created by Nhat Tran on 7/15/24.
//

import UIKit
import SpriteKit
import GameplayKit

let displaySize: CGRect = UIScreen.main.bounds

class GameViewController: UIGameplayVC {
    
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel! // TODO: update timer
    @IBOutlet weak var pauseButton: UIButton!
    
    var pauseIdentifier = "pauseIdentifier"
    var tapStartDelegate: UIGameplayVC!
    var levelDelegate: UIGameplayVC!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        starCountLabel.text = "\(currentStarsCount) ★"
        pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
        
        if let view = self.view as! SKView? {
            let debug = false
            if(debug){
                view.showsFPS = true
                view.showsNodeCount = true
                view.showsQuadCount = true
                view.showsPhysics = true
            }
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                    
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == pauseIdentifier,
           let destination = segue.destination as? PauseVC {
            destination.gameDelegate = self
            destination.levelDelegate = levelDelegate
            destination.tapStartDelegate = tapStartDelegate
            destination.timeRun = Float(starCountLabel.text!)
            destination.timeRun = Float(timerLabel.text!)
            self.overlayBlurredBackgroundView()
        }
    }
}
