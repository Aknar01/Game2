//
//  ViewController.swift
//  FirstApp
//
//  Created by Aknar Assanov on 19.05.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gameFieldView: GameFieldView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameControl: GameControlViewClass!
    func actionButtonTapped( ) {
        if gameControl.isGameActive {
            stopGame()
        } else {
            startGame()
        }
    }
    func objectTapped( ) {
        guard gameControl.isGameActive else { return }
        repositionImageWithTimer()
        score += 10
    }
    
    
    
    private var gameTimer: Timer?
    private var timer: Timer?
    private let displayDuration: TimeInterval = 2
    private var score = 0
    
    private func startGame() {
        score = 0
        repositionImageWithTimer()
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(gameTimerTick),
            userInfo: nil,
            repeats: true)
        gameControl.gameTimeLeft = gameControl.gameDuration
        gameControl.isGameActive = true
        updateUI()
    }
    
    private func stopGame() {
        gameControl.isGameActive = false
        updateUI()
        gameTimer?.invalidate()
        timer?.invalidate()
        scoreLabel.text = "Последний счет: \(score)"
    }
    
    private func repositionImageWithTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: displayDuration,
            target: self,
            selector: #selector(moveImage),
            userInfo: nil,
            repeats: true
        )
        timer?.fire()
    }
    
    private func updateUI() {
        gameFieldView.isShapeHidden = !gameControl.isGameActive
    }
    
    @objc private func gameTimerTick() {
        gameControl.gameTimeLeft -= 1
        if gameControl.gameTimeLeft <= 0 {
            stopGame()
        } else {
        updateUI()
        }
    }
    
    @objc private func moveImage() {
        gameFieldView.randomizeShapes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameFieldView.layer.borderWidth = 1
        gameFieldView.layer.borderColor = UIColor.gray.cgColor
        gameFieldView.layer.cornerRadius = 15
        updateUI()
        gameFieldView.shapeHitHandler = { [weak self] in self?.objectTapped()
        }
        gameControl.startStopHandler = { [weak self] in self?.actionButtonTapped()
        }
        gameControl.gameDuration = 20
    }
}

