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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = """
            Вы правильно ответили на
            \(countOfRightAnswers ?? 0) из \(countOfQuestions ?? 0) вопросов! 😊
            """
    }
    
    override func viewWillLayoutSubviews() {
        reloadButton.layer.cornerRadius = reloadButton.frame.height / 2
    }
    
    @IBAction private func reloadButtonPressed() {
        dismiss(animated: true)
    }
}
