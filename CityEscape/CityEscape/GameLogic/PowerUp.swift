import SpriteKit

class PowerUp: SKSpriteNode {
    
    static let powerUpTextures = [
        SKTexture(imageNamed: "speed_boost"),
        SKTexture(imageNamed: "invincibility")
    ]
    
    static func createPowerUp() -> PowerUp {
        let randomIndex = Int.random(in: 0..<powerUpTextures.count)
        let texture = powerUpTextures[randomIndex]

        let powerUp = PowerUp(texture: texture)
        powerUp.setScale(0.6)
        powerUp.zPosition = 3

        powerUp.name = randomIndex == 0 ? "speed_boost" : "invincibility"

        powerUp.physicsBody = SKPhysicsBody(texture: texture, size: powerUp.size)
        powerUp.physicsBody?.isDynamic = false
        powerUp.physicsBody?.categoryBitMask = 8
        powerUp.physicsBody?.collisionBitMask = 0
        powerUp.physicsBody?.contactTestBitMask = 2  

        return powerUp
    }
}

