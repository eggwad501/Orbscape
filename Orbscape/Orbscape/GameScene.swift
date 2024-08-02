//
//  GameScene.swift
//  ballTest
//
//  Created by Nhat Tran on 7/15/24.
//

import SpriteKit
import GameplayKit
import CoreMotion

struct Collision {
    static let ballBody: UInt32 = 0x1 << 0
    static let finishHoleBody: UInt32 = 0x1 << 1
    static let wallBody: UInt32 = 0x1 << 2
    static let starBody: UInt32 = 0x1 << 3
}

// requests MazeMaker to generate a maze for the game
var delegate: MazeGenerator?

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var ballObject: SKSpriteNode!
    var manager: CMMotionManager?
    
    var cameraNode = SKCameraNode()
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        // makeshift camera, can delete
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(cameraNode)
        camera = cameraNode
        
        // makes a maze of some difficulty
        let difficultyLevel = 66
        let squareSize = difficultyLevel * 4 - 1
        let startTime = CFAbsoluteTimeGetCurrent()
        makeSquareMaze(difficultyLevel)
        let endTime = CFAbsoluteTimeGetCurrent()
        let elapsedTime = endTime - startTime
        print("Total Maze Time taken: \(elapsedTime) seconds")
        /*
         String compares are cheaper than expected, keep the string
         Array math is fast, sprite loading is slow
         Difficulty(not rows/cols) and Time taken to load maze
         75 = 31.443s
         65 = 15.062s
         60 = 09.911s
         55 = 06.029s
         50 = 03.412s
         40 = 01.750s
         25 = 00.341s
        */
        let ballStartX = squareSize * 64 / 2 - 200 - 32
        let ballStartY = squareSize * 64 + 200
        ballObject = SKSpriteNode(imageNamed: "ball")
        ballObject.size = CGSize(width: 32, height: 32)
        ballObject.position = CGPoint(x: ballStartX, y: ballStartY)
        ballObject.physicsBody = SKPhysicsBody(circleOfRadius: CGRectGetHeight(ballObject.frame) / 2)
        ballObject?.physicsBody?.mass = 5
        ballObject.physicsBody?.allowsRotation = true
        ballObject.physicsBody?.isDynamic = true
        ballObject.physicsBody?.categoryBitMask = Collision.ballBody
        ballObject.physicsBody?.collisionBitMask = Collision.ballBody
        ballObject.physicsBody?.contactTestBitMask = Collision.wallBody
        ballObject.physicsBody?.affectedByGravity = true
        
        addChild(ballObject)
    }
    
    // makes a maze
    // its size depends on the entered difficult
    func makeSquareMaze(_ difficulty: Int){
        let mazeMaker = MazeMaker()
        // magic number to avoid double-walls
        let rows = difficulty * 4 - 1
        let cols = difficulty * 4 - 1
        
        var startTime = CFAbsoluteTimeGetCurrent()
        
        var maze = mazeMaker.createMaze(rows, cols)
        
        var endTime = CFAbsoluteTimeGetCurrent()
        var elapsedTime = endTime - startTime
        print("create Maze Time taken: \(elapsedTime) seconds")
        
        mazeMaker.printMaze(maze)
        startTime = CFAbsoluteTimeGetCurrent()
        
        loadMaze(maze)
        
        endTime = CFAbsoluteTimeGetCurrent()
        elapsedTime = endTime - startTime
        print("load Maze Time taken: \(elapsedTime) seconds")
    }
    
    // loads the maze into the game
    func loadMaze(_ maze: [[Int]]){
        var rowIndex = 0
        var colIndex = 0
        for row in maze{
            for col in maze{
                let wallObject = SKSpriteNode(imageNamed: "bricksx64")
                wallObject.position = CGPoint(x: 64 * colIndex - 200, y: 64 * rowIndex - 200)
                wallObject.size = CGSize(width: 64, height: 64)
                wallObject.physicsBody?.categoryBitMask = Collision.wallBody
                wallObject.physicsBody?.collisionBitMask = Collision.wallBody
                if(maze[rowIndex][colIndex] == 1){
                    wallObject.physicsBody = SKPhysicsBody(rectangleOf: wallObject.size)
                }
                else{
                    wallObject.texture = SKTexture(imageNamed: "star")
                    wallObject.size = CGSize(width: 32, height: 32)
                }
                wallObject.physicsBody?.isDynamic = false // object is pinned
                addChild(wallObject)
                
                colIndex += 1
            }
            rowIndex += 1
            colIndex = 0
        }
    }
        
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        cameraNode.position = ballObject.position
        
        self.lastUpdateTime = currentTime
        if let gravityX = manager?.deviceMotion?.gravity.x,
           let gravityY = manager?.deviceMotion?.gravity.y,
           ballObject != nil {
            ballObject.physicsBody?.applyImpulse(CGVector(dx: CGFloat(gravityX) * 200, dy: CGFloat(gravityY) * 200))
        }
    }
}
