import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var gameOverDisplayed = false
    var isPausedGame = false
    var backgroundImages = ["first_background", "second_background", "third_background", "fourth_background"]
    var currentBackgroundIndex = 0
    var score = 0
    var scoreLabel: SKLabelNode!
    var pauseButton: SKSpriteNode!

    var character: SKSpriteNode!
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!

    let jumpForce: CGFloat = 140.0
    var isOnGround = true

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self

        let spawn = SKAction.run { [weak self] in self?.spawnObstacle() }
        let delay = SKAction.wait(forDuration: 2.5)
        let spawnSequence = SKAction.sequence([spawn, delay])
        let repeatSpawn = SKAction.repeatForever(spawnSequence)
        run(repeatSpawn)

        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 50)
        scoreLabel.zPosition = 5
        addChild(scoreLabel)

        setupBackground()
        setupGround()
        setupCharacter()
        startBackgroundScrolling()
        
        setupPauseButton()
    }

    func setupPauseButton() {
        pauseButton = SKSpriteNode(imageNamed: "pause_icon")
        pauseButton.position = CGPoint(x: size.width - 50, y: size.height - 50)
        pauseButton.size = CGSize(width: 60, height: 60)
        pauseButton.zPosition = 5
        pauseButton.name = "pauseButton"
        addChild(pauseButton)
    }

    func togglePause() {
        isPausedGame.toggle()

        if isPausedGame {
            scene?.isPaused = true
            pauseButton.texture = SKTexture(imageNamed: "play_icon")
        } else {
            scene?.isPaused = false
            pauseButton.texture = SKTexture(imageNamed: "pause_icon")
        }
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

    func updateBackground() {
        if currentBackgroundIndex < backgroundImages.count - 1 {
            currentBackgroundIndex += 1
            let newBackgroundTexture = SKTexture(imageNamed: backgroundImages[currentBackgroundIndex])

            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let fadeIn = SKAction.fadeIn(withDuration: 0.5)
            let changeTexture = SKAction.run {
                self.background1.texture = newBackgroundTexture
                self.background2.texture = newBackgroundTexture
            }

            let sequence = SKAction.sequence([fadeOut, changeTexture, fadeIn])
            background1.run(sequence)
            background2.run(sequence)
        }
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
        addChild(obstacle)
        
        let moveLeft = SKAction.moveBy(x: -size.width - obstacle.size.width, y: 0, duration: 4.0)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveLeft, remove])
        
        obstacle.run(sequence)
        
        if Int.random(in: 0..<5) == 0 {
            let powerUp = PowerUp.createPowerUp()
            powerUp.position = CGPoint(x: size.width + powerUp.size.width, y: size.height * 0.3)
            addChild(powerUp)
            powerUp.run(sequence)
        }
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
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)

            if touchedNode.name == "pauseButton" {
                togglePause()
                return
            }
        }

        if isPausedGame { return }

        if isOnGround {
            character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpForce))
            isOnGround = false
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if isPausedGame { return }

        score += 1
        scoreLabel.text = "Score: \(score)"
        
        if score % 1000 == 0 {
            updateBackground()
        }

        if score % 3000 == 0 {
            increaseDifficulty()
        }
    }
    
    func increaseDifficulty() {
        print("Increasing Difficulty!")

        let newDuration = max(2.0, 4.0 - Double(score) / 5000)
        let newDelay = max(1.5, 2.5 - Double(score) / 8000)

        removeAllActions()
        
        let spawn = SKAction.run { [weak self] in self?.spawnObstacle() }
        let delay = SKAction.wait(forDuration: newDelay)
        let spawnSequence = SKAction.sequence([spawn, delay])
        let repeatSpawn = SKAction.repeatForever(spawnSequence)
        run(repeatSpawn)

        print("New Obstacle Speed: \(newDuration) sec, New Spawn Rate: \(newDelay) sec")
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
            print("Game Over! Showing message before returning to Start Menu...")
            showGameOverScreen()
        }
        
        if (bodyA.categoryBitMask == 8 && bodyB.categoryBitMask == 2) ||
           (bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 8) {

            let powerUpNode = bodyA.categoryBitMask == 8 ? bodyA.node : bodyB.node

            if let powerUpNode = powerUpNode {
                applyPowerUp(powerUpNode)
                powerUpNode.removeFromParent()
            }
        }


    }
    
    func applyPowerUp(_ node: SKNode) {
        if node.name == "speed_boost" {
            print("✅ Speed Boost Activated!")
            character.physicsBody?.velocity.dx += 200

        } else if node.name == "invincibility" {
            print("✅ Invincibility Activated!")
            
            character.physicsBody?.contactTestBitMask = 0
            
            run(SKAction.sequence([
                SKAction.wait(forDuration: 5.0),
                SKAction.run {
                    print("❌ Invincibility Expired!")
                    self.character.physicsBody?.contactTestBitMask = 4
                }
            ]))
        }
    }


    
    func showGameOverScreen() {
        if gameOverDisplayed { return }
        gameOverDisplayed = true

        let gameOverLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 60
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOverLabel.zPosition = 5
        addChild(gameOverLabel)

        let wait = SKAction.wait(forDuration: 2.0)
        let transitionToMenu = SKAction.run { [weak self] in
            self?.goToStartMenu()
        }

        let sequence = SKAction.sequence([wait, transitionToMenu])
        run(sequence)
    }


    func goToStartMenu() {
        let menuScene = MainMenuScene(size: self.size)
        menuScene.scaleMode = .aspectFill
        self.view?.presentScene(menuScene, transition: SKTransition.crossFade(withDuration: 1.0))
    }


}

