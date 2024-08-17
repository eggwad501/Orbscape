//
//  EndGameVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/12/24.
//

import UIKit

class EndGameVC: UIGameplayVC {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalStarsLabel: UILabel!
    @IBOutlet weak var collectedStarsLabel: UILabel!
    
    var gameDelegate: UIGameplayVC!
    var homeDelegete: UIGameplayVC!
    var balls: Array<UIView> = []
    var starCountRun: Int!
    var timeRun: String!

    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
        if let gameVC = gameDelegate as? GameViewController{
            gameVC.stopGame()
        }
        
        for _ in 1...3 {
            balls.append(self.createImage(image: currentSkin.skin, maxSize: 100))
            balls.append(self.createImage(image: UIImage(named: "star")!, maxSize: 30))
        }
        timeLabel.text = timeRun
        totalStarsLabel.text = String(currentStarsCount) + "★"
        if starCountRun == nil{
            collectedStarsLabel.text = "+ 0★"
            starCountRun = 0
        }
        else{
            collectedStarsLabel.text = "+ " + String(starCountRun) + "★"
        }
        localStore.retrieveItem(identifier: "Player")[0].setValue(currentStarsCount, forKey: "stars")
    }
    
    // plays animation
    override func viewWillAppear(_ animated: Bool) {
        for ball in balls {
            ballAnimation(view: ball)
        }
    }

    // initialize ball objects ready for animation
    private func createImage(image: UIImage, maxSize: Int) -> UIView {
        let size = Int.random(in: 20..<maxSize)
        let ball = UIView(frame: CGRect(
            x: Int.random(in: 1..<Int(self.view.bounds.width)),
            y: Int.random(in: 1..<Int(self.view.bounds.height)/2 - 30),
            width: size,
            height: size))
        ball.backgroundColor = UIColor.clear
        
        let imageView = UIImageView(image: image)
        imageView.frame = ball.bounds
        imageView.backgroundColor = UIColor.clear
        ball.addSubview(imageView)
        ball.transform = ball.transform.rotated(by: CGFloat(Double.random(in: (-1 * Double.pi)..<(Double.pi))))
        self.view.addSubview(ball)
        return ball
    }
    
    
    @IBAction func homeButton(_ sender: Any) {
        dismiss(animated: true)
        gameDelegate.dismiss(animated: true, completion: nil)
        gameDelegate.removeBlurredBackgroundView()
        
        if homeDelegete != nil,
           let navController = gameDelegate.navigationController {
            navController.popToViewController(homeDelegete, animated: true)
        }
        
    }
    

    

}
