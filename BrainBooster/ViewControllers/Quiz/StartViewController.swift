//
//  StartViewController.swift
//  BrainBooster
//
//  Created by Vsevolod Lashin on 28.04.2023.
//

import UIKit

final class StartViewController: UIViewController {

    @IBOutlet private var buttonStackView: UIStackView!
    
    override func viewWillLayoutSubviews() {
        for subview in buttonStackView.arrangedSubviews {
            subview.layer.cornerRadius = subview.frame.height / 5
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let questionVC = segue.destination as? QuestionViewController else { return }
        
        var questionType: Mode!
        if sender as? [String] == Answer.shared.flags {
            questionType = .flags
        } else if sender as? [String] == Answer.shared.movies {
            questionType = .movies
        }
        
        questionVC.questions = Question.getQuestions(answers: sender as? [String] ?? [""])
        questionVC.questionType = questionType
    }
    
    @IBAction func themeButtonPressed(_ sender: UIButton) {
        if sender.currentTitle == "Страны" {
            performSegue(withIdentifier: "showQuestions", sender: Answer.shared.flags)
        } else if sender.currentTitle == "Кино" {
            performSegue(withIdentifier: "showQuestions", sender: Answer.shared.movies)
        }
    }
    
}
