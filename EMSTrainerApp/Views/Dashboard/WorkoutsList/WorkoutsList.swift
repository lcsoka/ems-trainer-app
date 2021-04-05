//
//  WorkoutsList.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 02..
//

import UIKit

protocol WorkoutListDelegate {
    func onItemsChanged()
}

@IBDesignable
class WorkoutsList: UIView, CustomViewProtocol {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var stackView: UIStackView!
    
    private var padding = 10
    private var itemHeight = 85
    
    var delegate: WorkoutListDelegate?
    
    private var items: [Int] = [] {
        didSet {
            UIView.animate(withDuration: 0.2, animations: {
                self.invalidateIntrinsicContentSize()
                self.setupView()
                self.delegate?.onItemsChanged()
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(for: "WorkoutsList")
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(for: "WorkoutsList")
        setupView()
    }
    
    private func setupView() {
        
        for view in stackView.subviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        if items.count == 0 {
            // TODO: Add Not enough data view
            let view = NotEnoughDataView()
            stackView.addArrangedSubview(view)
        } else {
            for item in items {
                let view = WorkoutListItem()
                stackView.addArrangedSubview(view)
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        if items.count == 0 {
            return CGSize(width: frame.width, height: CGFloat(itemHeight))
        }
        
        return CGSize(width: frame.width, height: CGFloat(items.count) * CGFloat(itemHeight + padding))
    }
    
}
