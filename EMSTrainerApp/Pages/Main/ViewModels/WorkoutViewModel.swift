//
//  WorkoutViewModel.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 27..
//

import Foundation

protocol WorkoutViewModelDelegate {
    func onMasterChanged(value: Int)
    func onChannelChanged(channel: Int)
    func onWorkoutStatusChanged()
    func onTimeTick()
    func onImpulseChanged()
    func askForReconnect()
    func shouldUpdateView()
    func onBatteryChange(percent: Int)
    func onWorkoutEnd()
}

protocol WorkoutViewModelModalDelegate {
    func onChannelValueChanged(channel: Int)
    func onFrequencyChanged(channel: Int)
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
     Timer used for counting workout time while the training is running
     */
    var workoutTimer: EMSTimer!
    
    /**
     Total time spent in workout, while not paused
     */
    var workoutTime: Int = 0
    
    var overallTimer: EMSTimer!
    
    var overallTime = 0
    
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
    
    var modalDelegate: WorkoutViewModelModalDelegate?
    
    var valueChangerTimer: EMSTimer!
    
    var valueChangerChannel: Int? = nil
    
    var isFreqChange = false
    
    var valueChangerTargetValue = 0
    
    var api: ApiService!
    
    var trainingValues: [Int:TrainingValueJSON] = [:]
    
    var impulseCounter = 1
    
    var impulseTimeLeft: Int {
        if impulseOn {
            return (impulseTime - impulseCounter) + 1
        } else {
            return (impulsePause - impulseCounter) + 1
        }
    }
    
    /**
     This variable is used to set if the impulse was sent manually
     It happens when when the user presses the start button.
     */
    var manualStart = false
    
    var workoutEnded = false
    
    var canChangeValues: Bool {
        get {
            return workoutEnded ? false : true
        }
    }
    
    var trainingsProvider: TrainingsProvider
    
    // MARK: Init
    init(api: ApiService, trainingsProvider: TrainingsProvider) {
        self.api = api
        self.trainingsProvider = trainingsProvider
        overallTimer = EMSTimer(rate: 1, delegate: self)
        overallTimer.start()
    }
    
    func connect() {
        if !client.isConnected {
            client.connect()
        }
    }
    
    func startWorkout(fromUser: Bool = false) {
        started = true
        paused = false
        manualStart = true
        
        if workoutEnded {
            return
        }
        
        if fromUser {
            master = savedMaster
        }
        
        if workoutTimer == nil {
            workoutTimer = EMSTimer(rate: 1, delegate: self)
            saveTrainingValue()
        }
        workoutTimer.start()
        client.sendImpulseOn()
        delegate?.onWorkoutStatusChanged()
    }
    
    func pauseWorkout(fromUser: Bool = false) {
        paused = true
        
        if workoutEnded {
            return
        }
        
        if fromUser {
            savedMaster = master
        }
        
        workoutTimer?.stop()
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
        overallTimer.stop()
        workoutTimer?.stop()
        onWorkoutEnded()
    }
    
    func startChangingMaster(increase: Bool = true) {
        valueChangerChannel = nil
        valueChangerTargetValue = increase ? 100 : 0
        startValueChangerTimer()
    }
    
    func startChangingChannelValue(channel: Int, increase: Bool = true) {
        isFreqChange = false
        valueChangerChannel = channel
        valueChangerTargetValue = increase ? 100 : 0
        startValueChangerTimer()
    }
    
    func startChangingChannelFreq(channel: Int, increase: Bool = true) {
        isFreqChange = true
        valueChangerChannel = channel
        valueChangerTargetValue = increase ? 100 : 0
        startValueChangerTimer()
    }
    
    private func saveTrainingValue() {
        let trainingValue = TrainingValueJSON(timestamp: workoutTime, master: master)
        trainingValues[workoutTime] = trainingValue
    }
    
    private func startValueChangerTimer() {
        if valueChangerTimer == nil {
            valueChangerTimer = EMSTimer(rate: 0.1, delegate: self)
        }
        
        valueChangerTimer.start()
    }
    
    func stopValueChangerTimer() {
        valueChangerTimer?.stop()
        
        if valueChangerChannel == nil {
            // Save master value for this timestamp
            saveTrainingValue()
        }
    }
    
    func onWorkoutEnded() {
        guard workoutEnded == false else {
            return
        }
        
        workoutEnded = true
        print("workout ended")
        
        let timestamp = Int((Date().timeIntervalSince1970))
        
        api.post(CreateTrainingResource(), data: CreateTrainingData(length: workoutTime, trainingMode: trainingMode.name.lowercased(), trainingValues: trainingValues.map({$0.value}), date: timestamp), onSuccess: { response in
            if let trainings = response?.trainings {
                self.trainingsProvider.importTrainings(from:trainings)
                self.delegate?.onWorkoutEnd()
            }
        }){ error in
            // TODO: Save training data offline
            self.delegate?.onWorkoutEnd()
        }
    }
}

// MARK: EMSTimerDelegate
extension WorkoutViewModel: EMSTimerDelegate {
    func onTick(_ timer: EMSTimer) {
        
        if timer == overallTimer{
            overallTime += 1
            if overallTime % 5 == 0 {
                if client != nil && client.isConnected {
                    client.getBattery()
                }
            }
            return
        }
        
        if workoutTimer != nil && timer == workoutTimer {
            if workoutTime < trainingMode.length {
                workoutTime += 1
            } else {
                stopWorkout()
            }
            impulseCounter += 1
            delegate?.onTimeTick()
            return
        }
        
        if timer == valueChangerTimer {
            if canChangeValues {
                if valueChangerChannel == nil {
                    // We are changing the master value
                    if master <= valueChangerTargetValue {
                        if master != valueChangerTargetValue {
                            master = master + 1
                        }
                    } else {
                        if master != valueChangerTargetValue {
                            master = master - 1
                        }
                    }
                } else {
                    if isFreqChange {
                        // We are changeing channel frequency
                        var freq = channels[valueChangerChannel!]!.freq
                        
                        if freq <= valueChangerTargetValue {
                            if freq != valueChangerTargetValue {
                                freq = freq + 5
                            }
                        } else {
                            if freq != valueChangerTargetValue {
                                freq = freq - 5
                            }
                        }
                        
                        client.setFreq(for: valueChangerChannel!, value: freq)
                        modalDelegate?.onFrequencyChanged(channel: valueChangerChannel!)
                    } else {
                        // We are changeing channel Value
                        var value = channels[valueChangerChannel!]!.value
                        
                        if value <= valueChangerTargetValue {
                            if value != valueChangerTargetValue {
                                value = value + 1
                            }
                        } else {
                            if value != valueChangerTargetValue {
                                value = value - 1
                            }
                        }
                        
                        client.setValue(for: valueChangerChannel!, value: value)
                        modalDelegate?.onChannelValueChanged(channel: valueChangerChannel!)
                    }
                    // Get channels from the client object
                    channels = client.channels
                    delegate?.onChannelChanged(channel: valueChangerChannel!)
                }
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
        client.getBattery()
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
        delegate?.onBatteryChange(percent: percentage)
    }
    
    func onImpulseOn() {
        impulseOn = true
        impulseCounter = 0
        
        if manualStart {
            manualStart = false
            impulseCounter = 1
        }
        delegate?.onImpulseChanged()
    }
    
    func onImpulseOff() {
        impulseOn = false
        impulseCounter = 0
        delegate?.onImpulseChanged()
    }
}
