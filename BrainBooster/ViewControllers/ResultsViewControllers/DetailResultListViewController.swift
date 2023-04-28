//
//  DetailResultListViewController.swift
//  BrainBooster
//
//  Created by Iaroslav Beldin on 28.04.2023.
//

import UIKit

final class DetailResultListViewController: UITableViewController {
    
    var gameType: GameType!
    var gameModes: [Mode]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameModes = DataManager.shared.getUniqueModes(for: gameType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        overrideUserInterfaceStyle = .light
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        gameModes.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        gameModes[section].rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch gameType {
        case .numberMemory:
            return DataManager.shared.getGamesCountByTimeType(for: gameType, mode: gameModes[section]).count
        case .pictureMemory:
            return 1
        case .quiz:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailGameCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        switch gameType {
        case .numberMemory:
            let sortedGames = DataManager.shared.getAllGames(for: gameType, with: gameModes[indexPath.section]).sorted(by: { $0.timeType ?? 0 < $1.timeType ?? 0 })
            let timeType = sortedGames[indexPath.row].timeType
            let score = sortedGames[indexPath.row].score
            content.text = "Time: \(timeType ?? 0) sec."
            content.secondaryText = "Score: \(score ?? 0)"
        case .pictureMemory:
            let time = DataManager.shared.getAllGames(for: gameType, with: gameModes[indexPath.section])[indexPath.row].time ?? 0
            content.text = "Time: \(time) sec."
        case .quiz:
            let score = DataManager.shared.getAllGames(for: gameType, with: gameModes[indexPath.section])[indexPath.row].score ?? 0
            content.text = "\(score) / 10"
        default:
            break
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
}
