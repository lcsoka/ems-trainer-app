//
//  ProgressView.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 27..
//

import UIKit

@IBDesignable
class ProgressView: UIView {
    
    private let progressLayer = CAShapeLayer()
    
    @IBInspectable var color: UIColor? = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var progress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          setupLayers()
      }

      required init?(coder: NSCoder) {
          super.init(coder: coder)
          setupLayers()
      }

      private func setupLayers() {
          layer.addSublayer(progressLayer)
      }
    
    override func draw(_ rect: CGRect) {
        let progressRect = CGRect(origin: .zero, size: CGSize(width:rect.width * progress, height: rect.height))
        let path = UIBezierPath(roundedRect: progressRect, cornerRadius: 2)
        
        progressLayer.fillColor = color?.cgColor
        progressLayer.lineWidth = 0
        progressLayer.strokeColor = color?.cgColor
        progressLayer.lineJoin = .round
        progressLayer.lineCap = .round
//        progressLayer.path = path.cgPath
        progressLayer.backgroundColor = color?.cgColor
        
        let anim = CABasicAnimation(keyPath: "path")
        anim.fromValue = progressLayer.path
        anim.toValue = path.cgPath
        anim.duration = 0.1
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLayer.add(anim, forKey: nil)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.path = path.cgPath
        CATransaction.commit()
        
    }
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //    }
    //
    //    private func initLayer() {
    //        if progressLayer != nil {
    //            progressLayer!.removeFromSuperlayer()
    //        }
    //
    //        progressLayer = CAShapeLayer()
    //        layer.addSublayer(progressLayer!)
    //    }
}
