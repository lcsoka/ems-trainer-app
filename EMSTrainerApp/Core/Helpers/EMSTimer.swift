//
//  EMSTimer.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 27..
//

import Foundation

protocol EMSTimerDelegate {
    func onTick(_ timer: EMSTimer)
}

class EMSTimer {
    private var delegate: EMSTimerDelegate
    private var rate: Double!
    private var basicTimer: Timer? = Timer()
    
    init(rate: Double, delegate: EMSTimerDelegate) {
        self.rate = rate
        self.delegate = delegate
    }
    
    func start() {
        basicTimer?.invalidate()
        basicTimer = nil
        
        basicTimer = Timer.scheduledTimer(timeInterval: rate, target: self, selector: #selector(onTimerTick), userInfo: "Tick: ", repeats: true)
        // Make the timer efficient.
        basicTimer?.tolerance = 0.15
        // Don't run on main thread
        RunLoop.current.add(basicTimer!, forMode: RunLoop.Mode.common)
    }
    
    @objc func onTimerTick() {
        delegate.onTick(self)
    }
    
    func stop() {
        basicTimer?.invalidate()
    }
    
    static func == (lhs: EMSTimer, rhs: EMSTimer) -> Bool {
        return    lhs.basicTimer == rhs.basicTimer
    }
    
}
