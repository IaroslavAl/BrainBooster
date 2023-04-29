//
//  NumberMemoryMediumViewController.swift
//  BrainBooster
//
//  Created by Iaroslav Beldin on 27.04.2023.
//

import UIKit

final class NumberMemoryMediumViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var pickerLabel: UILabel!
    @IBOutlet var timerPicker: UIPickerView!
    @IBOutlet var numberTextFields: [UITextField]!
    @IBOutlet var startButton: UIButton!
    
    // MARK: - Properties
    private let timeSlots = [15, 30, 60]
    private var randomNumbers: [Int] = []
    private var score = 0
    private var countdownTime = 30
    private var currentCountdownTime = 30
    private var countdownTimer: Timer?
    
    // MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerPicker.delegate = self
        timerPicker.selectRow(1, inComponent: 0, animated: false)
        
        for textField in numberTextFields {
            textField.delegate = self
            textField.isHidden = true
            
            // Change color of placeholder
            if let placeholder = textField.placeholder {
                let attributedPlaceholder = NSAttributedString(
                    string: placeholder,
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
                )
                textField.attributedPlaceholder = attributedPlaceholder
            }
            
            (textField as? CustomTextField)?.numberMemoryMediumVC = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        overrideUserInterfaceStyle = .light
    }
    
    // MARK: - User Interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - IB Actions
    @IBAction func startButtonAction() {
        startButton.isHidden = true
        timerPicker.isHidden = true
        pickerLabel.isHidden = true
        score = 0
        timerLabel.text = ""
        
        var randomNumbers = Array(repeating: 0, count: numberTextFields.count)
        randomNumbers.indices.forEach { index in
            randomNumbers[index] = Int.random(in: 0...9)
        }
        self.randomNumbers = randomNumbers
        
        for (index, textField) in numberTextFields.enumerated() {
            textField.text = String(randomNumbers[index])
            textField.textColor = .systemBlue
            textField.isHidden = false
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {_ in
            for textField in self.numberTextFields {
                textField.text = ""
                textField.isUserInteractionEnabled = true
                self.numberTextFields.first?.becomeFirstResponder()
            }
            self.startCountdownTimer()
        }
    }
    
    // MARK: - Methods
    // Return to previous textfield on backspace click
    func deleteBackward(_ textField: UITextField) {
        if let index = numberTextFields.firstIndex(of: textField),
           index > 0,
           textField.text == "" {
            let previousTextField = numberTextFields[index - 1]
            previousTextField.becomeFirstResponder()
            previousTextField.text = ""
        }
    }
    
    private func checkNumbers() {
        var enteredNumbers: [Int] = []
        
        for (index, textField) in numberTextFields.enumerated() {
            if let text = textField.text, let number = Int(text) {
                enteredNumbers.append(number)
                if enteredNumbers[index] == randomNumbers[index] {
                    textField.textColor = .systemGreen
                    score += 1
                } else {
                    textField.textColor = .systemRed
                }
            }
            textField.isUserInteractionEnabled = false
            textField.text = String(randomNumbers[index])
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
            for textField in self.numberTextFields {
                textField.text = ""
            }
            
            self.currentCountdownTime == 0
            ? self.finish()
            : self.nextNumbers()
        }
    }
    
    private func nextNumbers() {
        var randomNumbers = Array(repeating: 0, count: numberTextFields.count)
        
        randomNumbers.indices.forEach { index in
            randomNumbers[index] = Int.random(in: 0...9)
        }
        
        self.randomNumbers = randomNumbers
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
            for (index, textField) in self.numberTextFields.enumerated() {
                textField.textColor = .systemBlue
                textField.text = String(randomNumbers[index])
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {_ in
                for textField in self.numberTextFields {
                    textField.text = ""
                    textField.isUserInteractionEnabled = true
                }
                self.numberTextFields.first?.becomeFirstResponder()
            }
        }
    }
    
    private func restart() {
        stopCountDownTimer()
        
        startButton.isHidden = false
        timerPicker.isHidden = false
        pickerLabel.isHidden = false
        timerLabel.text = ""
        
        for textField in self.numberTextFields {
            textField.text = ""
            textField.isUserInteractionEnabled = false
            textField.isHidden = true
        }
    }
    
    private func finish() {
        timerLabel.text = "Your score\n \(score)"
        updateRecord(for: .numberMemory, mode: .medium, timeType: countdownTime, score: score)
        
        for textField in self.numberTextFields {
            textField.isHidden = true
        }
        
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) {_ in
            self.startButton.isHidden = false
            self.timerPicker.isHidden = false
            self.pickerLabel.isHidden = false
            self.timerLabel.text = ""
        }
    }
    
    private func updateRecord(for gameType: GameType, mode: Mode, timeType: Int, score: Int) {
        let dataManager = DataManager.shared
        
        if let index = dataManager.getAllGames().firstIndex(where: { $0.type == gameType && $0.mode == mode && $0.timeType == timeType }) {
            
            if let gameScore = dataManager.getAllGames()[index].score {
                if score > gameScore {
                    var gameToUpdate = dataManager.getAllGames()[index]
                    gameToUpdate.score = score
                    dataManager.updateGame(gameToUpdate, atIndex: index)
                }
            } else {
                var gameToUpdate = dataManager.getAllGames()[index]
                gameToUpdate.score = score
                dataManager.updateGame(gameToUpdate, atIndex: index)
            }
        } else {
            let newGame = Game(type: gameType, mode: mode, timeType: timeType, score: score, time: nil)
            dataManager.addGame(newGame)
        }
    }

    
    private func startCountdownTimer() {
        currentCountdownTime = countdownTime
        countdownTimer = Timer(timeInterval: 1, repeats: true) {_ in
            self.currentCountdownTime -= 1
            self.updateTimerLabel()
            if self.currentCountdownTime == 0 {
                self.stopCountDownTimer()
            }
        }
        
        timerLabel.text = "\(currentCountdownTime)"
        RunLoop.current.add(countdownTimer!, forMode: .common)
    }
    
    private func updateTimerLabel() {
        timerLabel.text = "\(currentCountdownTime)"
    }
    
    private func stopCountDownTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        timerLabel.text = "Last one"
    }
    
    func restartAlert() {
        let alert = UIAlertController(
            title: "Restart the game?",
            message: "The current progress is reset and the game will restart.",
            preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart", style: .default) {_ in
            self.restart()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(restartAction)
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension NumberMemoryMediumViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        guard let range = Range(range, in: text) else { return false }
        
        let updatedText = text.replacingCharacters(in: range, with: string)
        let maxLength = 1
        
        guard updatedText.count <= maxLength else { return false }
        
        textField.text = updatedText
        
        // Transition after entering a number to the next textfield
        if updatedText.count == maxLength {
            if let index = numberTextFields.firstIndex(of: textField),
               index < numberTextFields.count - 1 {
                
                let nextTextField = numberTextFields[index + 1]
                if nextTextField.text == "" {
                    nextTextField.becomeFirstResponder()
                }
            }
            let isAllNumber = numberTextFields.allSatisfy { $0.text?.isEmpty == false }
            if isAllNumber { checkNumbers() }
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // Added done button to keyboard
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        textField.inputAccessoryView = keyboardToolbar
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: textField,
            action: #selector(resignFirstResponder)
        )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        // Put the cursor at the end of the text field
        let newPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        
        return true
    }
}

// MARK: - UIPickerViewDelegate
extension NumberMemoryMediumViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(timeSlots[row]) sec."
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countdownTime = timeSlots[row]
        currentCountdownTime = timeSlots[row]
    }
}

// MARK: - UIPickerViewDataSource
extension NumberMemoryMediumViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        timeSlots.count
    }
}
