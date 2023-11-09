//
//  Ball.swift
//  MagicBall
//
//  Created by artem on 07.11.2023.
//

import Foundation
import SpriteKit

class Ball: SKSpriteNode {
    
    static var width: CGFloat = 0
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        Ball.width = size.width
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit ball")
    }
}

// MARK: - configure Ball
extension Ball {
    private func configure() {
        setupTexture()
        setupFizBody()
    }
    
    private func setupTexture() {
        let tex = SKTexture(image: UIImage(resource: .pngw))
        texture = tex
    }
    
    private func setupFizBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.4, center: CGPoint(x: 0, y: size.height * (-0.03)))
        physicsBody?.friction = 0.5
        physicsBody?.mass = 10
        physicsBody?.categoryBitMask = 2
        physicsBody?.collisionBitMask = 4 | 6
        physicsBody?.contactTestBitMask = 8
    }
    
    func delete() {
        let scaleSmall = SKAction.scale(to: 0, duration: 0.3)
        run(scaleSmall) {
            self.physicsBody = nil
            self.removeFromParent()
        }
    }
}
