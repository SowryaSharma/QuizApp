//
//  QuizResponseModel.swift
//  QuizApp
//
//  Created by Sowrya on 11/13/23.
//

import Foundation

struct QuizResponse: Codable {
    let responseCode: Int?
    let results: [QuizQuestion]

    private enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

struct QuizQuestion: Codable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    var incorrectAnswers: [String]
    var allAnswers:[String]?
    var correctAnswerIndex:Int?
    private enum CodingKeys: String, CodingKey {
        case category
        case type
        case difficulty
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
        case allAnswers
    }
}
