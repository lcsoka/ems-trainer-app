//
//  CustomViewProtocol.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import UIKit

protocol CustomViewProtocol {
    var contentView: UIView! { get }
    
    func commonInit(for customViewName: String)
}

extension CustomViewProtocol where Self: UIView {
    func commonInit(for customViewName: String) {
        Bundle.main.loadNibNamed(customViewName, owner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = .clear
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
