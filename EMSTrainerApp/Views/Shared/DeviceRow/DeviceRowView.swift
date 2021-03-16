//
//  DeviceRowView.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import UIKit

class DeviceRowView: UIView, CustomViewProtocol {
    @IBOutlet var contentView: UIView!
    @IBOutlet var lblDeviceName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(for: "DeviceRowView")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(for: "DeviceRowView")
    }
}
