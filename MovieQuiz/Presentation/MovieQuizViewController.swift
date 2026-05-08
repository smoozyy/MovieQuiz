import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var correctAnswers = 0
    private var currentQuestionIndex = 0
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        showLoadingIndicator()
        questionFactory?.loadData()
        questionFactory?.requestnextQuestion()
        statisticService = StatisticService()
        
        
    }
    
    
    // MARK: QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
        
    }
    
    // MARK: Actions
    
    @IBAction private func buttonYes(_ sender: UIButton) {
        answer(givenAnswer: true)
    
    }
    @IBAction private func buttonNo(_ sender: UIButton) {
        answer(givenAnswer: false)
    }
    
    //MARK: Private methods
    
    /// метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
    }
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    /// приватный метод, который меняет цвет рамки
    /// принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        // метод красит рамку
        if isCorrect == true {
            imageView.layer.masksToBounds = true /// даём разрешение на рисование рамки
            imageView.layer.borderWidth = 8 /// толщина рамки
            imageView.layer.borderColor = UIColor.ypGreenIOS.cgColor /// делаем рамку белой
            imageView.layer.cornerRadius = 20 /// радиус скругления углов рамки
            correctAnswers += 1
        } else {
            imageView.layer.masksToBounds = true /// даём разрешение на рисование рамки
            imageView.layer.borderWidth = 8 /// толщина рамки
            imageView.layer.borderColor = UIColor.ypRedIOS.cgColor /// делаем рамку белой
            imageView.layer.cornerRadius = 20 /// радиус скругления углов рамки
        }
        /// запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in /// добавил слабую ссылку
            guard let self = self else { return } /// добавил распаковку
            /// код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
        }
        
    }
    
    /// приватный метод, который содержит логику перехода в один из сценариев
    /// метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 { /// 1
            let text = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
            let viewModel = QuizResultsViewModel (
                title: "Этот раунд окончен!" ,
                text: text ,
                buttonText: "Сыграть еще раз")
                statisticService.store(correct: correctAnswers,total: questionsAmount)
                show(quiz: viewModel)
        } else { /// 2
            currentQuestionIndex += 1
            /// идём в состояние "Вопрос показан"
            /// убираем окрашивание рамки после цвета вопроса
            imageView.layer.borderWidth = 0
            self.questionFactory?.requestnextQuestion()
            }
        }
    
    /// приватный метод для показа результатов раунда квиза
    /// принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func show(quiz result: QuizResultsViewModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "(dd.MM.yyyy)"
        let dateFormatterString = dateFormatter.string(from:Date())
        let bestGame = statisticService.bestGame
        let alertMessage =
        "Ваш результат: \(correctAnswers)/\(questionsAmount)\n" +
        "Количество сыгранных квизов:\(statisticService.gamesCount)\n" +
        "Рекорд: \(bestGame.correct)/\(questionsAmount) \(dateFormatterString)\n" +
        "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        let model = AlertModel(title: result.title, message: alertMessage, buttonText: result.buttonText) { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
            imageView.layer.borderWidth = 0
                self.questionFactory?.requestnextQuestion()
            }
            
            alertPresenter.show(in: self, model: model)
    }

    private func showFirstQuestion() {
        guard let firstQuestion = currentQuestion else { return }
        let viewModel = convert(model: firstQuestion)
        show(quiz: viewModel)
    }
    
    private func answer(givenAnswer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false /// говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() /// включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating() 
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator() /// скрываем индикатор загрузки
        
        let errorMessage = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let buttonTryAgain = UIAlertAction(title: "Попробовать ещё раз", style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.correctAnswers = 0
            self.currentQuestionIndex = 0
            self.questionFactory?.requestnextQuestion()
        }
        errorMessage.addAction(buttonTryAgain)
        self.present(errorMessage, animated: true, completion: nil)
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) ///возьмём в качестве сообщения описание ошибки
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true /// скрываем индикатор загрузки
        questionFactory?.requestnextQuestion()
    }
}

    



    
    
    
    
    
    
    
    
    
    
