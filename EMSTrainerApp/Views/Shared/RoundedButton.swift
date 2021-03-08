//
//  RoundedButton.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 09..
//

import UIKit

private enum Constants {
    static let offset: CGFloat = 100
    static let placeholderSize: CGFloat = 17
}
@IBDesignable
class RoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
   
}
