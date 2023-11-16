//
//  AnswerTableViewCell.swift
//  QuizApp
//
//  Created by Sowrya on 11/13/23.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var choiceImage: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    static let identifier = "AnswerTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "AnswerTableViewCell", bundle: nil)
    }
}
