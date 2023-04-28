//
//  Game.swift
//  BrainBooster
//
//  Created by Iaroslav Beldin on 28.04.2023.
//

struct Game {
    let type: GameType
    let mode: Mode
    var timeType: Int?
    var score: Int?
    var time: Int?
}

enum GameType: String {
    case numberMemory = "Number Memory"
    case pictureMemory = "Picture Memory"
}

enum Mode: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case extreme = "Extreme"
    case fourByFour = "4x4"
    case sixBySix = "6x6"
}
