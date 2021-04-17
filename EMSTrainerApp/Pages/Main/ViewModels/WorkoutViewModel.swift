//
//  WorkoutViewModel.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 27..
//

import Foundation

protocol WorkoutViewModelDelegate {
    func onMasterChanged(value: Int)
    func onChannelChanged(channel: ChannelData)
    func onTimeTick()
    func askForReconnect()
}
class WorkoutViewModel {
    var client: EMSClient! {
        didSet {
            client.delegate = self
        }
    }
    var trainingMode: TrainingMode!
    var master: Int = 0 {
        didSet {
            delegate?.onMasterChanged(value: master)
        }
    }
    var progress: Float  {
        get {
            return 1 - Float(timeLeft) / Float(trainingMode.length)
        }
    }
    var timer: EMSTimer!
    var time: Int = 0
    
    var timeLeft: Int {
        get {
            return trainingMode.length - time
        }
    }
    
    var delegate: WorkoutViewModelDelegate?
    
    var api: ApiService!
    
    init(api: ApiService) {
        self.api = api
    }
    
    func connect() {
        if !client.isConnected {
            client.connect()
        }
    }
    
    func startWorkout() {
        if timer == nil {
            timer = EMSTimer(rate: 1, delegate: self)
        }
        timer.start()
    }
    
    func pauseWorkout() {
        
    }
    
    func stopWorkout() {
        
    }
}

extension WorkoutViewModel: EMSTimerDelegate {
    func onTick(_ timer: EMSTimer) {
        if time < trainingMode.length{
            time += 1
        }
        delegate?.onTimeTick()
    }
}

extension WorkoutViewModel: EMSDelegate {
    func onConnected() {
        print("websocket connected")
    }
    
    func onConnectionLost() {
        // Pause training
        self.pauseWorkout()
        self.delegate?.askForReconnect()
    }
    
    func onBatteryChanged(_ percentage: Int) {
        
    }
    
    func onImpulseOn() {
        
    }
    
    func onImpulseOff() {
        
    }
}
