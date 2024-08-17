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

// collision bitmasking
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

// functions passed to other view controllers
protocol BallProperties {
    func stopBall()
    func resumeBall()
}

class GameScene: SKScene, SKPhysicsContactDelegate, BallProperties {
    
    var sceneDelegate: GameSceneDelegate?
    var starCount = 0
    private var lastUpdateTime: TimeInterval = 0
    
    var ballObject: SKSpriteNode!
    let manager = CMMotionManager()
    let tileSize = 64
    let starChance = 25
    var difficultyLevel: Int!
    var isGameFinished = false
    var gameEnded = false
    var isBelowEntrance = false
    
    var gradientObject: SKSpriteNode!
    
    var cameraNode = SKCameraNode()
    
    // loads the camera, ball, maze, stars into the game
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.camera = cameraNode
        self.speed = 0.2
        self.lastUpdateTime = 0
        
        // set up collisions
        self.physicsWorld.contactDelegate = self
        
        // create the camera
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.xScale = 0.5
        cameraNode.yScale = 0.5
        
        // creates the ball
        let squareSize = difficultyLevel * 4 - 1
        let ballStartPos = (squareSize * 64 / 2 - 32, 100)
        generateBall(ballStartPos)
        makeSquareMaze(difficultyLevel)
        createGradient(ballStartPos)
    }
    
    // creates the gradient
    func createGradient(_ ballStartPos: (Int, Int)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = frame.size
        gradientLayer.position = CGPoint(x: ballStartPos.0, y: ballStartPos.1)
        gradientLayer.colors = currentTheme.colors

        // convert the gradient into an image
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // add the gradient as a game object
        let gradientTexture = SKTexture(image: gradientImage!)
        gradientObject = SKSpriteNode(texture: gradientTexture)
        gradientObject.size = CGSize(width: frame.width, height: frame.height)
        gradientObject.position = CGPoint(x: frame.width/2, y: frame.height/2)
        gradientObject.zPosition = -1
        addChild(gradientObject)
    }
    
    // creates a gravity manager; is used for gyro controls
    func createGravityManager(){
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
    }
    
    // makes a maze, its size depends on the entered difficult
    func makeSquareMaze(_ difficulty: Int){
        let mazeMaker = MazeMaker()
        // magic number to avoid double-walls
        let rows = difficulty * 4 - 1
        let cols = difficulty * 4 - 1
        mazeArray = mazeMaker.createMaze(rows, cols)
        loadMaze()
    }
    
    // loads the maze into the game scene
    func loadMaze() {
        var subRow = 0
        var subCol = 0
        var rowIndex = 0
        var colIndex = 0
        let mazeSize = mazeArray.count - 1
        
        // uses the mazeArray to generate the in game maze
        while(rowIndex <= mazeSize) {
            while(colIndex <= mazeSize) {
                let position = CGPoint(x: tileSize * colIndex, y: -tileSize * rowIndex)
                if(mazeArray[rowIndex][colIndex] == 1) {
                    var horizontalLength = 0
                    var verticalLength = 0
                    subCol = colIndex
                    subRow = rowIndex
                    
                    // extends the wall to the right if applicable
                    while(subCol <= mazeSize && mazeArray[rowIndex][subCol] == 1) {
                        horizontalLength += 1
                        mazeArray[rowIndex][subCol] = -1
                        subCol += 1
                    }
                    
                    let horizontalWall = CGRect(x: position.x - CGFloat(tileSize / 2), y: position.y + CGFloat(tileSize / 2), width: CGFloat(horizontalLength * tileSize), height: -CGFloat(tileSize))
                    generateWall(horizontalWall)
                    
                    mazeArray[rowIndex][colIndex] = 1
                    // extends wall downwards if applicable
                    while(subRow <= mazeSize && mazeArray[subRow][colIndex] == 1){
                        verticalLength += 1
                        mazeArray[subRow][colIndex] = -1
                        subRow += 1
                    }
                    let downWall = CGRect(x: position.x - CGFloat(tileSize / 2), y: position.y + CGFloat(tileSize / 2), width: CGFloat(tileSize), height: CGFloat(-verticalLength * tileSize))
                    generateWall(downWall)
                }
                else if(mazeArray[rowIndex][colIndex] == 0){
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
        ballObject.physicsBody?.affectedByGravity = true
        
        ballObject.physicsBody?.categoryBitMask = Collision.ballBody
        ballObject.physicsBody?.collisionBitMask = Collision.wallBody
        ballObject.physicsBody?.contactTestBitMask = Collision.wallBody | Collision.starBody | Collision.entranceBody | Collision.finishHoleBody
        
        ballObject.physicsBody?.friction = 0.5
        ballObject.physicsBody?.restitution = 0.0
        ballObject.physicsBody?.linearDamping = 0.0
        
        addChild(ballObject)
    }
    
    // stops the ball from moving
    func stopBall() {
        ballObject.physicsBody?.isDynamic = false
    }
    
    // resumes ball movement
    func resumeBall() {
        ballObject.physicsBody?.isDynamic = true
    }
    
    // generates the wall to block off the entrance
    func generateEntranceWall(){
        let mazeSpace = tileSize * (difficultyLevel * 4 - 1)
        let startLine = CGRect(x: mazeSpace / 2 - tileSize, y: 0 + tileSize/2, width: tileSize, height: -tileSize)
        let startWall = SKShapeNode(rect: startLine)
        startWall.fillColor = UIColor(cgColor: currentTheme.colors[0]).edgeColors()
        startWall.lineWidth = 0.0
        startWall.alpha = 0.8
        startWall.isHidden = true
        startWall.physicsBody = SKPhysicsBody(polygonFrom:  startWall.path!)
        startWall.physicsBody?.categoryBitMask = Collision.entranceBody
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
        finishWall.fillColor = .clear
        finishWall.strokeColor = .clear
        finishWall.physicsBody = SKPhysicsBody(polygonFrom: finishWall.path!)
        finishWall.physicsBody?.categoryBitMask = Collision.finishHoleBody
        finishWall.physicsBody?.collisionBitMask = Collision.ballBody
        finishWall.physicsBody?.contactTestBitMask = Collision.ballBody
        finishWall.name = "finishWall"
        finishWall.physicsBody?.isDynamic = false
        finishWall.fillTexture = SKTexture(imageNamed: "finish")
        addChild(finishWall)
    }
    
    // generates the walls that would block off the entrance and generates finish line
    func generateEntranceExit(){
        generateEntranceWall()
        generateFinishLine()
    }
    
    // generates a wall of variable length or height with fixed tile size at this position
    func generateWall(_ wall: CGRect){
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
    
    // runs when the ball collides or makes contact with something else
    func didBegin(_ contact: SKPhysicsContact) {
        let otherObject = contact.bodyB.categoryBitMask != Collision.ballBody ? contact.bodyB : contact.bodyA
        
        // handle collision between ball and star
        if(otherObject.categoryBitMask == Collision.starBody) {
            otherObject.node?.removeFromParent()
            starCount += 1
            sceneDelegate?.updateStarCount(to: starCount)
            
            let soundFileName = currentSound.sound.lastPathComponent
            playSound(named: soundFileName, volume: soundVolume)
        }
        else if(otherObject.categoryBitMask == Collision.finishHoleBody){
            isGameFinished = true
        }
    }
    
    // runs when the ball stops colliding or making contact with something else
    func didEnd(_ contact: SKPhysicsContact) {
        let otherObject = contact.bodyB.categoryBitMask != Collision.ballBody ? contact.bodyB : contact.bodyA
        
        if(otherObject.categoryBitMask == Collision.entranceBody) {
            otherObject.categoryBitMask = Collision.wallBody
            otherObject.node?.isHidden = false
            createGravityManager()
        }
    }
    
    // plays a sound on collision
    func playSound(named soundName: String, volume: Float) {
        let soundAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: false)
        let volumeAction = SKAction.changeVolume(to: volume, duration: 0)
        let sequence = SKAction.sequence([volumeAction, soundAction])
        run(sequence)
    }
    
    // updates the game on every frame
    override func update(_ currentTime: TimeInterval) {
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
            cameraNode.position = ballObject.position
        }
        
        gradientObject.position = cameraNode.position
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime

        // camera stops following ball after passing through the finish line
        if(!isGameFinished){
            cameraNode.position = ballObject.position
        } else if !gameEnded {
            gameEnded = true
            sceneDelegate?.triggerSegue(withIdentifier: "endGameSegue")
        }
        
        self.lastUpdateTime = currentTime
    }
}
