//
//  AddButton.swift
//  SimpleToDoApp
//
//  Created by Pavel on 24.03.23.
//

import UIKit

@IBDesignable
class AddButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            if cornerRadius == 0 {
                self.layer.cornerRadius = layer.frame.height / 2
            } else {
                self.layer.cornerRadius = cornerRadius
                
            }
        }
    }
}
