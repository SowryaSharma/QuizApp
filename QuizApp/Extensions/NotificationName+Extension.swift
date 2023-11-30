//
//  NotificationName+Extension.swift
//  QuizApp
//
//  Created by admin on 11/30/23.
//

import Foundation

extension Notification.Name{
    static var quizModelNotificationName:Notification.Name = {
        return Notification.Name("quizModelNotificationName")
    }()
}
