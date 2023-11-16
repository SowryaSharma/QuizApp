//
//  Constants.swift
//  QuizApp
//
//  Created by Sowrya on 11/13/23.
//

import Foundation

struct API {
    static let baseURL = URL(string: "https://opentdb.com/api.php?amount=10&amp;category=18&amp;difficulty=easy&amp;type=multiple")!
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case invalidData
}
