//
//  WorkoutSetupViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import UIKit

class WorkoutSetupViewController: UIViewController, MainStoryboardLodable {

    var finder: FinderProtocol?
    
    var viewModel: WorkoutSetupViewModel!
    
    @IBOutlet var trainingModeSelector: TrainingModeSelectorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupDeviceFinder()
        setupData()
    }
    
    func setupUI() {
        title = "Workout"
        self.extendedLayoutIncludesOpaqueBars = true
        
        trainingModeSelector.delegate = self
    }
    
    func setupDeviceFinder() {
        finder?.delegate = self
        finder?.start()
    }
    
    func setupData() {
        trainingModeSelector.setupView(trainingModes: viewModel.trainingModes)
    }
}

extension WorkoutSetupViewController: TrainingModeSelectorViewDelegate {
    func onTrainingModeSelected(_ mode: TrainingMode) {
        print(mode)
    }
}

extension WorkoutSetupViewController: FinderDelegate {
    func onDeviceFound(device: DeviceHost) {
        print(device)
    }
}
