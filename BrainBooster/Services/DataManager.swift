//
//  DataStore.swift
//  BrainBooster
//
//  Created by Iaroslav Beldin on 28.04.2023.
//

final class DataManager {
    static let shared = DataManager()
    private var games: [Game] = []
    
    private init() {}
    
    func addGame(_ game: Game) {
        games.append(game)
    }
    
    func updateGame(_ game: Game, atIndex index: Int) {
        games[index] = game
    }
    
    func getAllGames() -> [Game] {
        return games
    }
    
    func getAllGameTypes() -> [GameType] {
        var gameTypes: [GameType] = []
        for game in games {
            if !gameTypes.contains(game.type) {
                gameTypes.append(game.type)
            }
        }
        return gameTypes
    }
    
    func getAllGamesSorted(by gameType: GameType) -> [Game] {
        let filteredGames = games.filter { $0.type == gameType }
        let sortedGames = filteredGames.sorted { $0.mode.rawValue < $1.mode.rawValue && $0.timeType ?? 0 < $1.timeType ?? 0 }
        return sortedGames
    }
    
    func getUniqueModes(for gameType: GameType) -> [Mode] {
        let filteredGames = games.filter { $0.type == gameType }
        var modes: [Mode] = []
        for game in filteredGames {
            if !modes.contains(game.mode) {
                modes.append(game.mode)
            }
        }
        return modes
    }
    
    func getAllGames(for gameType: GameType, with mode: Mode) -> [Game] {
        let filteredGames = games.filter { $0.type == gameType && $0.mode == mode }
        return filteredGames
    }
    
    func getGamesCountByTimeType(for gameType: GameType, mode: Mode) -> [Int: Int] {
        let filteredGames = DataManager.shared.getAllGames().filter { $0.type == gameType && $0.mode == mode }
        let countByTimeType: [Int: Int] = filteredGames.reduce(into: [:]) { counts, game in
            if let timeType = game.timeType {
                counts[timeType] = (counts[timeType] ?? 0) + 1
            }
        }
        return countByTimeType
    }
}
