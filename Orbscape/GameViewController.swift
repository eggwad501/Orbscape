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
    func stopGame()
}

class GameViewController: UIGameplayVC, GameSceneDelegate {
    
    var delegate: UIGameplayVC?
    var difficulty: Int!
    
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    var gameScene: SKScene?
    var newGameScene: GameScene?

    var totalTime: TimeInterval?
    var remainingTime: TimeInterval?
    var timer: Timer?
    var startTime: Date?
    private var elapsedTime: TimeInterval = 0
    private var isPaused: Bool = false
    var starCount: Int!
    
    var completedMaze: Bool = true
    
    var pauseIdentifier = "pauseIdentifier"
    var endIdentifier = "endGameSegue"
    var tapStartDelegate: UIGameplayVC!
    var levelDelegate: UIGameplayVC!   
    var homeDelegete: UIGameplayVC!

    override func viewDidLoad() {
        super.viewDidLoad()
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
                print("Presenting the Game")
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
        
        if difficulty == 5 {
            totalTime = 20
            remainingTime = 20
        } else if difficulty == 10 {
            totalTime = 40
            remainingTime = 40
        } else {
            totalTime = 60
            remainingTime = 60
        }
        
        starCountLabel.text = "0 ★"
        let minutes = Int(totalTime!) / 60
        let seconds = Int(totalTime!) % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        setupTimer()
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
        starCount = count
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
            remainingTime = totalTime! - timeElapsed
            
            if remainingTime! <= 0 {
                remainingTime = 0
                timer?.invalidate()
                timerLabel.text = "00:00"
                completedMaze = false
                performSegue(withIdentifier: endIdentifier, sender: self)
            } else {
                let minutes = Int(remainingTime!) / 60
                let seconds = Int(remainingTime!) % 60
                timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
            }
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
        remainingTime = totalTime
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
    
    func stopGame() {
        stopTimer()
        print("Stopped Game")
        gameScene!.removeAllActions()
        gameScene!.removeAllChildren()
        gameScene!.view?.presentScene(nil)
        gameScene = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == pauseIdentifier,
           let destination = segue.destination as? PauseVC {
            pauseGame()
            destination.gameDelegate = self
            destination.levelDelegate = levelDelegate
            destination.tapStartDelegate = tapStartDelegate
            destination.starCountRun = starCount
            destination.timeRun = timerLabel.text
            overlayBlurredBackgroundView()
        } else if segue.identifier == endIdentifier,
                  let destination = segue.destination as? EndGameVC {
            stopTimer()
            if let scene = gameScene as? BallProperties {
                scene.stopBall()
            }
            destination.finishedMaze = completedMaze
            destination.gameDelegate = self
            destination.starCountRun = starCount
            destination.timeRun = timerLabel.text
            destination.homeDelegete = homeDelegete
            overlayBlurredBackgroundView()
        }
    }
}
