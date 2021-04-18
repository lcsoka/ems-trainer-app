//
//  ChannelSettingsViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 18..
//

import UIKit

class ChannelSettingsViewController: UIViewController, MainStoryboardLodable {
    
    @IBOutlet var blurBackground: UIVisualEffectView!
    @IBOutlet var lblChannelName: UILabel!
    @IBOutlet var waveView: WaveView!
    @IBOutlet var strengthProgressView: ProgressView!
    @IBOutlet var lblStrength: UILabel!
    @IBOutlet var freqProgressView: ProgressView!
    @IBOutlet var lblFreq: UILabel!
    
    var viewModel: WorkoutViewModel!
    
    var channelIndex: Int!
    
    private var minWaveFreq: Float = 4
    private var maxWaveFreq: Float = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        blurBackground.addGestureRecognizer(tap)
        lblChannelName.text = EMSChannelMap[channelIndex]?.capitalized
        
        strengthProgressView.progress = 0.5
        viewModel.modalDelegate = self
        
        updateStrenth(channel: channelIndex)
        updateFreq(channel: channelIndex)
    }
    
    func onFrequencyChanged(value: Int) {
        
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true)
    }
    
    private func updateStrenth(channel: Int) {
        let percent = viewModel.channels[channel]!.value
        lblStrength.text = "\(percent)%"
        strengthProgressView.progress = CGFloat(percent) / 100
        
        waveView.master = CGFloat(viewModel.channels[channel]!.value) / 100
    }
    
    private func updateFreq(channel: Int) {
        let percent = viewModel.channels[channel]!.freq
        let value = Converter.freqPercentToValue(percent: Float(percent))
        lblFreq.text = "\(Int(value)) Hz"
        freqProgressView.progress = CGFloat(percent) / 100
        
        // Update Wave
        let waveFreq = Converter.percentToValue(percent: Float(percent), minimum: minWaveFreq, maximum: maxWaveFreq, jump: 0.1)
        waveView.frequency = CGFloat(waveFreq)
        let delta = 1 - (CGFloat(waveFreq) - CGFloat(minWaveFreq)) / 2
        let acc = 0.05 * delta
        waveView.speed = 0.1 - acc
        
    }

    
    @IBAction func startTouchingStrengthIncreaser(_ sender: Any) {
        viewModel.startChangingChannelValue(channel: channelIndex)
    }
    
    @IBAction func stopTouchingStrengthIncreaserInside(_ sender: Any) {
        viewModel.stopValueChangerTimer()
    }
    
    @IBAction func stopTouchingStrengthIncreaserOutside(_ sender: Any) {
        viewModel.stopValueChangerTimer()
    }
    
    @IBAction func cancelTouchingStrengthIncreaser(_ sender: Any) {
        viewModel.stopValueChangerTimer()
    }
    
    @IBAction func startTouchingStrengthDecreaser(_ sender: Any) {
        viewModel.startChangingChannelValue(channel: channelIndex, increase: false)
    }
    
    @IBAction func startTouchingFreqhIncreaser(_ sender: Any) {
        viewModel.startChangingChannelFreq(channel: channelIndex)
    }
    
    @IBAction func startTouchingFreqhDecreaser(_ sender: Any) {
        viewModel.startChangingChannelFreq(channel: channelIndex, increase: false)
    }
    
}

extension ChannelSettingsViewController: WorkoutViewModelModalDelegate {
    func onChannelChanged(channel: Int) {
       updateStrenth(channel: channel)
    }
    
    func onFrequencyChanged(channel: Int) {
        updateFreq(channel: channel)
    }
}
