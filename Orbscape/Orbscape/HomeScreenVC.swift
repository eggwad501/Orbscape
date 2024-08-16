//
//  HomeScreenVC.swift
//  Orbscape
//
//  Created by Ronghua Wang on 7/29/24.
//

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
        
        localStore = PurchasableItems()
        
        let request: NSFetchRequest<Theme> = Theme.fetchRequest()
        do {
            let count = try context.count(for: request)
            if count == 0 {
                // No data found, initialize default data
                for _ in 1...8 {
                    let newObject = Theme(context: context)
                    newObject.purchased = false
                    newObject.equippedIndex = 0
                }
                localStore.saveContext()
            }
        } catch {
            print("Failed to fetch count: \(error.localizedDescription)")
        }
        
        let requestTwo: NSFetchRequest<Skin> = Skin.fetchRequest()
        do {
            let count = try context.count(for: requestTwo)
            if count == 0 {
                // No data found, initialize default data
                for _ in 1...8 {
                    let newObject = Skin(context: context)
                    newObject.purchased = false
                    newObject.equippedIndex = 0
                }
                localStore.saveContext()
            }
        } catch {
            print("Failed to fetch count: \(error.localizedDescription)")
        }
        
        let requestThree: NSFetchRequest<Sound> = Sound.fetchRequest()
        do {
            let count = try context.count(for: requestThree)
            if count == 0 {
                // No data found, initialize default data
                for _ in 1...8 {
                    let newObject = Sound(context: context)
                    newObject.purchased = false
                    newObject.equippedIndex = 0
                }
                localStore.saveContext()
            }
        } catch {
            print("Failed to fetch count: \(error.localizedDescription)")
        }
        
        let requestFour: NSFetchRequest<Player> = Player.fetchRequest()
        do {
            let count = try context.count(for: requestFour)
            if count == 0 {
                let newObject = Player(context: context)
                newObject.stars = 0
                newObject.runTime = 0
                localStore.saveContext()
            }
        } catch {
            print("Failed to fetch count: \(error.localizedDescription)")
        }
        
        let requestFive: NSFetchRequest<Insets> = Insets.fetchRequest()
        do {
            let count = try context.count(for: requestFive)
            if count == 0 {
                // No data found, initialize default data
                for _ in 1...8 {
                    let newObject = Insets(context: context)
                    newObject.musicVal = 0.5
                    newObject.soundVal = 0.5
                }
                localStore.saveContext()
            }
        } catch {
            print("Failed to fetch count: \(error.localizedDescription)")
        }
        
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
                object.frame.origin.y -= distance
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
                self.mazeImage.frame.origin.y -= distance
                self.mazeImage.transform = self.mazeImage.transform.rotated(by: CGFloat(Double.pi * 0.02))
            }
        )
    }

}
