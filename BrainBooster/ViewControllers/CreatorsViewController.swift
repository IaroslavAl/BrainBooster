//
//  CreatorsViewController.swift
//  BrainBooster
//
//  Created by Iaroslav Beldin on 28.04.2023.
//

import UIKit

final class CreatorsViewController: UIViewController {
    
    @IBOutlet var photos: [UIImageView]!
    @IBOutlet var stackView: UIStackView!
    
    override func viewWillLayoutSubviews() {
        for photo in photos {
            photo.layer.cornerRadius = stackView.frame.height / 2
        }
    }
}
