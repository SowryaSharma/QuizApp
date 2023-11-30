//
//  QuizViewModel.swift
//  QuizApp
//
//  Created by Sowrya on 11/13/23.
//

import Foundation
import Combine
class QuizViewModel: ObservableObject{
    
    var questions: [QuizQuestion] = []
    var error:NetworkError? = nil
    var currentQuestionIndex: Int = -1
    var userScore = 0
    var lastQuestion = false

    var currentQuestion: QuizQuestion?

    func selectAnswer(forIndex selectedAnswerIndex: Int) -> Bool{
        if let correctAnswerIndex = currentQuestion?.correctAnswerIndex{
            if selectedAnswerIndex == correctAnswerIndex{
                self.userScore += 1
                return true
            }
        }
        return false
    }

    func nextQuestion() {
        currentQuestionIndex += 1
        if currentQuestionIndex < questions.count - 1 {
            var currentQuestion = questions[currentQuestionIndex]
            currentQuestion.incorrectAnswers.shuffle()
            let correctAnswerIndex = Int.random(in: 0...currentQuestion.incorrectAnswers.count)
            currentQuestion.incorrectAnswers.insert(currentQuestion.correctAnswer, at: correctAnswerIndex)
            currentQuestion.correctAnswerIndex = correctAnswerIndex
            self.currentQuestion = currentQuestion
        }else if(currentQuestionIndex == questions.count - 1){
            self.lastQuestion = true
        }
    }

    func submitQuiz() {
    }
    func fetchData(completion: @escaping (Bool) -> Void) {
        NetworkHandler.makeRequest(url: API.baseURL, method: .get) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (data, _)):
                    do {
                        let decodedData = try JSONDecoder().decode(QuizResponse.self, from: data)
                        self.questions = decodedData.results
                        completion(true)
                    } catch {
                        completion(false)
                    }
                    
                case .failure(let error):
                    self.error = error
                    completion(false)
                }
            }
        }
    }
}

