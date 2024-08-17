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
<<<<<<< HEAD:Orbscape/Orbscape/EndGameVC.swift
        for count in 1...3 {
            balls.append(self.createImage(image: currentSkin.skin, maxSize: 100, segNum: count))
            balls.append(self.createImage(image: UIImage(named: "star")!, maxSize: 40, segNum: count))
        }
        timeLabel.text = timeRun
        totalStarsLabel.text = String(currentStarsCount) + " ★"
        collectedStarsLabel.text = "+ " + String(starCountRun) + " ★"
=======
        for _ in 1...3 {
            balls.append(self.createImage(image: currentSkin.skin, maxSize: 100))
            balls.append(self.createImage(image: UIImage(named: "star")!, maxSize: 30))
        }
        timeLabel.text = timeRun
        totalStarsLabel.text = String(currentStarsCount) + "★"
        collectedStarsLabel.text = "+ " + String(starCountRun) + "★"
>>>>>>> 199cedf3904d64cdb36509fea842b6fe37dd1c1f:Orbscape/EndGameVC.swift
        // We all need to update their total stars
        currentStarsCount = currentStarsCount + starCountRun
        localStore.retrieveItem(identifier: "Player")[0].setValue(currentStarsCount, forKey: "stars")
    }
    
    // plays animation
    override func viewWillAppear(_ animated: Bool) {
        for ball in balls {
            ballAnimation(view: ball)
        }
    }

    // initialize ball objects ready for animation
<<<<<<< HEAD:Orbscape/Orbscape/EndGameVC.swift
    private func createImage(image: UIImage, maxSize: Int, segNum: Int) -> UIView {
        let size = Int.random(in: 30..<maxSize)
        let ySegment = (Int(self.view.bounds.height)/2) / 3
        var yStart = (ySegment * (segNum - 1)) + 30
        var yEnd = (ySegment * (segNum)) - 30
        if yStart > yEnd {
            let temp = yStart
            yStart = yEnd
            yEnd = temp
        }
        let ball = UIView(frame: CGRect(
            x: Int.random(in: 30..<(Int(self.view.bounds.width) - 30)),
            y: Int.random(in: yStart..<yEnd),
=======
    private func createImage(image: UIImage, maxSize: Int) -> UIView {
        let size = Int.random(in: 20..<maxSize)
        let ball = UIView(frame: CGRect(
            x: Int.random(in: 1..<Int(self.view.bounds.width)),
            y: Int.random(in: 1..<Int(self.view.bounds.height)/2 - 30),
>>>>>>> 199cedf3904d64cdb36509fea842b6fe37dd1c1f:Orbscape/EndGameVC.swift
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
