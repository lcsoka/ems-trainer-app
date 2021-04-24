//
//  WorkoutDetailsViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 24..
//

import UIKit

class WorkoutDetailsViewController: UIViewController, MainStoryboardLodable {

    @IBOutlet var lblWorkoutType: UILabel!
    @IBOutlet var workoutImage: UIImageView!
    @IBOutlet var lblWorkoutInterval: UILabel!
    @IBOutlet var lblWorkoutLength: UILabel!
    
    var viewModel: WorkoutDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

    func setupUI() {
        let workout = viewModel.workout!
        let date = workout.date!
        let titleFormatter = DateFormatter()
        titleFormatter.dateStyle = .long
        title = titleFormatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let startDate = Calendar.current.date(byAdding: .second, value: -Int(workout.length), to: date)

        let start = timeFormatter.string(from: startDate!)
        let end = timeFormatter.string(from: date)
        
        lblWorkoutInterval.text = "\(start) - \(end)"
        lblWorkoutType.text = "\(workout.trainingMode!.capitalized) Workout"
        lblWorkoutLength.text = Converter.getTimeStrWithHour(Int(workout.length))
        
        if let image = UIImage(named: workout.trainingMode!) {
            workoutImage.image = image
        }
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        
    }
}
