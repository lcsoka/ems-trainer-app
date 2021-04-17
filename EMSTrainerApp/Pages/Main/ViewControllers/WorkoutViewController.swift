//
//  WorkoutViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 21..
//

import UIKit
import DrawerView

class WorkoutViewController: UIViewController, MainStoryboardLodable {

    @IBOutlet var lblTimeLeft: UILabel!
    @IBOutlet var waveView: WaveView!
    @IBOutlet var progressView: ProgressView!
    @IBOutlet var channelContainer: UIView!
    @IBOutlet var channelCollection: UICollectionView!
    @IBOutlet var drawerView: DrawerView!
    
    var viewModel: WorkoutViewModel!
    
    private var minWaveFreq: Float = 4
    private var maxWaveFreq: Float = 6
    
    private var reuseIdentifier = "channelCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.client.connect()
        updateTime(time: viewModel.timeLeft)
        channelCollection.delegate = self
        channelCollection.dataSource = self
        channelCollection.backgroundColor = .clear
        setupDrawer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        drawerView.setConcealed(false, animated: true)
    }
    
    @IBAction func onStopTapped(_ sender: Any) {
        viewModel.startWorkout()
//        viewModel.client.close()
//        self.dismiss(animated: true)
    }
    
    private func setupDrawer() {
        drawerView.snapPositions = [.collapsed, .partiallyOpen, .open]
        drawerView.insetAdjustmentBehavior = .automatic
        drawerView.delegate = self
        drawerView.position = .partiallyOpen
    }
    
    func onFrequencyChanged(value: Int) {
        let freqPercent = Converter.valueToPercent(value: Float(value), minimum: 5, maximum: 100)
        let waveFreq = Converter.percentToValue(percent: freqPercent, minimum: minWaveFreq, maximum: maxWaveFreq, jump: 0.1)
        waveView.frequency = CGFloat(waveFreq)
        let delta = 1 - (CGFloat(waveFreq) - CGFloat(minWaveFreq)) / 2
        let acc = 0.05 * delta
        waveView.speed = 0.1 - acc
    }
    
    func onMasterChanged(value: Int) {
        waveView.master = CGFloat(value) / 100
    }
    
    private func updateTime(time: Int) {
        let timeLeft = Converter.secondsToTimeString(time)
        lblTimeLeft.text = timeLeft
    }
}

extension WorkoutViewController: DrawerViewDelegate {
    
}

// MARK: CollectionView Delegates
extension WorkoutViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,for: indexPath)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: channelCollection.frame.height - 20, height: channelCollection.frame.height - 20)
    }
}

extension WorkoutViewController: WorkoutViewModelDelegate {
    func onChannelChanged(channel: ChannelData) {

    }
    
    func onTimeTick() {
        self.updateTime(time: viewModel.timeLeft)
        progressView.progress = CGFloat(viewModel.progress)
    }
    
    func askForReconnect() {
        let alert = UIAlertController(title: "Device disconnected", message: "The connection was lost to the device. Do you want to try to reconnect?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
}
