import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    //MARK: Properties
    weak var delegate: QuestionFactoryDelegate?
    private let questions: [QuizQuestion] = [
        QuizQuestion (
            image: "The Godfather",
            text:"Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?" ,
            correctAnswer: true),
        QuizQuestion (
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    //MARK: Init
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    //MARK: Public methods
    func requestnextQuestion() { /// обьявляем функцию которая ничего не принимает и возвращает опциональную модель QuizQuestion
    guard let index = (0..<questions.count).randomElement() else { /// выбираем индекс вопроса из массива. с помощью функции randomElement выбираем случайный вопрос из всех, возвращая опционал => делаем его распаковку.
        delegate?.didReceiveNextQuestion(question: nil)
        return
        }

        let question = questions[safe:index]
        delegate?.didReceiveNextQuestion(question: question)
    }
    
}
