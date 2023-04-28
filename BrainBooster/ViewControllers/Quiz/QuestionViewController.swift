//
//  QuestionViewController.swift
//  BrainBooster
//
//  Created by Vsevolod Lashin on 28.04.2023.
//

import UIKit

final class QuestionViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private var buttonsStackView: UIStackView!
    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private var imageView: UIImageView!
    
    var questions: [Question]!
    var questionType: Mode!
    
    // MARK: - Private properties
    private var questionIndex = 0
    private let countOfQuestions = 10
    private var timerIsOn = false
    private var countOfRightAnswers = 0
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillLayoutSubviews() {
        guard let buttons = buttonsStackView.arrangedSubviews as? [UIButton] else { return }
        
        for button in buttons {
            button.layer.cornerRadius = button.frame.height / 5
        }
        
        imageView.layer.cornerRadius = imageView.frame.height / 15
        imageView.layer.borderWidth = 1
    }
    
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultViewController else { return }
        
        resultVC.countOfRightAnswers = countOfRightAnswers
        resultVC.countOfQuestions = countOfQuestions
        resultVC.questionType = questionType
    }
    
    // MARK: - Unwind for segue
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        questionIndex = 0
        countOfRightAnswers = 0
        questions = questions.shuffled()
        updateUI()
    }
    
    // MARK: - IBActions
    @IBAction private func answerButtonPressed(_ sender: UIButton) {
        guard let buttons = buttonsStackView.arrangedSubviews as? [UIButton] else { return }
        guard !timerIsOn else { return }
        
        timerIsOn = true
        let question = questions[questionIndex]
        
        if sender.currentTitle == question.rightAnswer {
            sender.backgroundColor = .green
            countOfRightAnswers += 1
        } else {
            sender.backgroundColor = .red
        }
        
        for button in buttons {
            if button.currentTitle == question.rightAnswer && button.backgroundColor != .green {
                button.backgroundColor = .green
                break
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            self.timerIsOn = false
            self.nextQuestion()
        }
    }
    
    // MARK: - Private functions
    private func updateUI() {
        guard let buttons = buttonsStackView.arrangedSubviews as? [UIButton] else { return }
        
        let question = questions[questionIndex]
        
        for (button, answer) in zip(buttons, question.answers) {
            button.backgroundColor = .systemBlue
            button.setTitle(answer, for: .normal)
        }
        
        let progress = Float(questionIndex) / Float(countOfQuestions)
        progressView.setProgress(progress, animated: true)
        
        let image = question.image
        imageView.image = UIImage(named: image)
    }
    
    private func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < countOfQuestions {
            updateUI()
        } else {
            performSegue(withIdentifier: "showResult", sender: nil)
        }
    }
}
