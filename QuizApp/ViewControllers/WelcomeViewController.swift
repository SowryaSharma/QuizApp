//
//  ViewController.swift
//  QuizApp
//
//  Created by Sowrya on 11/13/23.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpUI(){
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.appBackgroundColor
        titleLabel.textColor = UIColor.accentColor
        titleLabel.font = UIFont.titleFont
        subTitleLabel.textColor = UIColor.accentColor
        subTitleLabel.font = UIFont.subTitleFont
        nextButton.layer.cornerRadius = 24
    }
}

