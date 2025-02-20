
import Foundation
import SpriteKit

class MenuScene: SKScene {
    override func didMove(to view: SKView) {
        setupBackground()
        setupUI()
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "city_background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = self.size
        background.zPosition = -1
        addChild(background)
    }
    
    func setupUI() {
        let buttonSpacing: CGFloat = 120  

        let charactersButton = createButton(size: CGSize(width: 350, height: 100), text: "Characters")
        charactersButton.position = CGPoint(x: size.width / 2, y: size.height / 2 + buttonSpacing)
        charactersButton.name = "charactersButton"
        addChild(charactersButton)

        let soundButton = createButton(size: CGSize(width: 300, height: 80), text: "Sound")
        soundButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        soundButton.name = "soundButton"
        addChild(soundButton)

        let backButton = createButton(size: CGSize(width: 150, height: 60), text: "Back")
        backButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - buttonSpacing)
        backButton.name = "backButton"
        addChild(backButton)
    }

    
    func createButton(size: CGSize, text: String) -> SKSpriteNode {
        let button = SKSpriteNode(color: .red, size: size)
        button.zPosition = 1

        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = text
        label.fontSize = min(size.height / 3, 40)
        label.fontColor = .black
        label.verticalAlignmentMode = .center
        label.zPosition = button.zPosition + 1
        button.addChild(label)

        let border = SKShapeNode(rectOf: size, cornerRadius: 10)
        border.strokeColor = .white
        border.lineWidth = 6
        border.zPosition = button.zPosition + 2
        button.addChild(border)

        return button
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "charactersButton" {
                print("Characters Button Clicked")
            }
            
            if touchedNode.name == "soundButton" {
                print("Sound Button Clicked")
            }
            
            if touchedNode.name == "backButton" || touchedNode.parent?.name == "backButton"{
                let mainMenuScene = MainMenuScene(size: self.size)
                mainMenuScene.scaleMode = .aspectFill
                self.view?.presentScene(mainMenuScene, transition: SKTransition.fade(withDuration: 1.0))
            }
            
        }
        
    }
}
