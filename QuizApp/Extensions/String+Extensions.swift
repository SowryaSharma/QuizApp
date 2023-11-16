//
//  String+Extensions.swift
//  QuizApp
//
//  Created by Sowrya on 11/16/23.
//

import Foundation

extension String {
    var htmlDecoded: String {
        guard let data = data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString.string
        } catch {
            print("Error decoding HTML entities: \(error)")
            return self
        }
    }
}

