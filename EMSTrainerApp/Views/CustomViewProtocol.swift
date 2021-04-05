//
//  CustomViewProtocol.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import UIKit

protocol CustomViewProtocol: class {
    var contentView: UIView! { set get }
    
    func commonInit(for customViewName: String)
}

extension CustomViewProtocol where Self: UIView {
    func commonInit(for customViewName: String) {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: customViewName, bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contentView.backgroundColor = .clear
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
}
