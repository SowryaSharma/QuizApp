//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Sowrya on 11/13/23.
//


import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var questionsCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var answersTableView: UITableView!
    @IBOutlet private weak var nextButton: UIButton!
    
    var quizQuestions: [QuizQuestion] = []
    private var allAnswers: [String] = []
    var currentQuestionIndex = 0
    var userScore = 0
    var selectedAnswerIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQuestions()
        setupUI()
        loadNextQuestion()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.appBackgroundColor
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
        let viewModel = QuizViewModel()
        viewModel.fetchData{ [weak self] result in
            switch result {
            case .success(let questions):
                self?.quizQuestions = questions
                self?.loadNextQuestion()
            case .failure(let error):
                print("Error fetching quiz questions: \(error)")
            }
        }
    }
    private func loadNextQuestion() {
        guard currentQuestionIndex < quizQuestions.count else {
            return
        }
        //        nextButton.isEnabled = false
        questionsCountLabel.text = "\(currentQuestionIndex + 1) out of \(quizQuestions.count)"
        questionsCountLabel.accessibilityLabel = "Question \(currentQuestionIndex + 1) out of \(quizQuestions.count)"
        if(currentQuestionIndex + 1 == quizQuestions.count){
            self.nextButton.setTitle("Finish", for: .normal)
        }
        let progress = Float(currentQuestionIndex) / Float(quizQuestions.count)
        progressView.setProgress(progress, animated: true)
        answersTableView.allowsSelection = true
        let currentQuestion = quizQuestions[currentQuestionIndex]
        questionLabel.text = currentQuestion.question.htmlDecoded
        questionLabel.accessibilityLabel = "Question: \(currentQuestion.question)"
        allAnswers = currentQuestion.incorrectAnswers
        let correctAnswerIndex = Int.random(in: 0...allAnswers.count)
        allAnswers.insert(currentQuestion.correctAnswer, at: correctAnswerIndex)
        selectedAnswerIndex = nil
        answersTableView.reloadData()
    }
    @IBAction private func checkAnswer() {
        if(currentQuestionIndex < quizQuestions.count){
            loadNextQuestion()
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "CompletedQuizViewController") as! CompletedQuizViewController
            vc.userScore = userScore
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension QuizViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier, for: indexPath) as! AnswerTableViewCell
        cell.answerLabel.text = allAnswers[indexPath.row]
        cell.choiceImage.isHidden = true
        cell.mainView.layer.cornerRadius = 8
        cell.mainView.layer.shadowColor = UIColor.gray.cgColor
        cell.mainView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cell.mainView.layer.shadowOpacity = 1.0
        cell.mainView.layer.shadowRadius = 2.0
        cell.contentView.backgroundColor = UIColor.appBackgroundColor
        cell.answerLabel.accessibilityLabel = "Option \(indexPath.row + 1) out of \(allAnswers.count): \(allAnswers[indexPath.row])"
        cell.answerLabel.accessibilityHint = "Double-tap to select this answer."
        cell.accessibilityTraits = .button
        cell.answerLabel.adjustsFontForContentSizeCategory = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswerIndex = indexPath.row
        guard let selectedAnswerIndex = selectedAnswerIndex else {
            return
        }
        let currentQuestion = quizQuestions[currentQuestionIndex]
        let isCorrect = selectedAnswerIndex == allAnswers.firstIndex(of: currentQuestion.correctAnswer)
        
        if isCorrect {
            userScore += 1
        }
        let feedback: String
        if let selectedCell = tableView.cellForRow(at: indexPath) as? AnswerTableViewCell {
            if !isCorrect{
                feedback = "Incorrect! The correct answer is \(currentQuestion.correctAnswer) cliclk next to continue"
                selectedCell.choiceImage.isHidden = false
                selectedCell.choiceImage.image = UIImage(systemName: "multiply.circle.fill")
                selectedCell.choiceImage.tintColor = UIColor.red
                selectedCell.mainView.layer.shadowColor = UIColor.red.cgColor
                selectedCell.mainView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
                selectedCell.mainView.layer.shadowOpacity = 1.0
                selectedCell.mainView.layer.shadowRadius = 2.0
                if let correctAnswerIndex = allAnswers.firstIndex(of: currentQuestion.correctAnswer){
                    let index = IndexPath(row: correctAnswerIndex, section: 0)
                    if let correctCell = tableView.cellForRow(at: index) as? AnswerTableViewCell{
                        correctCell.choiceImage.isHidden = false
                        correctCell.choiceImage.image = UIImage(systemName: "checkmark.circle.fill")
                        correctCell.choiceImage.tintColor = UIColor.appGreencolor
                        correctCell.mainView.layer.shadowColor = UIColor.appGreencolor.cgColor
                        correctCell.mainView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
                        correctCell.mainView.layer.shadowOpacity = 1.0
                        correctCell.mainView.layer.shadowRadius = 2.0
                    }
                }
            }else{
                feedback = "Correct answer! click next to continue"
                selectedCell.choiceImage.isHidden = false
                selectedCell.choiceImage.image = UIImage(systemName: "checkmark.circle.fill")
                selectedCell.choiceImage.tintColor = UIColor.appGreencolor
                selectedCell.mainView.layer.shadowColor = UIColor.appGreencolor.cgColor
                selectedCell.mainView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
                selectedCell.mainView.layer.shadowOpacity = 1.0
                selectedCell.mainView.layer.shadowRadius = 2.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                UIAccessibility.post(notification: .announcement, argument: feedback)
            }
        }
        /* enable if user should select atleast one option*/
        //      nextButton.isEnabled = true
        tableView.allowsSelection = false
        currentQuestionIndex += 1
    }
}

/*
 protocol popViewControllerDelegate {
 func popCurrentViewController()
 }
 */
