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
    func updateStarCount(to count: Int)
    func pauseGame()
    func resumeGame()
    func stopTimer()
}

class GameViewController: UIGameplayVC, GameSceneDelegate {
    
    var delegate: UIGameplayVC?
    var difficulty: Int!
    
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel! // TODO: update timer
    @IBOutlet weak var pauseButton: UIButton!
    
    var gameScene: SKScene?

    var timer: Timer?
    var startTime: Date?
    private var elapsedTime: TimeInterval = 0
    private var isPaused: Bool = false
    
    var pauseIdentifier = "pauseIdentifier"
    var endIdentifier = "endGameSegue"
    var tapStartDelegate: UIGameplayVC!
    var levelDelegate: UIGameplayVC!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starCountLabel.text = "0 ★"
        timerLabel.text = "00:00"
        setupTimer()
        
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
                gameScene = scene
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                    
                // Present the scene
                scene.difficultyLevel = difficulty
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
    
    func updateStarCount(to count: Int) {
        starCountLabel.text = "\(count) ★"
    }
    
    func setupTimer() {
        startTime = Date()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, 
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc private func updateTimer() {
        if let startTime = self.startTime {
            let currentTime = Date()
            let timeElapsed = currentTime.timeIntervalSince(startTime) + elapsedTime
            let minutes = Int(timeElapsed) / 60
            let seconds = Int(timeElapsed) % 60
            timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        }
    }

    func pauseTimer() {
        if !isPaused {
            isPaused = true
            elapsedTime += Date().timeIntervalSince(startTime ?? Date())
            timer?.invalidate()
            timer = nil
        }
    }
    
    func resumeTimer() {
        if isPaused {
            isPaused = false
            startTime = Date()
            setupTimer()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        elapsedTime = 0
    }
    
    func pauseGame() {
        pauseTimer()
        if let scene = gameScene as? BallProperties {
            scene.stopBall()
        }
    }
    
    func resumeGame() {
        resumeTimer()
        if let scene = gameScene as? BallProperties {
            scene.resumeBall()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == pauseIdentifier,
        let destination = segue.destination as? PauseVC {
            pauseGame()
            destination.gameDelegate = self
            destination.levelDelegate = levelDelegate
            destination.tapStartDelegate = tapStartDelegate
            
            // We should just pass in the text, not the actual values. It'd be easier
            destination.starCountRun = Int(starCountLabel.text!)
            destination.timeRun = Float(timerLabel.text!)
            overlayBlurredBackgroundView()
        } else if segue.identifier == endIdentifier,
        let destination = segue.destination as? EndGameVC {
            stopTimer()
            destination.gameDelegate = self
            overlayBlurredBackgroundView()
        }
    }
}
