//
//  EMSClient.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import Foundation

protocol EMSClient {
    var host: DeviceHost { get }
    
    var delegate: EMSDelegate? { get set }
    
    var isConnected: Bool { get }
    
    var masterValue: Int { get }
    
    var time: Int { get }
    
    var pause: Int { get }
    
    var channels:[Int:ChannelData] { get }
    
    func setMaster(_ master: Int)
    
    func setAllChannelData(_ data: EMSValues)
    
    func setAllChannelData(time: Int, pause: Int, channels: [Int : ChannelData])
    
    func setChannelData(for channel: Int, value: Int, frequency: Int)
    
    func setValue(for channel: Int, value: Int)
    
    func setFreq(for channel: Int, value: Int)
    
    func setTime(_ time: Int)
    
    func setPause(_ pause: Int)
    
    func sendConfig()
    
    func sendImpulseOn()
    
    func sendImpulseOff()
    
    func getBattery()
    
    func connect()
    
    func close()
}

extension EMSClient {
    func pause() {
        setMaster(0)
    }
    
    func resume() {
        setMaster(0)
    }
    
    func getChannelData(for channel: Int) -> ChannelData? {
        return channels[channel]
    }
}
