//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Sowrya on 11/13/23.
//


import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var questionsCountLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var answersTableView: UITableView!
    @IBOutlet private weak var nextButton: UIButton!
    
    let viewModel = QuizViewModel()
    static let identifier = "QuizViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQuestions()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.appBackgroundColor
        nextButton.isEnabled = false
        answersTableView.dataSource = self
        answersTableView.delegate = self
        answersTableView.register(AnswerTableViewCell.nib(), forCellReuseIdentifier: AnswerTableViewCell.identifier)
        answersTableView.separatorStyle = .none
        answersTableView.allowsFocus = false
        titleLabel.textColor = UIColor.accentColor
        titleLabel.font = UIFont.titleFont
        questionsCountLabel.textColor = UIColor.accentColor
        questionsCountLabel.font = UIFont.subTitleFont
        nextButton.layer.cornerRadius = 8
        progressView.frame.origin.x = 0.0
        progressView.accessibilityLabel = ""
    }
    func getQuestions(){
        viewModel.fetchData{ result in
            if result{
                self.loadNextQuestion()
            }else{
                if let error = self.viewModel.error{
                    print(error.localizedDescription)
                }
            }
        }
    }
    private func loadNextQuestion() {
        viewModel.nextQuestion()
        nextButton.isEnabled = false
        questionsCountLabel.text = "\(viewModel.currentQuestionIndex + 1) out of \(viewModel.questions.count)"
        let progress = Float(viewModel.currentQuestionIndex) / Float(viewModel.questions.count)
        progressView.setProgress(progress, animated: true)
        answersTableView.allowsSelection = true
        if(viewModel.currentQuestionIndex + 1 == viewModel.questions.count){
            self.nextButton.setTitle("Finish", for: .normal)
        }
        questionLabel.text = viewModel.currentQuestion?.question.htmlDecoded
        answersTableView.reloadData()
    }
    @IBAction private func checkAnswer() {
        if(!viewModel.lastQuestion){
            loadNextQuestion()
        }
        else{
            let vc = storyboard?.instantiateViewController(withIdentifier: CompletedQuizViewController.identifier) as! CompletedQuizViewController
            vc.userScore = viewModel.userScore
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension QuizViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentQuestion?.incorrectAnswers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier, for: indexPath) as! AnswerTableViewCell
        if let currentQuestion = viewModel.currentQuestion{
            cell.answerLabel.text = currentQuestion.incorrectAnswers[indexPath.row].htmlDecoded
            cell.answerLabel.font = UIFont.answersFont
            cell.choiceImage.isHidden = true
            cell.mainView.layer.cornerRadius = 8
            cell.mainView.layer.shadowColor = UIColor.gray.cgColor
            cell.mainView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            cell.mainView.layer.shadowOpacity = 1.0
            cell.mainView.layer.shadowRadius = 2.0
            cell.contentView.backgroundColor = UIColor.appBackgroundColor
            cell.answerLabel.adjustsFontForContentSizeCategory = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAnswerIndex = indexPath.row
        let feedback: String
        if let selectedCell = tableView.cellForRow(at: indexPath) as? AnswerTableViewCell {
            if !viewModel.selectAnswer(forIndex: selectedAnswerIndex){
                feedback = "Incorrect! The correct answer is \(viewModel.currentQuestion?.correctAnswer ?? "") click next to continue"
                changeCellUI(for: selectedCell, isCorrect: false)
                if let index = viewModel.currentQuestion?.correctAnswerIndex{
                    let index = IndexPath(row: index, section: 0)
                    if let correctCell = tableView.cellForRow(at: index) as? AnswerTableViewCell{
                        changeCellUI(for: correctCell, isCorrect: true)
                    }
                }
                
            }else{
                feedback = "Correct answer! click next to continue"
                changeCellUI(for: selectedCell, isCorrect: true)
            }
            
            UIAccessibility.post(notification: .announcement, argument: feedback)
            
        }
        nextButton.isEnabled = true
        tableView.allowsSelection = false
    }
    func changeCellUI(for cell: AnswerTableViewCell,isCorrect:Bool){
        if isCorrect{
            cell.choiceImage.isHidden = false
            cell.choiceImage.image = UIImage(systemName: "checkmark.circle.fill")
            cell.choiceImage.tintColor = UIColor.appGreencolor
            cell.mainView.layer.shadowColor = UIColor.appGreencolor.cgColor
            cell.mainView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            cell.mainView.layer.shadowOpacity = 1.0
            cell.mainView.layer.shadowRadius = 2.0
        }else{
            cell.choiceImage.isHidden = false
            cell.choiceImage.image = UIImage(systemName: "multiply.circle.fill")
            cell.choiceImage.tintColor = UIColor.red
            cell.mainView.layer.shadowColor = UIColor.red.cgColor
            cell.mainView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            cell.mainView.layer.shadowOpacity = 1.0
            cell.mainView.layer.shadowRadius = 2.0
        }
    }
}
