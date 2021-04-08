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
    @IBOutlet var lblWorkoutCount: UILabel!
    @IBOutlet var lblAvgTime: UILabel!
    
    var workouts: [Training]! {
        didSet {
            lblWorkoutCount.text = "\(workouts.count)"
            
            let avgTime = Int(workouts.map{$0.length}.reduce(.zero, +)) / workouts.count
            lblAvgTime.text = avgTime.toTimeString()
        }
    }
    
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
