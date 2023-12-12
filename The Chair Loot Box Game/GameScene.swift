//
//  GameScene.swift
//  The Chair Loot Box Game
//
//  Created by Dylan Sarell on 11/14/23.
//

import SpriteKit
import GameplayKit
import UIKit
import CoreMotion


enum CollisionTypes: UInt32 {
    case playerC = 1
    case alienChairC = 2
    case blastHitC = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            self.scoreLabel.text = "Score: \(self.score)"
        }
    }
    var gameOverLabel: SKLabelNode!
    var gameOver = false
    var player: SKSpriteNode!
    
    var gameTimer: Timer!
    var alienSpawnRate = 1.0
    
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    var lastTouchPos: CGPoint?
    
    override func didMove(to view: SKView) {
        if !gameOver {
            player = SKSpriteNode(imageNamed: "Spaceship.png")
            player.name = "player"
            player.size = CGSize(width: 75.0, height: 75.0)
            player.position = CGPoint(x: 0, y: -500)
            
            player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/1.5)
            player.physicsBody?.categoryBitMask = CollisionTypes.playerC.rawValue
            player.physicsBody?.contactTestBitMask = CollisionTypes.alienChairC.rawValue
            player.physicsBody?.collisionBitMask = 0
            self.addChild(player)
            
            self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            self.physicsWorld.contactDelegate = self
            
            scoreLabel = SKLabelNode(text: "Score: 0")
            scoreLabel.position = CGPoint(x: -100, y: 500)
            scoreLabel.fontSize = 50
            scoreLabel.fontColor = UIColor.white
            score = 0
            self.addChild(scoreLabel)
            
            gameTimer = Timer.scheduledTimer(timeInterval: alienSpawnRate, target: self, selector: #selector(addChairAlien), userInfo: nil, repeats: true)
            
//            motionManager.accelerometerUpdateInterval = 0.2
//            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data: CMAccelerometerData?, error: Error?) in
//                if let accelerometerData = data {
//                    let acceleration = accelerometerData.acceleration
//                    self.xAcceleration = CGFloat(acceleration.x * 0.75 + self.xAcceleration * 0.25)
//                }
//            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPos = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPos = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBlast()
        lastTouchPos = nil
    }
    
    @objc func addChairAlien() {
        if !gameOver {
            let alien = SKSpriteNode(imageNamed: "ChairAlien.png")
            alien.name = "chairAlien"
            alien.size = CGSize(width: 75.0, height: 75.0)
            let randomAlienPosition = GKRandomDistribution(lowestValue: -300, highestValue: 300)
            
            let position = CGFloat(randomAlienPosition.nextInt())
            
            alien.position = CGPoint(x: position, y: (self.view?.frame.size.height ?? 10) + alien.size.height)
            
            alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
            alien.physicsBody?.isDynamic = false
            
            alien.physicsBody?.categoryBitMask = CollisionTypes.alienChairC.rawValue
            alien.physicsBody?.contactTestBitMask = CollisionTypes.blastHitC.rawValue | CollisionTypes.playerC.rawValue
            alien.physicsBody?.collisionBitMask = 0
            self.addChild(alien)
            let animationDur = 6.0
            var actionArray = [SKAction]()
            actionArray.append(SKAction.move(to: CGPoint(x: position, y: -alien.size.height - 600), duration: animationDur))
            actionArray.append(SKAction.removeFromParent())
            alien.run(SKAction.sequence(actionArray))
        }
    }
    func fireBlast() {
        if !gameOver {
            //self.run(SKAction.playSoundFileNamed("sound file", waitForCompletion: false))
            let blastNode = SKSpriteNode(imageNamed: "Spaceship Blast.png")
            blastNode.name = "blastShot"
            blastNode.size = CGSize(width: 50.0, height: 50.0)
            blastNode.position = player.position
            blastNode.position.y += 5
            blastNode.physicsBody = SKPhysicsBody(circleOfRadius: blastNode.size.width / 2)
            blastNode.physicsBody?.isDynamic = true
            blastNode.physicsBody?.categoryBitMask = CollisionTypes.blastHitC.rawValue
            blastNode.physicsBody?.contactTestBitMask = CollisionTypes.alienChairC.rawValue
            blastNode.physicsBody?.collisionBitMask = 0
            blastNode.physicsBody?.usesPreciseCollisionDetection = true
            
            self.addChild(blastNode)
            
            let animationDur2 = 0.3
            var actionArray = [SKAction]()
            actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDur2))
            actionArray.append(SKAction.removeFromParent())
            blastNode.run(SKAction.sequence(actionArray))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let firstBody = contact.bodyA.node else { return }
        guard let secondBody = contact.bodyB.node else { return }
        
        if firstBody == player {
            playerCollided(with: secondBody)
        } else if secondBody == player {
            playerCollided(with: firstBody)
        } else if firstBody != player && secondBody != player {
            blastCollideWithChair(blast: firstBody, alien: secondBody)
        }
    }
    func blastCollideWithChair(blast:SKNode, alien:SKNode) {
        blast.removeFromParent()
        alien.removeFromParent()
        score += 5
    }
    func playerCollided(with node: SKNode) {
        if node.name == "chairAlien" {
            gameEnd()
            node.removeFromParent()
            player.removeFromParent()

        }
        else if node.name == "blastShot" {
            return
        }
    }
    override func didSimulatePhysics() {
        player.position.x += xAcceleration * 50
        if player.position.x < -300 {
            player.position = CGPoint(x: 300, y: player.position.y)
        }
        else if player.position.x > 300 {
            player.position = CGPoint(x: -300, y: player.position.y)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !gameOver {
            #if targetEnvironment(simulator)
            // Called before each frame is rendered
            if let lastTouchPos = lastTouchPos {
                let diff = CGPoint(x: lastTouchPos.x - player.position.x, y: lastTouchPos.y - player.position.y)
                physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: 0)
            }
            #else
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data: CMAccelerometerData?, error: Error?) in
                if let accelerometerData = data {
                    let acceleration = accelerometerData.acceleration
                    self.xAcceleration = CGFloat(acceleration.x * 0.75 + self.xAcceleration * 0.25)
                }
            }
            #endif
            score += 1
 //           if score > 500 {
 //               alienSpawnRate = 0.01
 //           }
        }
    }
    func gameEnd() {
        gameOver = true
        gameOverLabel = SKLabelNode(text: "Game Over!")
        gameOverLabel.position = CGPoint(x: 0, y: 0)
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = UIColor.green
        self.addChild(gameOverLabel)
        if let gameMoney = UserDefaults.standard.string(forKey: "LootBoxMoney") {
            var gameScore = (Int(gameMoney) ?? 0)
            gameScore += score
            UserDefaults.standard.setValue(gameScore, forKey: "LootBoxMoney")
        }
        else {
            UserDefaults.standard.setValue(score, forKey: "LootBoxMoney")
        }
    }
}
