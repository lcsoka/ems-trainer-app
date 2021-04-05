//
//  WorkoutListItem.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 05..
//

import UIKit

class WorkoutListItem: UIView, CustomViewProtocol {
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(for: "WorkoutListItem")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(for: "WorkoutListItem")
    }
}
