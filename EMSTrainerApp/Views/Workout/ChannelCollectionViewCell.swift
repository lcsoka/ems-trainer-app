//
//  ChannelCollectionViewCell.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 18..
//

import UIKit

class ChannelCollectionViewCell: UICollectionViewCell {

    @IBOutlet var lblChannelName: UILabel!
    @IBOutlet var lblChannelValue: UILabel!
    @IBOutlet var lblChannelFreq: UILabel!
    
    var index: Int! {
        didSet {
            lblChannelName.text = EMSChannelMap[index]?.capitalized
        }
    }
    
    var data: ChannelData! {
        didSet {
            lblChannelValue.text = "\(data.value)%"
            lblChannelFreq.text = "\(Int(Converter.freqPercentToValue(percent: Float(data.freq)))) Hz"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
