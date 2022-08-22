//
//  QuestionViewController.swift
//  PersonalityQuiz
//
//  Created by Vova on 21.08.22.
//

import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet weak var singlButton1: UIButton!
    @IBOutlet weak var singlButton2: UIButton!
    @IBOutlet weak var singlButton3: UIButton!
    @IBOutlet weak var singlButton4: UIButton!

    @IBOutlet weak var multipleStackView: UIStackView!
    @IBOutlet weak var multiLabel1: UILabel!
    @IBOutlet weak var multiLabel2: UILabel!
    @IBOutlet weak var multiLabel3: UILabel!
    @IBOutlet weak var multiLabel4: UILabel!
    @IBOutlet weak var multiSwitch1: UISwitch!
    @IBOutlet weak var multiSwitch2: UISwitch!
    @IBOutlet weak var multiSwitch3: UISwitch!
    @IBOutlet weak var multiSwitch4: UISwitch!
    
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet weak var rangedLabel1: UILabel!
    @IBOutlet weak var rangedLabel2: UILabel!
    @IBOutlet weak var rangedSlider: UISlider!
    
    @IBOutlet weak var questionProgresView: UIProgressView!
    
    var questions: [Question] = [
        Question(
            text: "Which food do you like the most?",
            type: .single,
            answer: [
                Answer(text: "Steak", type: .dog),
                Answer(text: "Fish", type: .cat),
                Answer(text: "Carrots", type: .rabbit),
                Answer(text: "Corn", type: .turtle)
            ]
        ),
        
        Question(
            text: "Which activities do yo enjoy?",
            type: .multiple,
            answer: [
                Answer(text: "Swimming", type: .turtle),
                Answer(text: "Sleeping", type: .cat),
                Answer(text: "Cuddling", type: .rabbit),
                Answer(text: "Eating", type: .dog)
            ]
        ),
        
        Question(
            text: "How much du you enjoy car rides?",
            type: .ranged,
            answer: [
                Answer(text: "I dislike time", type: .cat),
                Answer(text: "I get a little nervous", type: .rabbit),
                Answer(text: "I barely notice them", type: .turtle),
                Answer(text: "I love them", type: .dog)
            ]
        )
    ]
    
    var questionIndex = 0
    var answerChosen: [Answer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        let currentAnswer = questions[questionIndex].answer
        
        switch sender {
        case singlButton1:
            answerChosen.append(currentAnswer[0])
        case singlButton2:
            answerChosen.append(currentAnswer[1])
        case singlButton3:
            answerChosen.append(currentAnswer[2])
        case singlButton4:
            answerChosen.append(currentAnswer[3])
        default:
            break
        }
        
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        let currentAnswer = questions[questionIndex].answer

        if multiSwitch1.isOn {
            answerChosen.append(currentAnswer[0])
        }
        if multiSwitch2.isOn {
            answerChosen.append(currentAnswer[1])
        }
        if multiSwitch3.isOn {
            answerChosen.append(currentAnswer[2])
        }
        if multiSwitch4.isOn {
            answerChosen.append(currentAnswer[3])
        }
        
        nextQuestion()
    }
    
    @IBAction func rengerAnswerButtonPressed() {
        let currentAnswer = questions[questionIndex].answer
        let index = Int(round(rangedSlider.value * Float(currentAnswer.count - 1)))
        
        answerChosen.append(currentAnswer[index])
        
        nextQuestion()
    }
    
    @IBSegueAction func showResults(_ coder: NSCoder) -> UIViewController? {
        return ResultsViewController(coder: coder, responses: answerChosen)
    }
    
    func updateUI() {
        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true
        
        let currentQuestion = questions[questionIndex]
        let currentAnswer = currentQuestion.answer
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        navigationItem.title = "Question #\(questionIndex)"
        questionLabel.text = currentQuestion.text
        questionProgresView.setProgress(totalProgress, animated: true)
        
        switch currentQuestion.type {
        case .single:
            updateSingleStack(using: currentAnswer)
        case .multiple:
            updateMultipleStack(using: currentAnswer)
        case .ranged:
            updateRangedStack(using: currentAnswer)
        }
    }
    
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "Results", sender: nil)
        }
    }
    
    func updateSingleStack(using answer: [Answer]) {
        singleStackView.isHidden = false
        singlButton1.setTitle(answer[0].text, for: .normal)
        singlButton2.setTitle(answer[1].text, for: .normal)
        singlButton3.setTitle(answer[2].text, for: .normal)
        singlButton4.setTitle(answer[3].text, for: .normal)
    }
    
    func updateMultipleStack(using answer: [Answer]) {
        multipleStackView.isHidden = false
        multiSwitch1.isOn = false
        multiSwitch2.isOn = false
        multiSwitch3.isOn = false
        multiSwitch4.isOn = false
        
        multiLabel1.text = answer[0].text
        multiLabel2.text = answer[1].text
        multiLabel3.text = answer[2].text
        multiLabel4.text = answer[3].text
    }
    
    func updateRangedStack(using answer: [Answer]) {
        rangedStackView.isHidden = false
        rangedSlider.setValue(0.5, animated: false)
        rangedLabel1.text = answer.first?.text
        rangedLabel2.text = answer.last?.text
    }
}
