//
//  StartViewController.swift
//  BrainBooster
//
//  Created by Vsevolod Lashin on 28.04.2023.
//

import UIKit

final class StartViewController: UIViewController {

    @IBOutlet private var buttonStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        for subview in buttonStackView.arrangedSubviews {
            subview.layer.cornerRadius = subview.frame.height / 2
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let questionVC = segue.destination as? QuestionViewController else { return }
        
        questionVC.questions = Question.getQuestions(answers: sender as? [String] ?? [""])
    }
    
    @IBAction func themeButtonPressed(_ sender: UIButton) {
        if sender.currentTitle == "Страны" {
            performSegue(withIdentifier: "showQuestions", sender: Answer.shared.flags)
        } else if sender.currentTitle == "Кино" {
            performSegue(withIdentifier: "showQuestions", sender: Answer.shared.movies)
        }
    }
    
}
