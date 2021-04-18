//
//  WorkoutViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 21..
//

import UIKit

protocol WorkoutViewControllerDelegate {
    func onShowDeviceFinder(from: WorkoutViewController)
    func onShowChannelSettings(from: WorkoutViewController, channel: Int)
    func onReconnect(with: DeviceHost, from: WorkoutViewController)
    func onWorkoutEnded(from: WorkoutViewController)
}

class WorkoutViewController: UIViewController, MainStoryboardLodable {

    @IBOutlet var lblTimeLeft: UILabel!
    @IBOutlet var lblMaster: UILabel!
    @IBOutlet var waveView: WaveView!
    @IBOutlet var progressView: ProgressView!
    @IBOutlet var channelContainer: UIView!
    @IBOutlet var channelCollection: UICollectionView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var btnStartPause: RoundedButton!
    @IBOutlet var impulseLeftView: RoundedView!
    @IBOutlet var lblImpulseLeft: UILabel!
    @IBOutlet var lblBattery: UILabel!
    
    var viewModel: WorkoutViewModel!
    
    var delegate: WorkoutViewControllerDelegate?
    
    private var minWaveFreq: Float = 4
    private var maxWaveFreq: Float = 6
    
    private var reuseIdentifier = "testCell"
    private let disconnectedCellIdentifier = "DisconnectedCollectionViewCell"
    private let channelCellIdentifier = "ChannelCollectionViewCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTime(time: viewModel.timeLeft)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        collectionView.register(UINib(nibName: disconnectedCellIdentifier, bundle: Bundle(for: DisconnectedCollectionViewCell.self)), forCellWithReuseIdentifier: disconnectedCellIdentifier)
        
        collectionView.register(UINib(nibName: channelCellIdentifier, bundle: Bundle(for: ChannelCollectionViewCell.self)), forCellWithReuseIdentifier: channelCellIdentifier)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        waveView.master = CGFloat(viewModel.master)
        impulseLeftView.isHidden = true
        lblBattery.isHidden = true
    }
    
    func onMasterChanged(value: Int) {
        lblMaster.text = "\(value)%"
        updateWaveMaster()
    }
    
    private func updateTime(time: Int) {
        let timeLeft = Converter.secondsToTimeString(time)
        lblTimeLeft.text = timeLeft
    }
    
    private func updateWaveMaster() {
        waveView.master = (viewModel.impulseOn ? 1 : 0 ) * CGFloat(viewModel.master) / 100
    }
    
    func showDeviceFinder() {
        delegate?.onShowDeviceFinder(from: self)
    }
    
    func updateImpulseCounter() {
        
        if viewModel.impulseOn {
            lblImpulseLeft.textColor = UIColor.init(named: "Green500")
        } else {
            lblImpulseLeft.textColor = UIColor.init(named: "Green300")
        }
        
        lblImpulseLeft.text = "\(viewModel.impulseTimeLeft)s"
    }
    
    @IBAction func masterSliderChanged(_ sender: UISlider) {
        let newValue = Int(sender.value)

        if viewModel.master != newValue{
            viewModel.master = Int(sender.value)
        }
    }
    
    @IBAction func startPausePressed(_ sender: Any) {
        if !viewModel.started || viewModel.paused {
            viewModel.startWorkout(fromUser: true)
        } else {
            viewModel.pauseWorkout(fromUser: true)
        }
    }
    @IBAction func stopPressed(_ sender: Any) {
        viewModel.pauseWorkout()
        let alert = UIAlertController(title: "Stop workout", message: "Do you want to stop the workout?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.viewModel.stopWorkout()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    // MARK: Handle Increaser Button events
    
    @IBAction func startTouchingMasterIncreaser(_ sender: Any) {
        viewModel.startChangingMaster()
    }
    
    @IBAction func stopTouchingMasterIncreaserInside(_ sender: Any) {
        viewModel.stopValueChangerTimer()
    }
    
    @IBAction func stopTouchingMasterIncreaserOutside(_ sender: Any) {
        viewModel.stopValueChangerTimer()
    }
    
    @IBAction func cancelTouchingMasterIncreaser(_ sender: Any) {
        viewModel.stopValueChangerTimer()
    }
    
    // MARK: Handle Decreaser Button events
    @IBAction func startTouchingMasterDecreaser(_ sender: Any) {
        viewModel.startChangingMaster(increase: false)
    }
    @IBAction func stopTouchingMasterDecreaserInside(_ sender: Any) {
        viewModel.stopValueChangerTimer()
    }
    @IBAction func stopTouchingMasterDecreaserOutside(_ sender: Any) {
        viewModel.stopValueChangerTimer()
    }
    @IBAction func cancelTouchingMasterDecreaser(_ sender: Any) {
        viewModel.stopValueChangerTimer()
    }
    
}

// MARK: CollectionView Delegates
extension WorkoutViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            // View for the reconnect button
            return viewModel.disconnected ? 1 : 0
        } else {
            // Views for the channels
            return viewModel.channels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: disconnectedCellIdentifier, for: indexPath) as! DisconnectedCollectionViewCell
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: channelCellIdentifier,for: indexPath) as! ChannelCollectionViewCell
            
            let channelIndex = indexPath.row
            let channelData = viewModel.channels[channelIndex]
            
            cell.index = channelIndex
            cell.data = channelData!
            
            if viewModel.disconnected {
                cell.alpha = 0.5
                cell.isUserInteractionEnabled = false
            } else {
                cell.alpha = 1
                cell.isUserInteractionEnabled = true
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            delegate?.onShowChannelSettings(from: self, channel: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 40)
        } else {
            return CGSize(width: collectionView.frame.width / 2 - 5, height: 80)
        }
    }
}
// MARK: WorkoutViewModelDelegate
extension WorkoutViewController: WorkoutViewModelDelegate {
    
    func onChannelChanged(channel: Int) {
        let indexPath = IndexPath(row: channel, section: 1)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func onTimeTick() {
        self.updateTime(time: viewModel.timeLeft)
        progressView.progress = CGFloat(viewModel.progress)
        updateImpulseCounter()
    }
    
    func askForReconnect() {
        let alert = UIAlertController(title: "Device disconnected", message: "The connection was lost to the device. Do you want to try to reconnect?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.showDeviceFinder()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    func onWorkoutStatusChanged() {
        var label = "START"
        
        if viewModel.started {
            if !viewModel.paused {
                label = "PAUSE"
            }
        }
        
        btnStartPause.setTitle(label, for: .normal)
    }
    
    func onImpulseChanged() {
        updateWaveMaster()
        if viewModel.paused {
            impulseLeftView.isHidden = true
        } else {
            impulseLeftView.isHidden = false
        }
        updateImpulseCounter()
    }
    
    func shouldUpdateView() {
        collectionView.reloadData()
    }
    
    func onBatteryChange(percent: Int) {
        lblBattery.isHidden = false
        lblBattery.text = "\(percent)%"
    }
    
    func onWorkoutEnd() {
        delegate?.onWorkoutEnded(from: self)
    }
}

// MARK: DeviceFinderViewControllerDelegate
extension WorkoutViewController: DeviceFinderViewControllerDelegate {
    func onConnectDevice(device: DeviceHost) {
        delegate?.onReconnect(with: device, from: self)
    }
}

extension WorkoutViewController: DisconnectedCollectionViewCellDelegate {
    func onReconnectTap() {
        self.showDeviceFinder()
    }
}
