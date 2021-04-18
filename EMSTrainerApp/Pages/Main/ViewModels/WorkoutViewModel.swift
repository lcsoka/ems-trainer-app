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
    func shouldUpdateView()
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
            
            if master < 0 {
                master = 0
            }
            
            if master > 100 {
                master = 100
            }
            
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
    
    var disconnected = false
    
    var delegate: WorkoutViewModelDelegate?
    
    var valueChangerTimer: EMSTimer!
    
    var valueChangerChannel: Int? = nil
    
    var valueChangerTargetValue = 0
    
    var api: ApiService!
    
    var trainingValues: [Int:TrainingValueJSON] = [:]
    
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
    
    func startIncreaseMaster() {
        valueChangerChannel = nil
        valueChangerTargetValue = 100
        startValueChangerTimer()
    }
    
    func startDecreaseMaster() {
        valueChangerChannel = nil
        valueChangerTargetValue = 0
        startValueChangerTimer()
    }
    
    func startValueChangerTimer() {
        if valueChangerTimer == nil {
            valueChangerTimer = EMSTimer(rate: 0.1, delegate: self)
        }
        
        valueChangerTimer.start()
    }
    
    func stopValueChangerTimer() {
        valueChangerTimer?.stop()
        
        if valueChangerChannel == nil {
            // Save master value for this timestamp
            let trainingValue = TrainingValueJSON(timestamp: workoutTime, master: master)
            trainingValues[workoutTime] = trainingValue
        }
    }
}

// MARK: EMSTimerDelegate
extension WorkoutViewModel: EMSTimerDelegate {
    func onTick(_ timer: EMSTimer) {
        if self.timer != nil && timer == self.timer {
            if workoutTime < trainingMode.length{
                workoutTime += 1
            }
            delegate?.onTimeTick()
        } else if timer == valueChangerTimer {
            if valueChangerChannel == nil {
                // We are changing the master value
                
                if master <= valueChangerTargetValue {
                    master = master + 1
                } else {
                    master = master - 1
                }
                
            } else {
                // We are changeing channel Value
            }
        }
    }
}

// MARK: EMSDelegate
extension WorkoutViewModel: EMSDelegate {
    func onConnected() {
        self.disconnected = false
        print("websocket connected")
        client.sendConfig()
        self.delegate?.shouldUpdateView()
    }
    
    func onConnectionLost() {
        // Pause training
        self.disconnected = true
        self.pauseWorkout()
        self.delegate?.askForReconnect()
        self.delegate?.shouldUpdateView()
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
