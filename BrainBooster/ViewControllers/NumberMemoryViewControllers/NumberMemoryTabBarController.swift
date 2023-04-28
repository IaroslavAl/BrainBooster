//
//  NumberMemoryTabBarController.swift
//  BrainBooster
//
//  Created by Iaroslav Beldin on 27.04.2023.
//

import UIKit

final class NumberMemoryTabBarController: UITabBarController {
    @IBAction func resetAction(_ sender: UIBarButtonItem) {
        if let selectedVC = self.selectedViewController {
            switch selectedVC {
            case let numberMemoryEasyVC as NumberMemoryEasyViewController:
                numberMemoryEasyVC.restartAlert()
            case let numberMemoryMediumVC as NumberMemoryMediumViewController:
                numberMemoryMediumVC.restartAlert()
            case let numberMemoryHardVC as NumberMemoryHardViewController:
                numberMemoryHardVC.restartAlert()
            case let numberMemoryExtremeVC as NumberMemoryExtremeViewController:
                numberMemoryExtremeVC.restartAlert()
            default:
                break
            }
        }
    }
}
