//
//  Uicolors+Extensions.swift
//  QuizApp
//
//  Created by Sowrya on 11/13/23.
//

import Foundation
import UIKit

extension UIColor {
    static var accentColor: UIColor {
        return UIColor(named: "AccentColor") ?? UIColor(red: 0.620, green: 0.420, blue: 0.576, alpha: 1)
    }

    static var appBackgroundColor: UIColor {
        return UIColor(red: 0.984313, green: 0.929411, blue: 0.8470588, alpha: 1)
    }
    static var appGreencolor: UIColor{
        return UIColor(red: 0, green: 0.8, blue: 0, alpha: 1)
    }
}

