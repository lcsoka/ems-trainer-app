//
//  WorkoutViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 21..
//

import UIKit

class WorkoutViewController: UIViewController, MainStoryboardLodable {

    @IBOutlet var waveView: WaveView!
    var client: EMSClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        client.delegate = self
        client!.connect()
    }
    
    @IBAction func onStopTapped(_ sender: Any) {
        client.close()
        self.dismiss(animated: true)
    }
}

extension WorkoutViewController: EMSDelegate {
    func onConnected() {
        client.sendConfig()
    }
    
    func onImpulseOn() {
        
    }
    
    func onImpulseOff() {
        
    }
    
    func onBatteryChanged(_ percentage: Int) {
        
    }
}
