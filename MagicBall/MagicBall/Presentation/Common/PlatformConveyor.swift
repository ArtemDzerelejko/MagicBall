//
//  PlatformConveyor.swift
//  MagicBall
//
//  Created by artem on 07.11.2023.
//

import SpriteKit

class PlatformConveyor: SKNode {
    
    private var platformsArray = [SKSpriteNode]()
    
    private let platformColors = [
        UIColor.red,
        UIColor.blue,
        UIColor.green,
        UIColor.purple,
    ]
    
    override init() {
        super.init()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit platform")
    }
}

// MARK: - configure Platform
extension PlatformConveyor {
    private func configure() {
        addPlatformOnSelf()
        moveSelf()
    }
    
    private func createPlatform() -> SKSpriteNode {
        let widthScreen = UIScreen.main.fixedCoordinateSpace.bounds.width
        let randomFactor = CGFloat.random(in: 1.1..<1.5)
        let width = widthScreen - Ball.width * randomFactor
        let image = UIImage(named: "block")
        let platform = SKSpriteNode(texture: SKTexture(image: image!))
        platform.size = CGSize(width: width, height: width * 0.15)
        platform.physicsBody = SKPhysicsBody(texture: platform.texture!, size: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.friction = 0.3
        platform.physicsBody?.categoryBitMask = 4
        platform.physicsBody?.collisionBitMask = 2
        platform.physicsBody?.contactTestBitMask = 0
        let randomPosition = Int.random(in: 0...1)
        if randomPosition == 0 {
            platform.position.x = platform.size.width / 2
        } else {
            platform.position.x = UIScreen.main.fixedCoordinateSpace.bounds.width - platform.size.width / 2
        }
        addChild(platform)
        return platform
    }
    
    private func addPlatformOnSelf() {
        let platform = self.createPlatform()
        platform.position.y = -platform.size.height / 2
        platformsArray.append(platform)
        checkPositionPlatform(platform: platform)
    }
    
    func delete() {
        let fadeAlpha = SKAction.fadeAlpha(to: 0, duration: 0.5)
        run(fadeAlpha) {
            for platform in self.platformsArray {
                platform.removeAllActions()
                platform.physicsBody = nil
                platform.removeFromParent()
            }
            self.removeAllActions()
            self.removeFromParent()
        }
    }
}

// MARK: - setup PlatformConveyor
extension PlatformConveyor {
    private func moveSelf() {
        let distanseY: CGFloat = platformsArray.last!.size.height * 3.0
        let toY = position.y + distanseY
        let duration = platformsArray.last!.size.height * 0.02
        let move = SKAction.moveTo(y: toY, duration: duration)
        run(move) {
            let platform = self.createPlatform()
            platform.position.y = self.platformsArray.last!.position.y - distanseY
            self.platformsArray.append(platform)
            self.checkPositionPlatform(platform: platform)
            self.moveSelf()
        }
    }
    
    private func checkPositionPlatform(platform: SKSpriteNode) {
        if platform.position.x < UIScreen.main.fixedCoordinateSpace.bounds.width / 2 {
            animatePlatform(platform: platform)
        } else {
            animateToLeft(platform: platform)
        }
    }
    
    private func animatePlatform(platform: SKSpriteNode) {
        let duration = Double.random(in: 0.5...1)
        let move = SKAction.moveTo(x: UIScreen.main.fixedCoordinateSpace.bounds.width - platform.size.width / 2, duration: duration)
        platform.run(move) {
            self.animateToLeft(platform: platform)
        }
    }
    
    private func animateToLeft(platform: SKSpriteNode) {
        let duration = Double.random(in: 0.5...1)
        let move = SKAction.moveTo(x: platform.size.width / 2, duration: duration)
        platform.run(move) {
            self.animatePlatform(platform: platform)
        }
    }
}
