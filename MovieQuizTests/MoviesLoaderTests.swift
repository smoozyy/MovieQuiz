import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        ///Given
        let stubNetWorkClient = StubNetworkClient(emulateError: false) /// говорим что не хотим эмулировать ошибку
        let loader = MoviesLoader(networkClient: stubNetWorkClient)
        ///When
        ///так как функция загрузки явл. ассинхронной, необходимо добавить ожидание
        let expectation = expectation(description: "Loading expectation")
        loader.loadMovies { result in
            
            ///Then
            switch result {
            case.success(let movies):
                ///сравниваем данные с тем, что мы предполагали
                XCTAssertEqual(movies.items.count, 2) /// давайте проверим, что пришло, например, два фильма — ведь в тестовых данных их всего два
                expectation.fulfill()
            case.failure(_):
                ///мы не ожидаем, что пришла ошибка; если она появится то нужно будет провалить тест
                XCTFail("Unexpected failure") /// функция, которая проваливает тест
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        ///Given
        let stubNetWorkClient = StubNetworkClient(emulateError: true) /// говорим что хотим эмулировать ошибку
        let loader = MoviesLoader(networkClient: stubNetWorkClient)
        ///When
        ///так как функция загрузки явл. ассинхронной, необходимо добавить ожидание
        let expectation = expectation(description: "Loading expectation")
        loader.loadMovies { result in
            
            ///Then
            switch result {
            case.success(let movies):
                XCTFail("Unexpected failure") /// функция, которая проваливает тест
            case.failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
    }
}

