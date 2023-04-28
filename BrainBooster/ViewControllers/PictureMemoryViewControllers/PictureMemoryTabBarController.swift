//
//  PictureMemoryTabBarController.swift
//  BrainBooster
//
//  Created by Iaroslav Beldin on 27.04.2023.
//

import UIKit

final class PictureMemoryTabBarController: UITabBarController {
    @IBAction func resetAction(_ sender: UIBarButtonItem) {
        if let selectedVC = self.selectedViewController {
            switch selectedVC {
            case let pictureMemory4x4VC as PictureMemory4x4ViewController:
                pictureMemory4x4VC.restartAlert()
            case let pictureMemory6x6VC as PictureMemory6x6ViewController:
                pictureMemory6x6VC.restartAlert()
            default:
                break
            }
        }
    }
}
