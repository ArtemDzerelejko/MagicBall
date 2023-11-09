//
//  GameViewController.swift
//  MagicBall
//
//  Created by artem on 07.11.2023.
//

import Foundation
import UIKit
import SpriteKit
import WebKit

final class GameViewController: UIViewController, UIWebViewDelegate, GameViewControllerDelegate {
    
    private var scene: GameScene!
    private let gameViewModel = GameViewModel()
    private var skView: SKView!
    let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.backgroundColor = .red
    }
}

extension GameViewController {
    private func configure() {
        setupSkView()
        setupStartButton()
        createGameScene()
    }
    
    private func setupSkView() {
        skView = SKView(frame: view.bounds)
        view.addSubview(skView)
    }
    
    private func setupStartButton() {
        startButton.setImage(UIImage(resource: .gameButton), for: .normal)
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 250),
            startButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func createGameScene() {
        scene = GameScene(size: view.bounds.size)
        scene.myDelegate = self
        skView.presentScene(scene)
    }
    
    @objc func startButtonPressed() {
        startButton.removeFromSuperview()
        scene.startButtonPressed()
    }
    
    private func setupWebView(link: String) {
        let webView = WKWebView(frame: view.bounds)
        webView.tag = 5
        view.addSubview(webView)
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.load(request)
            skView.presentScene(nil)
            scene.myDelegate = nil
            scene = nil
            
        }
        setupButtonForWebView()
    }
    
    private func setupButtonForWebView() {
        guard let webView = view.viewWithTag(5) as? WKWebView else { return }
        let backButton = UIButton(frame: CGRect(x: 10, y: 130, width: 70, height: 50))
        backButton.setImage(UIImage(resource: .backArrow), for: .normal)
        backButton.setTitle("", for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        webView.addSubview(backButton)
    }
}

// MARK: - action
extension GameViewController {
    @objc func goBack() {
        guard let webView = view.viewWithTag(5) as? WKWebView else { return }
        if webView.canGoBack {
            webView.goBack()
        } else {
            createGameScene()
            setupStartButton()
            closeWebView()
        }
    }
}

// MARK: - setup WebView
extension GameViewController {
    func gameWinner() {
        gameViewModel.getResult()
        gameViewModel.onResultUpdate = { [weak self] modelData in
            guard let self = self else { return }
            if let winner = modelData.winner {
                self.setupWebView(link: winner)
            }
        }
    }
    
    func gameLose() {
        gameViewModel.getResult()
        gameViewModel.onResultUpdate = { [weak self] modelData in
            guard let self = self else { return }
            if let loser = modelData.loser {
                self.setupWebView(link: loser)
            }
        }
    }
    
    func closeWebView() {
        guard let webView = view.viewWithTag(5) as? WKWebView else { return }
        webView.removeFromSuperview()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func webViewDidFinishLoad(_ webView: WKWebView) { }
    
    func webView(_ webView: WKWebView, didFailLoadWithError error: Error) { }
}
