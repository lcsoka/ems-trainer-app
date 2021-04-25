//
//  WorkoutsList.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 02..
//

import UIKit

protocol WorkoutListDelegate {
    func onItemsChanged()
    func onItemSelected(workout: Training)
}

class WorkoutTapGesture: UITapGestureRecognizer {
    var workout: Training!
}

@IBDesignable
class WorkoutsList: UIView, CustomViewProtocol {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var stackView: UIStackView!
    
    private var padding = 10
    private var itemHeight = 85
    
    var delegate: WorkoutListDelegate?
    
    var items: [Training] = [] {
        didSet {
//            UIView.animate(withDuration: 0.2, animations: {
                self.invalidateIntrinsicContentSize()
                self.setupView()
                self.delegate?.onItemsChanged()
//            })
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
                view.workout = item
                let heightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(itemHeight))
                view.addConstraint(heightConstraint)
                let tap = WorkoutTapGesture(target: self, action: #selector(self.handleTap(_:)))
                tap.workout = item
                
                view.addGestureRecognizer(tap)
                
                stackView.addArrangedSubview(view)
            }
        }
    }
    
    @objc private func handleTap(_ sender: WorkoutTapGesture) {
        delegate?.onItemSelected(workout: sender.workout)
    }
    
    override var intrinsicContentSize: CGSize {
        if items.count == 0 {
            return CGSize(width: frame.width, height: CGFloat(itemHeight))
        }
        
        return CGSize(width: frame.width, height: CGFloat(items.count) * CGFloat(itemHeight + padding))
    }
    
}
