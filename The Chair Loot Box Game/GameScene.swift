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


//enum CollisionTypes: UInt32 {
//    case player = 1
//    case alienChair = 2
//    case blastHit = 3
//}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            self.scoreLabel.text = "Score: \(self.score)"
        }
    }
    var gameOver = false
    var player: SKSpriteNode!
    
    var gameTimer: Timer!
    
    let alienCategory: UInt32 = 0x1 << 1
    let blasterCategory: UInt32 = 0x1 << 1
    let playerCategory: UInt32 = 0x1 << 1
    
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    
    override func didMove(to view: SKView) {
        if !gameOver {
            player = SKSpriteNode(imageNamed: "Spaceship.png")
            player.size = CGSize(width: 75.0, height: 75.0)
            player.position = CGPoint(x: 0, y: -500)
            
            player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/1.5)
            player.physicsBody?.categoryBitMask = playerCategory
            player.physicsBody?.contactTestBitMask = alienCategory
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
            
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addChairAlien), userInfo: nil, repeats: true)
            
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data: CMAccelerometerData?, error: Error?) in
                if let accelerometerData = data {
                    let acceleration = accelerometerData.acceleration
                    self.xAcceleration = CGFloat(acceleration.x * 0.75 + self.xAcceleration * 0.25)
                }
            }
        }
    }
    
//    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//    
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//    
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBlast()
    }
    
    @objc func addChairAlien() {
        if !gameOver {
            let alien = SKSpriteNode(imageNamed: "ChairAlien.png")
            alien.size = CGSize(width: 75.0, height: 75.0)
            let randomAlienPosition = GKRandomDistribution(lowestValue: -300, highestValue: 300)
            
            let position = CGFloat(randomAlienPosition.nextInt())
            
            alien.position = CGPoint(x: position, y: (self.view?.frame.size.height ?? 10) + alien.size.height)
            
            alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
            alien.physicsBody?.isDynamic = true
            
            alien.physicsBody?.categoryBitMask = alienCategory
            alien.physicsBody?.contactTestBitMask = blasterCategory | playerCategory
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
            blastNode.size = CGSize(width: 50.0, height: 50.0)
            blastNode.position = player.position
            blastNode.position.y += 5
            blastNode.physicsBody = SKPhysicsBody(circleOfRadius: blastNode.size.width / 2)
            blastNode.physicsBody?.isDynamic = true
            blastNode.physicsBody?.categoryBitMask = blasterCategory
            blastNode.physicsBody?.contactTestBitMask = alienCategory
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
        
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
//        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
//            print("inif")
//        }
//        else {
//            print("inelse")
//            secondBody = contact.bodyA
//            firstBody = contact.bodyB
//        }
        
        /*if firstBody.categoryBitMask == blasterCategory && secondBody.categoryBitMask == alienCategory {
            blastCollideWithChair(blast: firstBody.node as! SKSpriteNode, alien: secondBody.node as! SKSpriteNode)
            print("blastChair")
        } else */if firstBody.categoryBitMask == playerCategory && secondBody.categoryBitMask == alienCategory {
            playerCollided(with: firstBody.node as! SKSpriteNode)
            print("playerAlien")
        } else if secondBody.categoryBitMask == playerCategory && firstBody.categoryBitMask == alienCategory {
            playerCollided(with: secondBody.node as! SKSpriteNode)
            print("AlienPlayer")
        }
            
    }
    func blastCollideWithChair(blast:SKSpriteNode, alien:SKSpriteNode) {
        blast.removeFromParent()
        alien.removeFromParent()
        score += 5
    }
    func playerCollided(with node: SKSpriteNode) {
        gameOver = true
        node.removeFromParent()
    }
    override func didSimulatePhysics() {
        player.position.x += xAcceleration * 50
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        }
        else if player.position.x > self.size.width + 20 {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !gameOver {
            // Called before each frame is rendered
            score += 1
        }
    }
}
