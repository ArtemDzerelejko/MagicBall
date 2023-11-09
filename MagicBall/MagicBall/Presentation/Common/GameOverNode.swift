//
//  GameOverNode.swift
//  MagicBall
//
//  Created by artem on 07.11.2023.
//

import SpriteKit

class GameOverNode: SKSpriteNode {
    
    init(imageNamed: String, size: CGSize) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .clear, size: size)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit gameOverNode")
    }
}

extension GameOverNode {
    private func configure() {
        createPhysicBody()
    }
    
    private func createPhysicBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = 8
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = 2
    }
    
    func delete() {
        let fadeAlpha = SKAction.fadeAlpha(to: 0, duration: 0.5)
        run(fadeAlpha) {
            self.physicsBody = nil
            self.removeFromParent()
        }
    }
}
