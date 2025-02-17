import SpriteKit

class Obstacle: SKSpriteNode {
    
    static let obstacleTextures = [
        SKTexture(imageNamed: "obstacle_1"), // Fire Hydrant
        SKTexture(imageNamed: "obstacle_2"), // Crack
        SKTexture(imageNamed: "obstacle_3")  // Puddle
    ]
    
    static func createObstacle() -> Obstacle {
        let randomIndex = Int.random(in: 0..<obstacleTextures.count)
        let texture = obstacleTextures[randomIndex]
        
        let obstacle = Obstacle(texture: texture)
        obstacle.setScale(0.6)
        obstacle.zPosition = 2
        obstacle.name = "obstacle"
        
        obstacle.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: obstacle.size.width * 0.8, height: obstacle.size.height * 0.8))
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = 4
        obstacle.physicsBody?.collisionBitMask = 2
        obstacle.physicsBody?.contactTestBitMask = 2
        
        return obstacle
    }
}
