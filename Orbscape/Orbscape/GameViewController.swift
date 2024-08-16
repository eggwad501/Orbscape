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

protocol GameSceneDelegate {
    func triggerSegue(withIdentifier identifier: String)
}

class GameViewController: UIGameplayVC, GameSceneDelegate {
    
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel! // TODO: update timer
    @IBOutlet weak var pauseButton: UIButton!
    
    var pauseIdentifier = "pauseIdentifier"
    var endIdentifier = "endGameSegue"
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
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                scene.sceneDelegate = self
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
    
    func triggerSegue(withIdentifier identifier: String) {
        performSegue(withIdentifier: identifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == pauseIdentifier,
           let destination = segue.destination as? PauseVC {
            destination.gameDelegate = self
            destination.levelDelegate = levelDelegate
            destination.tapStartDelegate = tapStartDelegate
            destination.timeRun = Float(starCountLabel.text!)
            destination.timeRun = Float(timerLabel.text!)
            overlayBlurredBackgroundView()
        } else if segue.identifier == endIdentifier,
                  let destination = segue.destination as? EndGameVC {
            destination.gameDelegate = self
            overlayBlurredBackgroundView()
        }
    }
}
