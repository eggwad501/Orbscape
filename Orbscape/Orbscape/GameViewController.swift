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
    
    var delegate: UIGameplayVC?
    var difficulty: Int!
    
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel! // TODO: update timer
    @IBOutlet weak var pauseButton: UIButton!
    
    var pauseIdentifier = "pauseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starCountLabel.text = "\(currentStarsCount) ★"
        pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
        
        if let view = self.view as! SKView? {
            let debug = true
            print("GVC: \(difficulty!)")
            if(debug){
                view.showsFPS = true
                view.showsNodeCount = true
                view.showsQuadCount = true
                view.showsPhysics = true
            }
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene{
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                    
                // Present the scene
                scene.difficultyLevel = difficulty
                view.presentScene(scene)
                scene.difficultyLevel = difficulty
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == pauseIdentifier,
           let destination = segue.destination as? PauseVC {
            destination.gameDelegate = self
            overlayBlurredBackgroundView()
        }
    }
}
