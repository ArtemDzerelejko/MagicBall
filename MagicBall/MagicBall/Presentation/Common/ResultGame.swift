//
//  Result.swift
//  MagicBall
//
//  Created by artem on 09.11.2023.
//

import Foundation
import SpriteKit

class ResultGame: SKSpriteNode {
    
    private var text = ""
    
    init(text: String) {
        super.init(texture: nil, color: .clear, size: .zero)
        self.text = text
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit resultGame")
    }
}

extension ResultGame {
    private func configure() {
        setupResultGame()
        createLabel()
        alpha = 0
    }
    
    private func setupResultGame() {
        let tex = SKTexture(image: UIImage(resource: .resultView))
        texture = tex
        
        let ratio = tex.size().width / tex.size().height
        size.width = UIScreen.main.fixedCoordinateSpace.bounds.width * 0.8
        size.height = size.width / ratio
    }
    
    private func createLabel() {
        let label = SKLabelNode()
        label.text = text
        label.fontColor = SKColor.white
        label.fontName = "Helvetica-Bold"
        label.position.y = -size.height / 6
        
        addChild(label)
    }
    
    func inputResultGame() {
        let wait = SKAction.wait(forDuration: 0.5)
        let input = SKAction.fadeAlpha(to: 1, duration: 0.3)
        let sequence = SKAction.sequence([wait, input])
        run(sequence)
    }
}
