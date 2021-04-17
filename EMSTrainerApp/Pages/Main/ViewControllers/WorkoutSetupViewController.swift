//
//  WorkoutSetupViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import UIKit

protocol WorkoutSetupViewControllerDelegate {
    func userRequestWorkoutPage(device: DeviceHost, trainingMode: TrainingMode)
}

class WorkoutSetupViewController: UIViewController, MainStoryboardLodable {
    
    var viewModel: WorkoutSetupViewModel!
 
    let deviceCellIdentifier = "DeviceRowCollectionViewCell"
    
    var delegate: WorkoutSetupViewControllerDelegate?
    
    @IBOutlet var trainingModeSelector: TrainingModeSelectorView!
    @IBOutlet var deviceLoaderIndicator: UIActivityIndicatorView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var deviceFinderView: DeviceFinderView!
    
    @IBOutlet var btnStart: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupDeviceFinder()
        setupData()
        refreshView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.stopSearch()
    }
    
    func setupUI() {
        title = "Workout"
        self.extendedLayoutIncludesOpaqueBars = true
        deviceFinderView.viewModel = viewModel
        trainingModeSelector.delegate = self
    }
    
    func setupDeviceFinder() {
        viewModel.startSearch()
        deviceLoaderIndicator.startAnimating()
    }
    
    func setupData() {
        trainingModeSelector.setupView(trainingModes: viewModel.trainingModes)
    }
    
    func refreshView() {
        btnStart.disabled = !viewModel.canStartWorkout()
    }
    
    @IBAction func onStarWorkoutTap(_ sender: Any) {
        delegate?.userRequestWorkoutPage(device: viewModel.selectedDevice!, trainingMode: viewModel.selectedMode!)
    }
}

// MARK: TrainingModeSelectorViewDelegate
extension WorkoutSetupViewController: TrainingModeSelectorViewDelegate {
    func onTrainingModeSelected(_ mode: TrainingMode) {
        viewModel.selectedMode = mode
    }
}
// MARK: WorkoutSetupViewModelDelegate
extension WorkoutSetupViewController: WorkoutSetupViewModelDelegate {
    func onDataChange() {
        refreshView()
    }
}
// MARK: FinderViewModelDelegate
extension WorkoutSetupViewController: FinderViewModelDelegate {
    func onDeviceListRefresh() {
        deviceFinderView.reloadData()
    }
}
