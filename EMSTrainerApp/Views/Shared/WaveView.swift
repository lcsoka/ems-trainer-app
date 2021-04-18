//
//  WaveView.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 13..
//

import UIKit

struct Wave {
    let amplitude: CGFloat
    let lineWidth: CGFloat
    let opacity: CGFloat
}

fileprivate func attenuationFunction(x: CGFloat, factor: CGFloat, exponent: CGFloat = 4) -> CGFloat {
    return pow((factor / (factor + pow(x,exponent))),factor)
}

fileprivate func waveFunction(x:CGFloat, amplitude: CGFloat, spatialFrequency k: CGFloat, timeCoordinate t: CGFloat) -> CGFloat {
    return amplitude * sin(k*x - t)
}

fileprivate func line(x: CGFloat) {
    
}

@IBDesignable
class WaveView: UIView {
    
    private var phase: CGFloat = 0.0
    private var displayLink: CADisplayLink?
    private var animatingStart = false
    private var animatingStop = false
    private var currentAmplitude: CGFloat = 0.0
    
    private var waves: [Wave] = []
    private var shapeLayers: [CAShapeLayer] = []
    
    @IBInspectable
    public var layerCount: Int = 8 {
        didSet {
            initLayers()
        }
    }

    @IBInspectable
    public var amplitude: CGFloat = 0.8 {
        didSet {
            initLayers()
        }
    }
    
    @IBInspectable
    public var frequency: CGFloat = 2 {
        didSet {
            initLayers()
        }
    }
    
    @IBInspectable
    public var lineWidth: CGFloat = 2.0 {
        didSet {
            initLayers()
        }
    }
    
    @IBInspectable
    public var color: UIColor = .white
    
    @IBInspectable
    public var speed: CGFloat = 0.1
    
    
    public var master: CGFloat = 1.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var fakeMaster: CGFloat = 0.0 {
        didSet {
//            setNeedsLayout()
        }
    }
    
    public private(set) var animating = false
    
    // MARK: Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        drawLayers()
    }
    
    private func calculateWaveMaxAmplitude(for nth: Int) -> CGFloat {
        let max = amplitude
        let step = (amplitude / CGFloat(layerCount)) * 2.0
        return max - step * CGFloat(nth)
    }
    
    private func calculateWaveOpacity(for nth: Int) -> CGFloat {
        let min: CGFloat = 0.1
        let max: CGFloat = 1.0
        let step:CGFloat = (min + max) / CGFloat(layerCount)
        return max - CGFloat(nth)*step
    }
    
    private func initView() {
        
        self.clipsToBounds = true
        
        displayLink = CADisplayLink(target: self, selector: #selector(self.drawWaves))
        displayLink?.preferredFramesPerSecond = 60
        displayLink!.add(to: .main, forMode: .common)
    }
    
    private func initLayers() {
        
        waves = []
        
        // Remove existing layers
        for shape in shapeLayers {
            shape.removeFromSuperlayer()
        }
        
        shapeLayers = []
        
        let evenLayers = layerCount % 2 == 0
        let rangeEnd = evenLayers || layerCount == 1 ? layerCount : layerCount - 1
        
        for i in 0...rangeEnd {
            if evenLayers && i == rangeEnd / 2 {
                continue
            }
            
            let lWidth = i == 0 ? lineWidth : lineWidth / 2
            
            // Generate Wave
            waves.append(Wave(amplitude: calculateWaveMaxAmplitude(for:i), lineWidth: lWidth, opacity: calculateWaveOpacity(for: i)))
            
            // Create shape layer
            let shapeLayer = CAShapeLayer()
            
            // Add shape layer to this view's layer
            layer.addSublayer(shapeLayer)
            shapeLayers.append(shapeLayer)
        }
    }
    
    @objc private func drawWaves() {
        phase = (phase + CGFloat.pi * speed)
            .truncatingRemainder(dividingBy: 2 * CGFloat.pi)
        
        if fakeMaster <= master {
            fakeMaster = fakeMaster + 0.02
        }
        
        if fakeMaster > master {
            fakeMaster = fakeMaster - 0.02
            
            if fakeMaster <= 0.001 {
                fakeMaster = 0
            }
        }
        
        for i in 0..<shapeLayers.count {
            let shapeLayer = shapeLayers[i]
            let wave = waves[i]
            shapeLayer.path = bezierPath(for: wave).cgPath
        }
    }
    
    private func drawLayers() {
    
        let count = waves.count
        
        for i in 0 ..< count {
            let shapLayer = shapeLayers[i]
            let wave = waves[i]
            shapLayer.fillColor = UIColor.clear.cgColor
            shapLayer.lineWidth = wave.lineWidth
            shapLayer.strokeColor = color.withAlphaComponent(wave.opacity).cgColor
            shapLayer.lineJoin = .round
            shapLayer.lineCap = .round
            shapLayer.path = bezierPath(for: wave).cgPath
        }
    }
    
    private func bezierPath(for wave: Wave) -> UIBezierPath {
        let path = UIBezierPath()
        
        let width = frame.width
        let height = frame.height
        
        let centerX = width / 2
        let centerY = height / 2
        let scale = width / (frequency / 2)
        
        path.move(to: CGPoint(x: 0, y: centerY))
        
        for i in stride(from: 0, to: Int(width), by: 2) {
            let x = ((CGFloat(i) - centerX) / scale )
            let y = attenuationFunction(x: x, factor: 8) *  waveFunction(x: x, amplitude: wave.amplitude * fakeMaster, spatialFrequency: frequency, timeCoordinate: phase) * height / 2 + centerY
            path.addLine(to: CGPoint(x: CGFloat(i), y: y))
        }
        return path
    }
    
}
