//
//  DisconnectedCollectionViewCell.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 18..
//

import UIKit

protocol DisconnectedCollectionViewCellDelegate {
    func onReconnectTap()
}

class DisconnectedCollectionViewCell: UICollectionViewCell {

    var delegate: DisconnectedCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onReconnectTap(_ sender: Any) {
        delegate?.onReconnectTap()
    }
}
