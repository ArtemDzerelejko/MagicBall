//
//  ViewController.swift
//  MagicBall
//
//  Created by artem on 07.11.2023.
//

import UIKit
import SpriteKit
import CoreMotion

protocol GameViewControllerDelegate: SKSceneDelegate {
    func gameWinner()
    func gameLose()
}

final class GameScene: SKScene {
    
    var ball: Ball!
    var motionManager: CMMotionManager!
    var platform: PlatformConveyor!
    var timeElapsed: TimeInterval = 0
    var gameOverNode: GameOverNode!
    var myDelegate: GameViewControllerDelegate?
    var resultGame: ResultGame!
    var isWinner = false
    
    override func didMove(to view: SKView) {
        configure()
        motionManager = CMMotionManager()
    }
    
    private func createPathForFizBody() -> CGPath {
        let path = CGMutablePath()
        let p1 = CGPoint(x: 0, y: size.height)
        let p2 = CGPoint.zero
        let p3 = CGPoint(x: size.width, y: 0)
        let p4 = CGPoint(x: size.width, y: size.height)
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p4)
        return path
    }
    
    private func createFizBodyScene() {
        let path = createPathForFizBody()
        physicsBody = SKPhysicsBody(edgeChainFrom: path)
        physicsBody?.friction = 0.2
        physicsBody?.categoryBitMask = 6
        physicsBody?.collisionBitMask = 2
        physicsBody?.contactTestBitMask = 0
        physicsWorld.contactDelegate = self
    }
    
    func startButtonPressed() {
        timer()
        createFizBodyScene()
        createBall()
        createPlatformConveyor()
        createGameOverNode()
        motionManager.startAccelerometerUpdates()
    }
    
    private func createBall() {
        let widthForBall = size.width * 0.15
        ball = Ball(size: CGSize(width: widthForBall, height: widthForBall))
        ball.position = CGPoint(x: size.width / 2, y: size.height / 1.3)
        addChild(ball)
    }
    
    private func createPlatformConveyor() {
        platform = PlatformConveyor()
        addChild(platform)
    }
    
    private func createGameOverNode() {
        gameOverNode = GameOverNode(imageNamed: Strings.gameOverImage, size: CGSize(width: size.width, height: size.height * 0.15))
        gameOverNode.position = CGPoint(x: size.width / 2, y: size.height - 50)
        addChild(gameOverNode)
    }
    
    private func createResultGame(text: String) {
        resultGame = ResultGame(text: text)
        resultGame.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(resultGame)
    }
    
    private func finish() {
        isWinner = true
        createResultGame(text: Strings.youWinText)
        deleteAllComponents()
    }
    
    private func timer() {
        let wait = SKAction.wait(forDuration: 30)
        run(wait) {
            self.finish()
        }
    }
    
    private func deleteAllComponents() {
        ball.delete()
        ball = nil
        platform.delete()
        platform = nil
        gameOverNode.delete()
        gameOverNode = nil
        resultGame.inputResultGame()
        waitResult()
    }
    
    private func waitResult() {
        let wait = SKAction.wait(forDuration: 3)
        run(wait) {
            self.removeAllActions()
            if self.isWinner {
                self.myDelegate?.gameWinner()
            } else {
                self.myDelegate?.gameLose()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            let acceleration = accelerometerData.acceleration
            let deltaX = acceleration.x * 5
            let deltaY = acceleration.y * 5
            
            physicsWorld.gravity = CGVector(dx: deltaX, dy: deltaY)
        }
    }
    
    deinit {
        print("deinit gameScene")
    }
}

extension GameScene {
    private func configure() {
        setupBackgroundImage()
    }
    
    private func setupBackgroundImage() {
        let backgroundImage = SKSpriteNode()
        backgroundImage.texture = SKTexture(image: UIImage(resource: .menuBackground))
        backgroundImage.size = size
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backgroundImage)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        createResultGame(text: Strings.youLoseText)
        deleteAllComponents()
    }
}
