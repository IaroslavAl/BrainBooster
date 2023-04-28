//
//  Question.swift
//  BrainBooster
//
//  Created by Vsevolod Lashin on 28.04.2023.
//

struct Question {
    let image: String
    let answers: [String]
    let rightAnswer: String
    
    static func getQuestions(answers: [String]) -> [Question] {
    
        let allAnswers = answers.shuffled()
        var result: [Question] = []
        var indexOfAnswer = 0
        
        for _ in allAnswers {
            let rightAnswer = allAnswers[indexOfAnswer]
            var wrongAnswers: [String] = []
            
            while wrongAnswers.count < 3 {
                let wrongAnswer = allAnswers.randomElement() ?? ""
                
                if !wrongAnswers.contains(wrongAnswer) && !wrongAnswer.contains(rightAnswer) {
                    wrongAnswers.append(wrongAnswer)
                }
            }
            
            result.append(
                Question(
                    image: rightAnswer,
                    answers: [
                        rightAnswer,
                        wrongAnswers[0],
                        wrongAnswers[1],
                        wrongAnswers[2]
                    ]
                        .shuffled(),
                    rightAnswer: rightAnswer
                )
            )
            
            indexOfAnswer += 1
        }
        
        return result
    }
}
