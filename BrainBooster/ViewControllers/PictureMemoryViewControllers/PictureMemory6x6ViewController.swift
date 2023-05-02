//
//  PictureMemory6x6ViewController.swift
//  BrainBooster
//
//  Created by Iaroslav Beldin on 27.04.2023.
//

import UIKit

final class PictureMemory6x6ViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var cellButtons: [UIButton]!
    
    // MARK: - Properties
    private var currentPair = [""]
    private var timer: Timer?
    private var countdownTime = 0
    private var record = 0
    private let pairs = [
        ["🐶", "🐶", "🐱", "🐱", "🐰", "🐰", "🦊", "🦊", "🐻", "🐻", "🐼", "🐼", "🐯", "🐯", "🦁", "🦁", "🐮", "🐮", "🐷", "🐷", "🐸", "🐸", "🐵", "🐵", "🐥", "🐥", "🦄", "🦄", "🦋", "🦋", "🐢", "🐢", "🐙", "🐙", "🐳", "🐳"],
        ["🍏", "🍏", "🍐", "🍐", "🍊", "🍊", "🍋", "🍋", "🍌", "🍌", "🍉", "🍉", "🍇", "🍇", "🍓", "🍓", "🫐", "🫐", "🍈", "🍈", "🍒", "🍒", "🍑", "🍑", "🍍", "🍍", "🥥", "🥥", "🥝", "🥝", "🍅", "🍅", "🍆", "🍆", "🥑", "🥑"],
        ["🥩", "🥩", "🍗", "🍗", "🍖", "🍖", "🌭", "🌭", "🍔", "🍔", "🍟", "🍟", "🍕", "🍕", "🥪", "🥪", "🌮", "🌮", "🌯", "🌯", "🥗", "🥗", "🍝", "🍝", "🍣", "🍣", "🍨", "🍨", "🥧", "🥧", "🧁", "🧁", "🍰", "🍰", "🍿", "🍿"]
    ]
    
    // MARK: - View Life Circle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        overrideUserInterfaceStyle = .light
    }
    
    // MARK: - IB Actions
    @IBAction func startAction() {
        startButton.isHidden = true
        resultLabel.isHidden = true
        
        let currentPair = pairs.shuffled().first?.shuffled()
        self.currentPair = currentPair ?? [""]
        
        for (index, button) in cellButtons.enumerated() {
            button.setTitle(currentPair?[index], for: .normal)
            button.isHidden = false
        }
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [unowned self] _ in
            for cell in cellButtons {
                cell.setTitle("🟦", for: .normal)
            }
            self.startCountdownTimer()
        }
    }
    
    @IBAction func cellsAction(_ sender: UIButton) {
        let enabledCells = cellButtons.filter { isEnabledAndNotRevealed(button: $0) }
        let disabledCells = cellButtons.filter { isDisabledAndRevealed(button: $0) }
        
        // If the number of open cells is less than two, then a new cell will arrive
        if enabledCells.count < 2 {
            cellButtons[sender.tag].setTitle(currentPair[sender.tag], for: .normal)
        }
        // If two cells are open, then compare their values
        if enabledCells.count == 1 {
            // If the user clicked on the same cell as before, then do nothing
            guard enabledCells[0] != cellButtons[sender.tag] else { return }
            
            compareSelectedCells(
                firstCell: enabledCells[0],
                secondCell: cellButtons[sender.tag],
                disabledCells: disabledCells
            )
        }
    }
    
    // MARK: - Methods
    private func isEnabledAndNotRevealed(button: UIButton) -> Bool {
        return button.title(for: .normal) != "🟦" && button.isEnabled
    }
    
    private func isDisabledAndRevealed(button: UIButton) -> Bool {
        return button.title(for: .normal) != "🟦" && !button.isEnabled
    }
    
    private func compareSelectedCells(firstCell: UIButton, secondCell: UIButton, disabledCells: [UIButton]) {
        if currentPair[firstCell.tag] == currentPair[secondCell.tag] {
            firstCell.isEnabled = false
            secondCell.isEnabled = false
            
            if disabledCells.count == cellButtons.count - 2 {
                finish()
            }
        } else {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {_ in
                firstCell.setTitle("🟦", for: .normal)
                firstCell.isEnabled = true
                secondCell.setTitle("🟦", for: .normal)
                secondCell.isEnabled = true
            }
        }
    }
    
    private func finish() {
        for cell in cellButtons {
            cell.setTitle("", for: .normal)
            cell.isHidden = true
            cell.isEnabled = true
        }
        
        updateRecord(for: .pictureMemory, mode: .sixBySix, time: countdownTime)
        stopCountDownTimer()
        resultLabel.text = "Your time\n is\n \(timerLabel.text ?? "") sec."
        resultLabel.isHidden = false
        timerLabel.isHidden = true
        startButton.isHidden = false
    }
    
    private func restart() {
        timerLabel.isHidden = true
        resultLabel.isHidden = true
        startButton.isHidden = false
        
        stopCountDownTimer()
        
        for cell in cellButtons {
            cell.setTitle("", for: .normal)
            cell.isHidden = true
            cell.isEnabled = true
        }
    }
    
    private func updateRecord(for gameType: GameType, mode: Mode, time: Int) {
        let dataManager = DataManager.shared
        let games = dataManager.getAllGames()

        if let index = games.firstIndex(where: { $0.type == gameType && $0.mode == mode && $0.timeType == nil }) {
            if let gameTime = games[index].time {
                if time <= gameTime {
                    var gameToUpdate = games[index]
                    gameToUpdate.time = time
                    dataManager.updateGame(gameToUpdate, atIndex: index)
                }
            } else {
                var gameToUpdate = games[index]
                gameToUpdate.time = time
                dataManager.updateGame(gameToUpdate, atIndex: index)
            }
        } else {
            let newGame = Game(type: gameType, mode: mode, timeType: nil, score: nil, time: time)
            dataManager.addGame(newGame)
        }
    }


    
    private func startCountdownTimer() {
        countdownTime = 0
        timer = Timer(timeInterval: 1, repeats: true) { [unowned self] _ in
            countdownTime += 1
            updateTimerLabel()
        }
        
        timerLabel.text = "\(countdownTime)"
        timerLabel.isHidden = false
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func updateTimerLabel() {
        timerLabel.text = "\(countdownTime)"
    }
    
    private func stopCountDownTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func restartAlert() {
        let alert = UIAlertController(
            title: "Restart the game?",
            message: "The current progress is reset and the game will restart.",
            preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            restart()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(restartAction)
        present(alert, animated: true)
    }
}
