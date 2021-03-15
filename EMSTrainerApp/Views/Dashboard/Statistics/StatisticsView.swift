//
//  StatisticsView.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import UIKit

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
}
