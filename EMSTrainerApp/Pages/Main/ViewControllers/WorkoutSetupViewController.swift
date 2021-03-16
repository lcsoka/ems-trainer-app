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
    var selectedMode: TrainingMode? {
        didSet {
            refreshView()
        }
    }
    var selectedDevice: DeviceHost? {
        didSet {
            refreshView()
        }
    }
    var devices: [DeviceHost] = []
    let deviceCellIdentifier = "DeviceRowCollectionViewCell"
    
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
        finder?.delegate = self
        search()
        deviceLoaderIndicator.startAnimating()
    }
    
    func search() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.devices.isEmpty {
                self.search()
            }
        }
        devices = []
        collectionView.reloadData()
        finder?.start()
    }
    
    func setupData() {
        trainingModeSelector.setupView(trainingModes: viewModel.trainingModes)
    }
    
    func refreshView() {
        btnStart.disabled = !canStartWorkout()
    }
    
    func canStartWorkout() -> Bool {
        return selectedMode != nil && selectedDevice != nil
    }
    
    @IBAction func onStarWorkoutTap(_ sender: Any) {
        client = WebsocketClient(selectedDevice!)
        client!.setAllChannelData(selectedMode!.values)
        client!.connect()
    }
}

extension WorkoutSetupViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.isEmpty ? 1 : devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if devices.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath as IndexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deviceCellIdentifier, for: indexPath) as! DeviceRowCollectionViewCell
            let device = devices[indexPath.row]
            cell.device = device
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DeviceRowCollectionViewCell {
            cell.roundedView.borderColor = UIColor(named: "Green500")!
            cell.roundedView.borderWidth = 2
            selectedDevice = cell.device
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DeviceRowCollectionViewCell {
            cell.roundedView.borderColor = .clear
            cell.roundedView.borderWidth = 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if devices.isEmpty {
            return CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.height - 20)
        } else {
            return CGSize(width: collectionView.frame.width - 20, height: 80)
        }
    }
}

extension WorkoutSetupViewController: TrainingModeSelectorViewDelegate {
    func onTrainingModeSelected(_ mode: TrainingMode) {
        selectedMode = mode
    }
}

extension WorkoutSetupViewController: FinderDelegate {
    func onDeviceFound(device: DeviceHost) {
        if !devices.contains(device) {
            print(device)
            devices.append(device)
        }
        collectionView.reloadData()
    }
}
