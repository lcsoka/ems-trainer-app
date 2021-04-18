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
    func onWorkoutStatusChanged()
    func onTimeTick()
    func onImpulseChanged()
    func askForReconnect()
}
class WorkoutViewModel {
    
    // MARK: Properties
    
    /**
     EMS client which is used to communicate with the device
     */
    var client: EMSClient! {
        didSet {
            client.delegate = self
            client.setAllChannelData(time: self.impulseTime, pause: self.impulsePause, channels: self.channels)
            self.connect()
        }
    }
    
    /**
     Training mode which stores the initial training values
     */
    var trainingMode: TrainingMode! {
        didSet {
            // Set initial values
            self.impulseTime = trainingMode.values.time
            self.impulsePause = trainingMode.values.pause
            
            for ch in EMSConfig.channels {
                channels[ch] = ChannelData(for: ch, data: trainingMode.values)
            }
        }
    }
    
    /**
     Master value, the overall strenth value
     */
    var master: Int = 0 {
        didSet {
            delegate?.onMasterChanged(value: master)
            client.setMaster(master)
            
            if !started {
                savedMaster = master
            }
            
        }
    }
    
    var savedMaster: Int = 0
    
    /**
    Impulse time in seconds
     */
    var impulseTime = 0
    
    /**
    Impulse pause in seconds
     */
    var impulsePause = 0
    
    /**
    Channel values
     */
    var channels: [Int : ChannelData] = [:]
    
    /**
    The progress of the workout based of the total time
     */
    var progress: Float  {
        get {
            return 1 - Float(timeLeft) / Float(trainingMode.length)
        }
    }
    
    /**
    Timer used for keeping time
     */
    var timer: EMSTimer!
    
    /**
    Total time spent in workout, while not paused
     */
    var workoutTime: Int = 0
    
    /**
     Seconds left from the workout
     */
    var timeLeft: Int {
        get {
            return trainingMode.length - workoutTime
        }
    }
    
    /**
    Workout was started
     */
    var started = false
    
    /**
     Workout currently paused
     */
    var paused = false
    
    var impulseOn = false
    
    var delegate: WorkoutViewModelDelegate?
    
    var api: ApiService!
    
    // MARK: Init
    init(api: ApiService) {
        self.api = api
    }
    
    func connect() {
        if !client.isConnected {
            client.connect()
        }
    }
    
    func startWorkout(fromUser: Bool = false) {
        started = true
        paused = false
        
        if fromUser {
            master = savedMaster
        }
        
        if timer == nil {
            timer = EMSTimer(rate: 1, delegate: self)
        }
        timer.start()
        client.sendImpulseOn()
        delegate?.onWorkoutStatusChanged()
    }
    
    func pauseWorkout(fromUser: Bool = false) {
        paused = true
        
        if fromUser {
            savedMaster = master
        }
        
        timer?.stop()
        if client.isConnected {
            master = 0
        }
        client.sendImpulseOff()
        delegate?.onWorkoutStatusChanged()
    }
    
    func stopWorkout() {
        self.pauseWorkout()
        // TODO: Save workout and exit
        delegate?.onWorkoutStatusChanged()
    }
}

// MARK: EMSTimerDelegate
extension WorkoutViewModel: EMSTimerDelegate {
    func onTick(_ timer: EMSTimer) {
        if workoutTime < trainingMode.length{
            workoutTime += 1
        }
        delegate?.onTimeTick()
    }
}

// MARK: EMSDelegate
extension WorkoutViewModel: EMSDelegate {
    func onConnected() {
        print("websocket connected")
        client.sendConfig()
    }
    
    func onConnectionLost() {
        // Pause training
        self.pauseWorkout()
        self.delegate?.askForReconnect()
    }
    
    func onBatteryChanged(_ percentage: Int) {
        print("BATTERY \(percentage)")
    }
    
    func onImpulseOn() {
        impulseOn = true
        delegate?.onImpulseChanged()
    }
    
    func onImpulseOff() {
        impulseOn = false
        delegate?.onImpulseChanged()
    }
}
