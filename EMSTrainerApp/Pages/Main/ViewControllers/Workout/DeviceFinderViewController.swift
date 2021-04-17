//
//  DeviceFinderViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 17..
//

import UIKit

protocol DeviceFinderViewControllerDelegate {
    func onConnectDevice(device: DeviceHost)
}

class DeviceFinderViewController: UIViewController, MainStoryboardLodable {

    @IBOutlet var deviceFinderView: DeviceFinderView!
    @IBOutlet var connectButton: RoundedButton!
    
    var viewModel: FinderViewModel!
    var delegate: DeviceFinderViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isOpaque = false

        deviceFinderView.viewModel = viewModel
        deviceFinderView.delegate = self
        viewModel!.finderViewModelDelegate = self
        refreshButton()
        viewModel!.startSearch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel!.stopSearch()
    }
    
    func refreshButton() {
        connectButton.disabled = viewModel?.selectedDevice == nil
    }

    @IBAction func onCancelTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onConnectTap(_ sender: Any) {
        delegate?.onConnectDevice(device: viewModel!.selectedDevice!)
        self.dismiss(animated: true)
    }
}

extension DeviceFinderViewController: FinderViewModelDelegate {
    func onDeviceListRefresh() {
        deviceFinderView.reloadData()
        refreshButton()
    }
}

extension DeviceFinderViewController: DeviceFinderViewDelegate {
    func onDeviceSelected() {
        refreshButton()
    }
}
