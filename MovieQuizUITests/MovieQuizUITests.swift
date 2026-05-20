import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication! /// - примитив приложения (переменная символизирует приложение, которое мы тестируем)
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication() /// проверка что переменная будет проинициализирована на момент использования
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    @MainActor
    func testExample() throws {
        
        let app = XCUIApplication()
        app.launch()
    }
    func testYesButton() {
        sleep(12)
        
        let firstPoster = app.images["Poster"] /// находим первоначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap() /// находим кнопку да и нажимаем на нее
        sleep(12)
        
        let secondPoster = app.images["Poster"] /// находим второй постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData) /// проверяем что постеры разные
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(12)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(12)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlertButton() {
        sleep(20)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        sleep(3)
        let alert = app.alerts["GameResult"]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    func testAlertDismiss() {
        sleep(20)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        sleep(3)
        let alert = app.alerts["GameResult"]
        alert.buttons.firstMatch.tap()
        
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}

