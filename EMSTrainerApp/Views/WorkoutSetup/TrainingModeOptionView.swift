//
//  TrainingModeOptionView.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import UIKit

protocol TrainingModeOptionDelegate {
    func onTrainingModeSelected(_ view: TrainingModeOptionView)
}

@IBDesignable
class TrainingModeOptionView: UIView, CustomViewProtocol {
    @IBOutlet var contentView: UIView!
    @IBOutlet var imageContainer: RoundedView!
    @IBOutlet var lblName: UILabel!
    
    var delegate: TrainingModeOptionDelegate?
    
    public var selected: Bool = false {
        didSet {
            if selected {
                imageContainer.borderColor = UIColor(named: "Green500")!
                imageContainer.borderWidth = 2
            } else {
                imageContainer.borderColor = .clear
                imageContainer.borderWidth = 0
            }
        }
    }
    
    var mode: TrainingMode? {
        didSet {
            lblName.text = mode!.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(for: "TrainingModeOptionView")
        afterInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(for: "TrainingModeOptionView")
        afterInit()
    }
    
    private func afterInit() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.onTrainingModeSelected(self)
    }
}
