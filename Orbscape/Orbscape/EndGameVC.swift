//
//  EndGameVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 8/12/24.
//

import UIKit

class EndGameVC: UIGameplayVC {
    
    var gameDelegate: UIGameplayVC!
    var balls: Array<UIView> = []

    // additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...3 {
            balls.append(self.createImage(image: currentSkin.skin, maxSize: 100))
            balls.append(self.createImage(image: UIImage(named: "star")!, maxSize: 30))
        }
    }
    
    // plays animation
    override func viewWillAppear(_ animated: Bool) {
        for ball in balls {
            ballAnimation(view: ball)
        }
        print(navigationController?.viewControllers)
    }

    // initialize ball objects ready for animation
    private func createImage(image: UIImage, maxSize: Int) -> UIView {
        let size = Int.random(in: 20..<maxSize)
        var ball = UIView(frame: CGRect(
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
    
    

    

}
