//
//  TrainingModeSelectorView.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import UIKit

protocol TrainingModeSelectorViewDelegate {
    func onTrainingModeSelected(_ mode: TrainingMode)
}

@IBDesignable
class TrainingModeSelectorView: UIView, CustomViewProtocol {
    @IBOutlet var contentView: UIView!
    @IBOutlet var stackView: UIStackView!
    
    private var options: [TrainingModeOptionView] = []
    
    var delegate: TrainingModeSelectorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(for: "TrainingModeSelectorView")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(for: "TrainingModeSelectorView")
    }
    
    func setupView(trainingModes: [TrainingMode]) {
        options = []
        for mode in trainingModes {
            let view = TrainingModeOptionView()
            options.append(view)
            view.mode = mode
            view.delegate = self
            stackView.addArrangedSubview(view)
        }
    }
}

extension TrainingModeSelectorView: TrainingModeOptionDelegate {
    func onTrainingModeSelected(_ view: TrainingModeOptionView) {
        for option in options {
            option.selected = false
        }
        view.selected = true
        if let mode = view.mode {
            delegate?.onTrainingModeSelected(mode)
        }
    }
}
