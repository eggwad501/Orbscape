//
//  GameScene.swift
//  ballTest
//
//  Created by Nhat Tran on 7/15/24.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let manager = CMMotionManager()
    var orb = SKSpriteNode()
    var cameraNode = SKCameraNode()
    
    override func didMove(to view: SKView) {

        self.physicsWorld.contactDelegate = self
        
        orb = self.childNode(withName: "orb") as! SKSpriteNode
        
        
        cameraNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdates(to: OperationQueue.main) {
            (data, error) in
            if let error = error {
                print("Accelerometer error: \(error.localizedDescription)")
            } else if let acceleration = data?.acceleration {
                self.physicsWorld.gravity = CGVector(dx: acceleration.x * 9.8, dy: acceleration.y * 9.8)
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        cameraNode.position = orb.position
    }
}
