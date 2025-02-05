//
//  MainMenuScene.swift
//  CityEscape
//
//  Created by Soumyadeep Chatterjee on 2/5/25.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    override func didMove(to view: SKView) {
        setupBackground()
        setupUI()
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "city_background")
        background.position = CGPoint(x:self.size.width / 2, y: self.size.height/2)
        background.size = self.size
        background.zPosition = -1
        addChild(background)
    }
    
    func setupUI() {
        let startButton = createButton(size: CGSize(width: 300, height: 100), text: "Start")
        startButton.position = CGPoint(x: size.width/2, y: size.height / 2)
        startButton.name = "startButton"
        addChild(startButton)
        
        let startLabel = createLabel(text: "Start", fontSize: 50)
        startLabel.position = CGPoint(x:0,y:-1)
        startButton.addChild(startLabel)
        
        
        let menuButton = createButton(size: CGSize(width:200, height:60), text: "Menu")
        menuButton.position = CGPoint(x: size.width/2, y: size.height / 2 - 120)
        menuButton.name = "menuButton"
        addChild(menuButton)
        
        let menuLabel = createLabel(text: "Menu", fontSize: 40)
        menuLabel.position = CGPoint(x:0,y:-2)
        menuButton.addChild(menuLabel)
        
    }
    
    func createLabel(text: String, fontSize: CGFloat) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = text
        label.fontSize = fontSize
        label.fontColor = .black
        label.verticalAlignmentMode = .center
        label.zPosition = 2
        return label
    }
    
    func createButton(size: CGSize, text: String) -> SKSpriteNode {
        let button = SKSpriteNode(color: .red, size: size)
        button.zPosition = 1
        
        let border = SKShapeNode(rectOf: size, cornerRadius: 10)
        border.strokeColor = .white
        border.lineWidth = 6
        border.zPosition = button.zPosition + 1
        button.addChild(border)
        
        return button
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "startButton" {
                print("Start Game")
                let gameScene = GameScene(size:self.size)
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 1.0))
            }
        }
    }
}
