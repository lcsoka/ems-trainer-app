//
//  WorkoutSetupViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import UIKit

protocol WorkoutSetupViewControllerDelegate {
    func userRequestWorkoutPage(client: EMSClient)
}

class WorkoutSetupViewController: UIViewController, MainStoryboardLodable {
    
    var viewModel: WorkoutSetupViewModel!
 
    let deviceCellIdentifier = "DeviceRowCollectionViewCell"
    
    var delegate: WorkoutSetupViewControllerDelegate?
    
    @IBOutlet var trainingModeSelector: TrainingModeSelectorView!
    @IBOutlet var deviceLoaderIndicator: UIActivityIndicatorView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var btnStart: RoundedButton!
    
    var client: EMSClient?
    
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: deviceCellIdentifier, bundle: nil), forCellWithReuseIdentifier: deviceCellIdentifier)
        collectionView.backgroundColor = .clear
        trainingModeSelector.delegate = self
    }
    
    func setupDeviceFinder() {
        viewModel.search()
        deviceLoaderIndicator.startAnimating()
    }
    
    func setupData() {
        trainingModeSelector.setupView(trainingModes: viewModel.trainingModes)
    }
    
    func refreshView() {
        btnStart.disabled = !viewModel.canStartWorkout()
    }
    
    @IBAction func onStarWorkoutTap(_ sender: Any) {
        // TODO: Maybe a service should do this?
//        client = WebsocketClient(selectedDevice!)
//        client!.setAllChannelData(selectedMode!.values)
//        delegate?.userRequestWorkoutPage(client: client!)
    }
}

extension WorkoutSetupViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.devices.isEmpty ? 1 : viewModel.devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.devices.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath as IndexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deviceCellIdentifier, for: indexPath) as! DeviceRowCollectionViewCell
            let device = viewModel.devices.map{$0.value.host}[indexPath.row]
            cell.device = device
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DeviceRowCollectionViewCell {
            cell.roundedView.borderColor = UIColor(named: "Green500")!
            cell.roundedView.borderWidth = 2
            viewModel.selectedDevice = cell.device
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DeviceRowCollectionViewCell {
            cell.roundedView.borderColor = .clear
            cell.roundedView.borderWidth = 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel.devices.isEmpty {
            return CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.height - 20)
        } else {
            return CGSize(width: collectionView.frame.width - 20, height: 80)
        }
    }
}

extension WorkoutSetupViewController: TrainingModeSelectorViewDelegate {
    func onTrainingModeSelected(_ mode: TrainingMode) {
        viewModel.selectedMode = mode
    }
}

extension WorkoutSetupViewController: WorkoutSetupViewModelDelegate {
    func onDataChange() {
        refreshView()
    }
    
    func onDeviceListRefresh() {
        collectionView.reloadData()
    }
}
