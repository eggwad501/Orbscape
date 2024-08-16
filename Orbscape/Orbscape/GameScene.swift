//
//  GameScene.swift
//  ballTest
//
//  Created by Nhat Tran on 7/15/24.
//

import SpriteKit
import GameplayKit
import CoreMotion
import AVFoundation

struct Collision {
    static let ballBody: UInt32 = 0x1 << 0
    static let wallBody: UInt32 = 0x1 << 1
    static let starBody: UInt32 = 0x1 << 2
    static let finishHoleBody: UInt32 = 0x1 << 3
    static let entranceBody: UInt32 = 0x1 << 4
}

// requests MazeMaker to generate a maze for the game
var delegate: MazeGenerator?
var tileSet: SKTileSet!
var tileMap: SKTileMapNode!
var mazeArray: [[Int]]!

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var sceneDelegate: GameSceneDelegate?
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    var ballObject: SKSpriteNode!
    let manager = CMMotionManager()
    let tileSize = 64
    let starChance = 100
    var difficultyLevel: Int!
    var isGameFinished = false
    var isBelowEntrance = false
    
    var gradientObject: SKSpriteNode!
    
    var cameraNode = SKCameraNode()
    
    // performance testers
    var startTime = CFAbsoluteTime()
    var endTime = CFAbsoluteTime()
    
    // garbage collector
    var timeSinceGC: TimeInterval = 0
    var timeSinceStart: TimeInterval = 0
    var wallList: [SKSpriteNode] = []
    var visibleWallList: [SKSpriteNode] = []
    var hiddenWallList: [SKSpriteNode] = []
    
    func elapsedTime(_ startTime: Double, _ endTime: Double, _ msg: String){
        print(msg)
        print(endTime - startTime)
    }
    
    override func sceneDidLoad() {
        //print("GS: \(difficultyLevel!)")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.camera = cameraNode
        self.speed = 0.2
        
        self.lastUpdateTime = 0
        
        // set up collisions
        self.physicsWorld.contactDelegate = self
        
        // makeshift camera, can delete
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(cameraNode)
        camera = cameraNode
        
        cameraNode.xScale = 0.5
        cameraNode.yScale = 0.5

        // gravity manager construction
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.15
        manager.startAccelerometerUpdates(to: OperationQueue.main) {
            (data, error) in
            if let error = error {
                print("Accelerometer error: \(error.localizedDescription)")
            } else if let acceleration = data?.acceleration {
                self.physicsWorld.gravity = CGVector(dx: acceleration.x * 9.8, dy: acceleration.y * 9.8)
            }
        }
        
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
         35 = 01.032s, 54fps
         25 = 00.341s, 60 fps, 9.8k nodes
        */
        
        // creates the ball
        let squareSize = difficultyLevel * 4 - 1
        let ballStartPos = (squareSize * 64 / 2 - 32, 100)
        generateBall(ballStartPos)
        
        // close off the entrance
        
        
        // makes a maze of some difficulty
        startTime = CFAbsoluteTimeGetCurrent()
        makeSquareMaze(difficultyLevel)
        endTime = CFAbsoluteTimeGetCurrent()
        elapsedTime(startTime, endTime, "Toal Maze Time taken")
        
        
        // create a gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = frame.size
        gradientLayer.position = CGPoint(x: ballStartPos.0, y: ballStartPos.1)
        gradientLayer.colors = currentTheme.colors

        // convert the gradient into an image
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // add the gradient as a game obj
        let gradientTexture = SKTexture(image: gradientImage!)
        gradientObject = SKSpriteNode(texture: gradientTexture)
        gradientObject.size = CGSize(width: frame.width, height: frame.height)
        gradientObject.position = CGPoint(x: frame.width/2, y: frame.height/2)
        gradientObject.zPosition = -1
        addChild(gradientObject)
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
        
        mazeMaker.printMaze(mazeArray)
        
        startTime = CFAbsoluteTimeGetCurrent()
        loadMaze()
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
        //return nodePositionInView
        return cameraNode.contains(node)
    }
    
    // loads the maze into the game scene
    func loadMaze() {
        var subRow = 0
        var subCol = 0
        var rowIndex = 0
        var colIndex = 0
        let mazeSize = mazeArray.count - 1
        while(rowIndex <= mazeSize){
            while(colIndex <= mazeSize){
                let position = CGPoint(x: tileSize * colIndex, y: -tileSize * rowIndex)
                if(mazeArray[rowIndex][colIndex] == 1){
                    var horizontalLength = 0
                    var verticalLength = 0
                    subCol = colIndex
                    subRow = rowIndex
                    
                    while(subCol <= mazeSize && mazeArray[rowIndex][subCol] == 1){ // go to the right
                        horizontalLength += 1
                        mazeArray[rowIndex][subCol] = -1
                        subCol += 1
                    }
                    
                    let horizontalWall = CGRect(x: position.x - CGFloat(tileSize / 2), y: position.y + CGFloat(tileSize / 2), width: CGFloat(horizontalLength * tileSize), height: -CGFloat(tileSize))
                    generateWall(position, horizontalWall, .red)
                    
                    
                    mazeArray[rowIndex][colIndex] = 1 // have vert wall start at the same pos as hori wall
                    while(subRow <= mazeSize && mazeArray[subRow][colIndex] == 1){ // go downwards
                        verticalLength += 1
                        mazeArray[subRow][colIndex] = -1
                        subRow += 1
                    }
                    var downWall = CGRect(x: position.x - CGFloat(tileSize / 2), y: position.y + CGFloat(tileSize / 2), width: CGFloat(tileSize), height: CGFloat(-verticalLength * tileSize))
                    generateWall(position, downWall, UIColor.green)
                    
                }
                else if(mazeArray[rowIndex][colIndex] == -1){
                    
                }
                else{
                    generateStar(position, starChance)
                }
                
                colIndex += 1
            }
            
            rowIndex += 1
            colIndex = 0
        }
        
        generateEntranceExit()
    }
    
    // generates the ball
    func generateBall(_ ballStartPos: (Int, Int)){
        let texture = SKTexture(image: currentSkin.skin)
        
        ballObject = SKSpriteNode(texture: texture)
        ballObject.size = CGSize(width: 44, height: 44)
        ballObject.position = CGPoint(x: ballStartPos.0, y: ballStartPos.1)
        ballObject.physicsBody = SKPhysicsBody(circleOfRadius: CGRectGetHeight(ballObject.frame) / 2)
        ballObject?.physicsBody?.mass = 5
        ballObject.physicsBody?.allowsRotation = true
        ballObject.physicsBody?.isDynamic = true
        ballObject.physicsBody?.categoryBitMask = Collision.ballBody
        ballObject.physicsBody?.collisionBitMask = Collision.wallBody
        ballObject.physicsBody?.contactTestBitMask = Collision.wallBody | Collision.starBody | Collision.entranceBody | Collision.finishHoleBody
        ballObject.physicsBody?.affectedByGravity = true
        
        ballObject.physicsBody?.friction = 0.5
        
        ballObject.physicsBody?.restitution = 0.0
        ballObject.physicsBody?.linearDamping = 0.0
        
        addChild(ballObject)
    }
    
    // generates the wall to block off the entrance
    func generateEntranceWall(){
        let mazeSpace = tileSize * (difficultyLevel * 4 - 1)
        let startLine = CGRect(x: mazeSpace / 2 - tileSize, y: 0 + tileSize/2, width: tileSize, height: -tileSize)
        print("Mazespace: \(mazeSpace)")
        let startWall = SKShapeNode(rect: startLine)
        startWall.fillColor = .purple
        startWall.physicsBody = SKPhysicsBody(polygonFrom:  startWall.path!)
        startWall.physicsBody?.categoryBitMask = Collision.wallBody
        startWall.physicsBody?.collisionBitMask = Collision.ballBody
        startWall.physicsBody?.contactTestBitMask = Collision.ballBody
        startWall.name = "startWall"
        startWall.physicsBody?.isDynamic = false
        addChild(startWall)
    }
    
    // generates the finish line
    func generateFinishLine(){
        let mazeSpace = tileSize * (difficultyLevel * 4 - 1)
        let finishLine = CGRect(x: mazeSpace / 2 - tileSize, y: -mazeSpace + tileSize/2 * 3, width: tileSize, height: -tileSize)
        let finishWall = SKShapeNode(rect: finishLine)
        finishWall.fillColor = .black
        finishWall.physicsBody = SKPhysicsBody(polygonFrom: finishWall.path!)
        finishWall.physicsBody?.categoryBitMask = Collision.finishHoleBody
        finishWall.physicsBody?.collisionBitMask = Collision.ballBody
        finishWall.physicsBody?.contactTestBitMask = Collision.ballBody
        finishWall.name = "finishWall"
        finishWall.physicsBody?.isDynamic = false
        addChild(finishWall)
    }
    
    // generates the walls that would block off the entrance and exit
    func generateEntranceExit(){
        generateFinishLine()
    }
    
    // generates a wall of variable length or height with fixed tile size at this position
    func generateWall(_ position: CGPoint, _ wall: CGRect, _ color: UIColor){
        let mazeWall = SKShapeNode(rect: wall)
        mazeWall.fillColor = UIColor(cgColor: currentTheme.colors[0]).edgeColors()
        mazeWall.lineWidth = 0.0
        mazeWall.alpha = 0.8
        
        mazeWall.physicsBody = SKPhysicsBody(polygonFrom: mazeWall.path!)
        mazeWall.physicsBody?.categoryBitMask = Collision.wallBody
        mazeWall.physicsBody?.collisionBitMask = Collision.ballBody
        mazeWall.physicsBody?.contactTestBitMask = Collision.ballBody
        mazeWall.name = "wall"
        mazeWall.physicsBody?.isDynamic = false
        addChild(mazeWall)
        
    }
    
    // generates a star at this position
    func generateStar(_ position: CGPoint, _ chance: Int){
        if(Int.random(in: 1...100) <= chance){
            let mazeObject = SKSpriteNode(imageNamed: "star")
            mazeObject.position = position
            mazeObject.size = CGSize(width: tileSize / 2, height: tileSize / 2)
            mazeObject.physicsBody = SKPhysicsBody(rectangleOf: mazeObject.size)
            mazeObject.physicsBody?.categoryBitMask = Collision.starBody
            mazeObject.physicsBody?.collisionBitMask = 0
            mazeObject.physicsBody?.contactTestBitMask = Collision.ballBody
            mazeObject.name = "star"
            mazeObject.physicsBody?.isDynamic = false // object is pinned
            
            mazeObject.physicsBody?.restitution = 0.0
            mazeObject.physicsBody?.friction = 0.0
            addChild(mazeObject)
        }
    }
    
    // runs when the ball collides with something else
    func didBegin(_ contact: SKPhysicsContact) {
        let ballObject = contact.bodyA.categoryBitMask == Collision.ballBody ? contact.bodyA : contact.bodyB
        let otherObject = contact.bodyB.categoryBitMask != Collision.ballBody ? contact.bodyB : contact.bodyA
        
        // Handle collision between ball and wall
        // TODO: add sfx when colliding with wall or star
        if(otherObject.categoryBitMask == Collision.wallBody) {
            //print("Player collided with a wall")
        }
        
        // handle collision between ball and star
        else if(otherObject.categoryBitMask == Collision.starBody) {
            //print("Player collected a star")
            
            otherObject.node?.removeFromParent()
            // TODO: add star to player's account
            let soundFileName = currentSound.sound.lastPathComponent
            playSound(named: soundFileName, volume: soundVolume)
        }
        else if(otherObject.categoryBitMask == Collision.finishHoleBody){
            isGameFinished = true
        }
        else{
            print("Error")
        }
    }
    
    func playSound(named soundName: String, volume: Float) {
        let soundAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: false)
        let volumeAction = SKAction.changeVolume(to: volume, duration: 0)
        let sequence = SKAction.sequence([volumeAction, soundAction])
        run(sequence)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // Add in end game logic
        var cond = false
        if (cond) {
            sceneDelegate?.triggerSegue(withIdentifier: "endGameSegue")
        }
        
        // Called before each frame is rendered
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
            cameraNode.position = ballObject.position
        }
        
        gradientObject.position = cameraNode.position
        //print(ballObject.position)
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        timeSinceGC += dt
        timeSinceStart += dt
        if(timeSinceGC > 3){
            // garbage collector tasks go here
            timeSinceGC = 0
        }
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        // once ball is below the entrance, block it off
        if(!isBelowEntrance && ballObject.position.y < CGFloat(0)){
            isBelowEntrance = true
            generateEntranceWall()
        }

        // camera stops following ball after passing through the finish line
        if(!isGameFinished){
            cameraNode.position = ballObject.position
        }
        
        self.lastUpdateTime = currentTime
    }
}
