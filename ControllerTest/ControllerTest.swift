import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {

    var lastStepModel: QuizStepViewModel?
    var lastResultModel: QuizResultsViewModel?

    func show(quiz step: QuizStepViewModel) {
        lastStepModel = step
    }

    func show(quiz result: QuizResultsViewModel) {
        lastResultModel = result
    }

    func highlightImageBorder(isCorrectAnswer: Bool) {}

    func showLoadingIndicator() {}

    func hideLoadingIndicator() {}

    func showNetworkError(message: String) {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)

        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)

        let viewModel = sut.convert(model: question)

        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}

