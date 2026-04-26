import UIKit
final class StatisticService{
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case gamesCount          /// Для счётчика сыгранных игр
        case bestGameCorrect     /// Для количества правильных ответов в лучшей игре
        case bestGameTotal       /// Для общего количества вопросов в лучшей игре
        case bestGameDate        /// Для даты лучшей игры
        case totalCorrectAnswers /// Для общего количества правильных ответов за все игры
        case totalQuestionsAsked /// Для общего количества вопросов, заданных за все игры
    }
}

extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.gamesCount.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
        
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue )
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue )
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct:correct, total: total, date: date)
        } set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        if totalQuestionsAsked == 0 {
            return 0.0
        }
        return Double(totalCorrectAnswers) / Double(totalQuestionsAsked) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1 /// обновили кол-во сыгранных игр
        totalCorrectAnswers += count
        totalQuestionsAsked += amount
        let currentGameResult = GameResult(correct: count, total: amount, date: Date())
        if bestGame.total < amount || (bestGame.total == amount && bestGame.correct < count) {
            bestGame = currentGameResult
        }
    }
    
    
}
