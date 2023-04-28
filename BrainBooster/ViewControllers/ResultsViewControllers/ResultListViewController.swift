//
//  ResultListViewController.swift
//  BrainBooster
//
//  Created by Iaroslav Beldin on 28.04.2023.
//

import UIKit

final class ResultListViewController: UITableViewController {
    
    let gameTypes = DataManager.shared.getAllGameTypes()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        overrideUserInterfaceStyle = .light
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gameTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let game = gameTypes[indexPath.row]
        
        content.text = game.rawValue
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            guard let detailResultListVC = segue.destination as? DetailResultListViewController else { return }
            
            detailResultListVC.gameType = gameTypes[indexPath.row]
        }
    }
}
