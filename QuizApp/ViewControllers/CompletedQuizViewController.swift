//
//  CompletedQuizViewController.swift
//  QuizApp
//
//  Created by Sowrya on 11/13/23.
//

import UIKit

class CompletedQuizViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var userScore:Int = 0
    static let identifier = "CompletedQuizViewController"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        if let navigationController = navigationController{
            var navigationArray = navigationController.viewControllers
            navigationArray.remove(at: 1)
            navigationController.viewControllers = navigationArray
            navigationController.popViewController(animated: true)
        }
    }
    
    
    func setupUi(){
        view.backgroundColor = UIColor.appBackgroundColor
        titleLabel.textColor = UIColor.accentColor
        titleLabel.font = UIFont.titleFont
        subtitleLabel.textColor = UIColor.accentColor
        subtitleLabel.font = UIFont.subTitleFont
        scoreLabel.text = "Your score is \(userScore)"
        scoreLabel.font = UIFont.subTitleFont
        scoreLabel.textColor = UIColor.accentColor
    }
}
