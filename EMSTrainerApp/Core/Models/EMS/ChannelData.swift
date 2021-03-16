//
//  ChannelData.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import Foundation

class ChannelData: EMSChannel {
    private var channel: Int
    internal var value: Int
    internal var freq: Int
    
    init(for channel: Int, value: Int, freq: Int) {
        self.channel = channel
        self.value = value
        self.freq = freq
    }
    
    convenience init(for channel: Int, data: EMSChannel) {
        self.init(for: channel, value: data.value, freq: data.freq)
    }
    
    func setValue(_ value: Int) {
        self.value = value
    }
    
    func setFreq(_ freq: Int) {
        self.freq = freq
    }
}
