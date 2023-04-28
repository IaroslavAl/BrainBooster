//
//  CustomTextField.swift
//  BrainBooster
//
//  Created by Iaroslav Beldin on 27.04.2023.
//

import UIKit

final class CustomTextField: UITextField {
    weak var numberMemoryEasyVC: NumberMemoryEasyViewController?
    weak var numberMemoryMediumVC: NumberMemoryMediumViewController?
    weak var numberMemoryHardVC: NumberMemoryHardViewController?
    weak var numberMemoryExtremeVC: NumberMemoryExtremeViewController?
    
    override public func deleteBackward() {
        super.deleteBackward()
        numberMemoryEasyVC?.deleteBackward(self)
        numberMemoryMediumVC?.deleteBackward(self)
        numberMemoryHardVC?.deleteBackward(self)
        numberMemoryExtremeVC?.deleteBackward(self)
    }
}
