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
    static let wallBody: UInt32 = 0x1 << 1
    static let starBody: UInt32 = 0x1 << 2
    static let finishHoleBody: UInt32 = 0x1 << 3
}

// requests MazeMaker to generate a maze for the game
var delegate: MazeGenerator?
var tileSet: SKTileSet!
var tileMap: SKTileMapNode!
var mazeArray: [[Int]]!

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var ballObject: SKSpriteNode!
    var manager: CMMotionManager?
    
    var cameraNode = SKCameraNode()
    
    // performance testers
    var startTime = CFAbsoluteTime()
    var endTime = CFAbsoluteTime()
    
    // garbage collector
    var timeSinceGC: TimeInterval = 0
    
    func elapsedTime(_ startTime: Double, _ endTime: Double, _ msg: String){
        print(msg)
        print(endTime - startTime)
    }
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        // set up collisions
        physicsWorld.contactDelegate = self
        
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
        
        // tile setup
        // TODO: takes a long time to load for big maps
        guard let tileSet = SKTileSet(named: "Sample Grid Tile Set") else {
            fatalError("Tile set not found")
        }
        let tileSize = CGSize(width: 64, height: 64)
        let columns = 10
        let rows = 10

        tileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        for column in 0..<columns {
            for row in 0..<rows {
                let tileGroup = tileSet.tileGroups.first(where: { $0.name == "Grass" })
                tileMap.setTileGroup(tileGroup, forColumn: column, row: row)
            }
        }
        tileMap.position = CGPoint(x: frame.midX, y: frame.midY)
        //addChild(tileMap)
        
        // makes a maze of some difficulty
        let difficultyLevel = 5
        let squareSize = difficultyLevel * 4 - 1
        startTime = CFAbsoluteTimeGetCurrent()
        makeSquareMaze(difficultyLevel)
        endTime = CFAbsoluteTimeGetCurrent()
        elapsedTime(startTime, endTime, "Toal Maze Time taken")
        /*
         String compares are cheaper than expected, keep the string
         Array math is fast, sprite loading is slow
         The camera sees 11x22 sprites at all times
         Keep 22x44 loaded at all times
         Difficulty(not rows/cols) and Time taken to load maze
         75 = 31.443s
         65 = 15.062s
         60 = 09.911s, 11 fps
         55 = 06.029s
         50 = 03.412s, 24fps
         40 = 01.750s, 36fps
         25 = 00.341s, 60 fps, 9.8k nodes
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
        ballObject.physicsBody?.collisionBitMask = Collision.wallBody | Collision.starBody
        ballObject.physicsBody?.contactTestBitMask = Collision.wallBody | Collision.starBody
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
        
        startTime = CFAbsoluteTimeGetCurrent()
        mazeArray = mazeMaker.createMaze(rows, cols)
        endTime = CFAbsoluteTimeGetCurrent()
        //elapsedTime(startTime, endTime, "create Maze Time taken")
        
        //mazeMaker.printMaze(mazeArray)
        
        startTime = CFAbsoluteTimeGetCurrent()
        loadMaze(mazeArray)
        endTime = CFAbsoluteTimeGetCurrent()
        //elapsedTime(startTime, endTime, "load Maze time taken")
    }
    
    // check if the node is visible to the camera
    func isNodeVisible(_ node: SKNode) -> Bool {
        let cameraView = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
            
        // Convert the node's position to the scene's coordinate system
        let nodePosition = node.position
        
        // Convert the node's position from the scene's coordinate system to the view's coordinate system
        let nodePositionInView = cameraView.contains(nodePosition)
        
        // Check if the node's position is within the bounds of the view
        //return view!.bounds.contains(nodePositionInView)
        return nodePositionInView
    }
    
    // loads the maze into the game, node version
    func loadMaze(_ maze: [[Int]]){
        var rowIndex = 0
        var colIndex = 0
        var visibles = 0
        var walls = 0
        var mazeObject: SKSpriteNode!
        for row in maze{
            for col in maze{
                mazeObject = SKSpriteNode(imageNamed: "Error")
                mazeObject.position = CGPoint(x: 64 * colIndex - 200, y: 64 * rowIndex - 200)
                // change what maze object is based on mazeArray
                if(maze[rowIndex][colIndex] == 1){
                    mazeObject.texture = SKTexture(imageNamed: "bricksx64")
                    mazeObject.size = CGSize(width: 64, height: 64)
                    mazeObject.physicsBody = SKPhysicsBody(rectangleOf: mazeObject.size)
                    mazeObject.physicsBody?.categoryBitMask = Collision.wallBody
                    mazeObject.physicsBody?.collisionBitMask = Collision.ballBody
                    mazeObject.physicsBody?.contactTestBitMask = Collision.ballBody
                    mazeObject.name = "wall"
                    addChild(mazeObject)
                    /*
                    if isNodeVisible(mazeObject, in: self) {
                        addChild(mazeObject)
                    }
                     */
                    walls += 1
                    if(isNodeVisible(mazeObject)){
                        visibles += 1
                    }
                }
                else if(Int.random(in: 1..<100) < 0){
                    mazeObject.texture = SKTexture(imageNamed: "star")
                    mazeObject.size = CGSize(width: 32, height: 32)
                    mazeObject.physicsBody = SKPhysicsBody(rectangleOf: mazeObject.size)
                    mazeObject.physicsBody?.categoryBitMask = Collision.starBody
                    mazeObject.physicsBody?.collisionBitMask = Collision.ballBody
                    mazeObject.physicsBody?.contactTestBitMask = Collision.ballBody
                    addChild(mazeObject)
                }
                mazeObject.physicsBody?.isDynamic = false // object is pinned
                
                colIndex += 1
            }
            rowIndex += 1
            colIndex = 0
        } // end of loop
        /* attempt to use union of sprite nodes
        let wallUnion = SKPhysicsBody(bodies: wallList)
        wallUnion.isDynamic = false
        let mazeNode = SKNode()
        mazeNode.physicsBody = wallUnion
        addChild(mazeNode)
         */
        print("Walls: \(walls) Visibles: \(visibles)")
    }
    
    // runs when the ball collides with something else
    func didBegin(_ contact: SKPhysicsContact) {
        let ballObject = contact.bodyA.categoryBitMask == Collision.ballBody ? contact.bodyA : contact.bodyB
        let otherObject = contact.bodyB.categoryBitMask != Collision.ballBody ? contact.bodyB : contact.bodyA
        // Handle collision between ball and wall
        // TODO: add sfx when colliding with wall or star
        if(otherObject.categoryBitMask == Collision.wallBody){
            //print("Player collided with a wall")
        }
        // handle collision between ball and star
        else if(otherObject.categoryBitMask == Collision.starBody){
            //print("Player collected a star")
            otherObject.node?.removeFromParent()
            // TODO: add star to player's account
        }
        else{
            print("Error")
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
        
        // enable/disable wall nodes
        /*
        for object in children where (object.name == "wall"){
            if isNodeVisible(object, in: self) {
                if object.parent == nil {
                    addChild(object)
                }
            } else {
                object.removeFromParent()
            }
        }
        */
        
        cameraNode.position = ballObject.position
        
        self.lastUpdateTime = currentTime
        //print("Camera position: \(cameraNode.position)")
    }
}
