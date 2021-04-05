//
//  StatisticsView.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import UIKit

@IBDesignable
class StatisticsView: UIView, CustomViewProtocol {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(for: "StatisticsView")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(for: "StatisticsView")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.width, height: 125)
    }
}
