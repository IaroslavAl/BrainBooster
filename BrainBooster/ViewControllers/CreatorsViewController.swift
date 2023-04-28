//
//  CreatorsViewController.swift
//  BrainBooster
//
//  Created by Iaroslav Beldin on 28.04.2023.
//

import UIKit

final class CreatorsViewController: UIViewController {
    
    @IBOutlet var photos: [UIImageView]!
    
    override func viewWillLayoutSubviews() {
        for photo in photos {
            photo.layer.cornerRadius = photo.frame.height / 2
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        overrideUserInterfaceStyle = .light
    }
}
