//
//  WorkoutSetupViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import UIKit

class WorkoutSetupViewController: UIViewController, MainStoryboardLodable {

    var finder: FinderProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupDeviceFinder()
    }
    
    func setupUI() {
        title = "Workout"
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    func setupDeviceFinder() {
        finder?.delegate = self
        finder?.start()
    }
}

extension WorkoutSetupViewController: FinderDelegate {
    func onDeviceFound(device: DeviceHost) {
        print(device)
    }
}
