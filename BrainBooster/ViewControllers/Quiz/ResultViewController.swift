//
//  ResultViewController.swift
//  BrainBooster
//
//  Created by Vsevolod Lashin on 28.04.2023.
//

import UIKit

final class ResultViewController: UIViewController {
    
    @IBOutlet private var resultLabel: UILabel!
    @IBOutlet private var reloadButton: UIButton!
    
    var countOfRightAnswers: Int!
    var countOfQuestions: Int!
    var questionType: Mode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        updateRecord(for: .quiz, mode: questionType, countOfRightAnswers: countOfRightAnswers)

        resultLabel.text = """
            Вы правильно ответили на
            \(countOfRightAnswers ?? 0) из \(countOfQuestions ?? 0) вопросов! ✅
            """
    }
    
    override func viewWillLayoutSubviews() {
        reloadButton.layer.cornerRadius = reloadButton.frame.height / 5
    }
    
    @IBAction private func reloadButtonPressed() {
        navigationController?.viewControllers.forEach { viewController in
            if let startVC = viewController as? StartViewController {
                navigationController?.popToViewController(startVC, animated: true)
            }
        }
    }
    
    private func updateRecord(for gameType: GameType, mode: Mode, countOfRightAnswers: Int) {
        let dataManager = DataManager.shared
        let games = dataManager.getAllGames()
        
        if let index = games.firstIndex(where: { $0.type == gameType && $0.mode == mode }) {
            var gameToUpdate = games[index]
            
            if let gameScore = gameToUpdate.score, countOfRightAnswers > gameScore {
                gameToUpdate.score = countOfRightAnswers
                dataManager.updateGame(gameToUpdate, atIndex: index)
            } else if gameToUpdate.score == nil {
                gameToUpdate.score = countOfRightAnswers
                dataManager.updateGame(gameToUpdate, atIndex: index)
            }
        } else {
            let newGame = Game(type: gameType, mode: mode, score: countOfRightAnswers)
            dataManager.addGame(newGame)
        }
    }
}
