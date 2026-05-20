import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter = AlertPresenter()
        
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: Actions
    
    @IBAction private func buttonYes(_ sender: UIButton) {
        presenter.buttonYes()
    }
    @IBAction private func buttonNo(_ sender: UIButton) {
        presenter.buttonNo()
    }
    
    //MARK: Private methods
        
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20

        imageView.layer.borderColor = isCorrectAnswer
            ? UIColor.ypGreenIOS.cgColor
            : UIColor.ypRedIOS.cgColor
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = UIImage(data: step.image) ?? UIImage()
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
        
    /// приватный метод для показа результатов раунда квиза
    /// принимает вью модель QuizResultsViewModel и ничего не возвращает
    func show(quiz result: QuizResultsViewModel) {

        let model = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        ) { [weak self] in

            guard let self = self else { return }

            self.imageView.layer.borderWidth = 0

            self.presenter.restartGame()
        }

        alertPresenter.show(
            in: self,
            model: model,
            accessibilityId: "GameResult"
        )
    }
    func showLoadingIndicator() {
        activityIndicator.isHidden = false /// говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() /// включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating() 
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                guard let self = self else { return }
                self.presenter.restartGame()
            }
        )
        alertPresenter.show(in: self, model: model, accessibilityId: "NetworkErrorAlert")
    }
}


    
    
    
    
    
    
    
    
    
    
