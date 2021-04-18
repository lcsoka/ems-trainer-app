//
//  WebsocketClient.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import Foundation
import Starscream

class WebsocketClient: EMSClient {
    var host: DeviceHost
    
    var delegate: EMSDelegate?
    
    private var wsClient: WebSocket!
    
    private var connected = false
    
    var isConnected: Bool {
        get {
            return connected
        }
    }
    
    internal var masterValue = 0
    
    internal var time = 0
    
    internal var pause = 0
    
    var channels: [Int : ChannelData] = [:]
    
    init(_ host: DeviceHost) {
        self.host = host
        
        let url = URL(string: "ws://\(host.address)/ws")
        var request = URLRequest(url: url!)
        request.timeoutInterval = 5
        
        self.wsClient = WebSocket(request: request)
        self.wsClient.delegate = self
    }
    
    func setMaster(_ master: Int) {
        self.masterValue = master
        sendMessage(message: .setMasterValue, value: master)
    }
    
    func setAllChannelData(_ data: EMSValues) {
        self.time = data.time
        self.pause = data.pause
        
        for ch in EMSConfig.channels {
            channels[ch] = ChannelData(for: ch, data: data)
        }
    }
    
    func setAllChannelData(time: Int, pause: Int, channels: [Int : ChannelData]) {
        self.time = time
        self.pause = pause
        self.channels = channels
    }
    
    func setChannelData(for channel: Int, value: Int, frequency: Int) {
        
    }
    
    func setValue(for channel: Int, value: Int) {
        sendMessage(for: channel, message: .setChannelValue, value: value)
    }
    
    func setFreq(for channel: Int, value: Int) {
        sendMessage(for: channel, message: .setChannelFreq, value: value)
    }
    
    func setTime(_ time: Int) {
        self.time = time
        sendMessage(message: .setImpuleTime, value: time)
    }
    
    func setPause(_ pause: Int) {
        self.pause = pause
        sendMessage(message: .setImpulsePause, value: pause)
    }
    
    func sendMessage(message: EMSMessage, value: Int) {
        sendWebsocketMessage("\(message.rawValue) \(value)")
    }
    
    func sendMessage(message: EMSMessage) {
        sendWebsocketMessage("\(message.rawValue)")
    }
    
    func sendMessage(for channel: Int, message: EMSMessage, value: Int) {
        sendWebsocketMessage("\(message.rawValue) \(channel) \(value)")
    }
    
    private func sendWebsocketMessage(_ message: String) {
        wsClient.write(string: message)
    }
    
    func sendConfig() {
        for channel in channels {
            let currentChannel = channel.value
            setValue(for: channel.key, value: currentChannel.value)
            setFreq(for: channel.key, value: currentChannel.freq)
        }
        setTime(self.time)
        setPause(self.pause)
        setMaster(0)
    }
    
    func sendImpulseOn() {
        sendMessage(message: .setImpulseOn)
    }
    
    func sendImpulseOff() {
        sendMessage(message: .setImpulseOff)
    }
    
    func getBattery(){
        sendMessage(message: .getBattery)
    }
    
    func connect() {
        self.wsClient.connect()
    }
    
    func close() {
        self.connected = false
        self.wsClient.disconnect()
    }
}

extension WebsocketClient: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(_):
            // TODO: listeners
            self.connected = true
            delegate?.onConnected()
            break
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
            delegate?.onConnectionLost()
            self.connected = false
            break
        case .text(let text):
            // TODO: process messages
//            print(text)
            let commands = text.split(separator: " ").map({Int($0)})
            if let cmd = EMSMessage(rawValue: (commands[0])!) {
                switch(cmd) {
                case .setMasterValue:
                    break
                case .setChannelValue:
                    break
                case .setChannelFreq:
                    break
                case .setImpulseOn:
                    delegate?.onImpulseOn()
                    break
                case .setImpulseOff:
                    delegate?.onImpulseOff()
                    break
                case .setImpuleTime:
                    break
                case .setImpulsePause:
                    break
                case .getBattery:
                    delegate?.onBatteryChanged(commands[1]!)
                    break
                }
            }
            
            break
        default:
            break
        }
    }
}
