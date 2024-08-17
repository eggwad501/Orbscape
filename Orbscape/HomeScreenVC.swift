//
//  HomeScreenVC.swift
//  Orbscape
//
// Project: Orbscape
// EID: nmt736, rw28469, ss79767, nae596
// Course: CS371L

import UIKit
import SwiftUI
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

class HomeScreenVC: UIGameplayVC{
    
    @IBOutlet weak var mazeImage: UIImageView!
    var balls: Array<ballAnimationView>! = []
    var localStore: PurchasableItems!

    // additional setup after loading the view
    override func viewDidLoad() {
        balls.append(self.createBalls(color: UIColor.white, horzPos: -20, distance: 250, duration: 2.5))
        balls.append(self.createBalls(color: UIColor.white, horzPos: 90, distance: 120, duration: 1.5))
        balls.append(self.createBalls(color: UIColor.white, horzPos: 230, distance: 100, duration: 2.5))
        balls.append(self.createBalls(color: UIColor.white, horzPos: 300, distance: 220, duration: 3.0))
        balls.append(self.createBalls(color: UIColor.white, horzPos: 370, distance: 170, duration: 1.5))
        
        mazeImage.layer.compositingFilter = "overlayBlendMode"
        mazeImage.layer.opacity = 0.3
    }
    
    // plays animation
    override func viewWillAppear(_ animated: Bool) {
        for ball in balls {
            bounceAnimation(duration: TimeInterval(ball.duration), distance: CGFloat(ball.distance), object: ball)
        }
        mazeAnimation(duration: TimeInterval(3.0), distance: CGFloat(100))
    }
    
    // initialize ball objects ready for animation
    private func createBalls(color: UIColor, horzPos: Int, distance: Int, duration: Float) -> ballAnimationView {
        let ball = ballAnimationView(fillColor: color, horzPos: horzPos, distance: distance, duration: duration)
        ball.frame = CGRect(
            x: horzPos, y: Int(self.view.bounds.height), width: 30, height: 30)
        ball.backgroundColor = UIColor.clear
        ball.layer.compositingFilter = "overlayBlendMode"
        ball.layer.opacity = 0.3
        self.view.addSubview(ball)
        return ball
    }
    
    // bounce looping animation for the ball
    private func bounceAnimation(duration: TimeInterval, distance: CGFloat, object: ballAnimationView) {
        object.frame.origin.x = CGFloat(object.horzPos)
        object.frame.origin.y = self.view.bounds.height
        UIView.animate (
            withDuration: duration,
            delay: 0.0,
            options: [.repeat, .autoreverse, .curveEaseInOut],
            animations: {
                object.frame.origin.y = object.frame.origin.y - distance
            }
        )
    }
    
    // rotational looping animation for the maze image
    private func mazeAnimation(duration: TimeInterval, distance: CGFloat) {
        self.mazeImage.frame.origin.x = -50
        self.mazeImage.frame.origin.y = self.view.bounds.height - 100
        UIView.animate (
            withDuration: duration,
            delay: 0.0,
            options: [.repeat, .autoreverse, .curveEaseInOut],
            animations: {
                self.mazeImage.transform = self.mazeImage.transform.rotated(by: CGFloat(-1 * Double.pi * 0.02))
                self.mazeImage.frame.origin.y = self.mazeImage.frame.origin.y - distance
                self.mazeImage.transform = self.mazeImage.transform.rotated(by: CGFloat(Double.pi * 0.02))
            }
        )
    }
    
    // sends necessary data to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "levelSegue",
           let tapVC = segue.destination as? LevelsVC {
            tapVC.homeDelegete = self
        }
    }

}
