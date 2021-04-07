//
//  WorkoutListItem.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 05..
//

import UIKit

class WorkoutListItem: UIView, CustomViewProtocol {
    @IBOutlet var contentView: UIView!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblLength: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var imageType: UIImageView!
    
    var workout: Training! {
        didSet {
            lblType.text = "\(workout.trainingMode!.capitalized) Workout \(workout.id)"
            lblLength.text = Int(workout.length).toTimeString()
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            lblDate.text = formatter.string(from: workout.createdAt!)
            
            if let image = UIImage(named: workout.trainingMode!) {
                imageType.image = image
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(for: "WorkoutListItem")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(for: "WorkoutListItem")
    }
}
