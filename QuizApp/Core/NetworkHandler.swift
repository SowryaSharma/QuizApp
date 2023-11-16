//
//  NetworkHandler.swift
//  QuizApp
//
//  Created by Sowrya on 11/13/23.
//

import Foundation

class NetworkHandler{
    static func makeRequest(url: URL, body: [String: Any]? = nil, method: HTTPMethod, completionHandler: @escaping (Result<(Data, HTTPURLResponse), NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            if 200...299 ~= httpResponse.statusCode {
                if let data = data {
                    completionHandler(.success((data, httpResponse)))
                } else {
                    completionHandler(.failure(.invalidData))
                }
            } else {
                completionHandler(.failure(.requestFailed(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil))))
            }
        }
        task.resume()
    }
}
