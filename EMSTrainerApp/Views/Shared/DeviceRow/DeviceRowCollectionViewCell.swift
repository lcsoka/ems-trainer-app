//
//  DeviceRowCollectionViewCell.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import UIKit

class DeviceRowCollectionViewCell: UICollectionViewCell {

    @IBOutlet var roundedView: RoundedView!
    @IBOutlet var lblSerial: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblBattery: UILabel!
    
    var device: DeviceHost? {
        didSet {
            if let device = device {
                lblSerial.text = device.serial
                lblAddress.text = device.address
                lblBattery.text = "\(device.battery)%"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
