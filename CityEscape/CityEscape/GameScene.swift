import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var character: SKSpriteNode!
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!
    
    let jumpForce: CGFloat = 250.0
    var isOnGround = true
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        let spawn = SKAction.run { [weak self] in self?.spawnObstacle() }
        let delay = SKAction.wait(forDuration: 2.5)
        let spawnSequence = SKAction.sequence([spawn, delay])
        let repeatSpawn = SKAction.repeatForever(spawnSequence)
        run(repeatSpawn)
        
        setupBackground()
        setupGround()
        setupCharacter()
        startBackgroundScrolling()
    }
    
    func setupBackground() {
        background1 = SKSpriteNode(imageNamed: "first_background")
        background1.position = CGPoint(x: size.width/2, y: size.height/2)
        background1.size = self.size
        background1.zPosition = -1
        addChild(background1)
        
        background2 = background1.copy() as! SKSpriteNode
        background2.position = CGPoint(x: background1.position.x + background1.size.width, y: background1.position.y)
        addChild(background2)
    }
    
    func setupGround() {
        let ground = SKSpriteNode(color: .clear, size: CGSize(width: size.width, height: 20))
        ground.position = CGPoint(x: size.width / 2, y: size.height * 0.12)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = 1
        ground.physicsBody?.collisionBitMask = 2
        ground.physicsBody?.contactTestBitMask = 2
        ground.zPosition = 1
        addChild(ground)
    }
    
    func setupCharacter() {
        character = SKSpriteNode(imageNamed: "character_run_1")
        character.position = CGPoint(x: size.width / 4, y: size.height * 0.18)
        character.setScale(0.5)
        character.zPosition = 2
        addChild(character)
        
        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        character.physicsBody?.affectedByGravity = true
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.categoryBitMask = 2
        character.physicsBody?.collisionBitMask = 1
        character.physicsBody?.contactTestBitMask = 1
        character.physicsBody?.linearDamping = 0.2
        character.physicsBody?.friction = 0.5
        
        runCharacterAnimation()
    }
    
    func runCharacterAnimation() {
        let runTextures = [
            SKTexture(imageNamed: "character_run_4"),
            SKTexture(imageNamed: "character_run_2"),
            SKTexture(imageNamed: "character_run_3"),
            SKTexture(imageNamed: "character_run_5")
        ]
        
        let runAction = SKAction.animate(with: runTextures, timePerFrame: 0.15)
        let repeatRun = SKAction.repeatForever(runAction)
        character.run(repeatRun)
    }
    
    func startBackgroundScrolling() {
        let moveLeft = SKAction.moveBy(x: -background1.size.width, y: 0, duration: 4)
        let resetPosition = SKAction.moveBy(x: background1.size.width, y: 0, duration: 0)
        let loopAction = SKAction.repeatForever(SKAction.sequence([moveLeft, resetPosition]))
        
        background1.run(loopAction)
        background2.run(loopAction)
    }
    
    func spawnObstacle() {
        let obstacle = Obstacle.createObstacle()
        obstacle.position = CGPoint(x: size.width + obstacle.size.width, y: size.height * 0.15)
        obstacle.name = "obstacle"
        addChild(obstacle)
        
        let moveLeft = SKAction.moveBy(x: -size.width - obstacle.size.width, y: 0, duration: 4.0)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveLeft, remove])
        
        obstacle.run(sequence)
    }

    func resetGame() {
        print("Game Over! Restarting...")

        character.position = CGPoint(x: size.width / 4, y: size.height * 0.2)
        character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        enumerateChildNodes(withName: "obstacle") { node, _ in
            node.removeFromParent()
        }
        
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = .aspectFill
        self.view?.presentScene(newScene, transition: SKTransition.fade(withDuration: 1.0))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOnGround {
            character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpForce))
            isOnGround = false
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2) ||
           (bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 1) {
            isOnGround = true
            character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        if (bodyA.categoryBitMask == 4 && bodyB.categoryBitMask == 2) ||
           (bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 4) {
            print("Game Over!")
            resetGame()
        }
    }
}
