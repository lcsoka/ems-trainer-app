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
    
    var chosen: Bool = false {
        didSet {
            if chosen {
                roundedView.borderColor = UIColor(named: "Green500")!
                roundedView.borderWidth = 2
            } else {
                roundedView.borderColor = .clear
                roundedView.borderWidth = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
