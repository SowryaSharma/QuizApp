//
//  QuizViewModel.swift
//  QuizApp
//
//  Created by Sowrya on 11/13/23.
//

import Foundation

class QuizViewModel{
    func fetchData(completion: @escaping (Result<[QuizQuestion], Error>) -> Void) {
        NetworkHandler.makeRequest(url: API.baseURL, method: .get) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (data, _)):
                    do {
                        let decodedData = try JSONDecoder().decode(QuizResponse.self, from: data)
                        completion(.success(decodedData.results))
                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
