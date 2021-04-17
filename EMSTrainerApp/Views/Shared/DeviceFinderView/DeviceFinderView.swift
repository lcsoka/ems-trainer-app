//
//  DeviceFinderView.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 17..
//

import UIKit

@IBDesignable
class DeviceFinderView: UIView, CustomViewProtocol {

    var contentView: UIView!
    @IBOutlet private var collectionView: UICollectionView!
    let deviceCellIdentifier = "DeviceRowCollectionViewCell"
    let emptyCellIdentifier = "EmptyCollectionViewCell"
    
    var viewModel: FinderViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(for: "DeviceFinderView")
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(for: "DeviceFinderView")
        setupView()
    }
    
    private func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: deviceCellIdentifier, bundle: nil), forCellWithReuseIdentifier: deviceCellIdentifier)
        collectionView.register(UINib.init(nibName: emptyCellIdentifier, bundle: nil), forCellWithReuseIdentifier: emptyCellIdentifier)
        collectionView.backgroundColor = .clear
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
}

extension DeviceFinderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.devices.isEmpty ? 1 : viewModel.devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.devices.isEmpty {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellIdentifier, for: indexPath as IndexPath) as! EmptyCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deviceCellIdentifier, for: indexPath) as! DeviceRowCollectionViewCell
            let device = viewModel.devices.map{$0.value.host}[indexPath.row]
            cell.chosen = device == viewModel.selectedDevice
            cell.device = device
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DeviceRowCollectionViewCell {
            viewModel.selectedDevice = cell.device
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DeviceRowCollectionViewCell {
//            cell.chosen = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel.devices.isEmpty {
            return CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.height - 20)
        } else {
            return CGSize(width: collectionView.frame.width - 20, height: 80)
        }
    }
}
