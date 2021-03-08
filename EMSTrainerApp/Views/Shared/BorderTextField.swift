//
//  BorderTextField.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 08..
//

import UIKit

private enum Constants {
    static let offset: CGFloat = 10
    static let placeholderSize: CGFloat = 17
}
@IBDesignable
final class BorderTextField: UITextField {
    // MARK: IBInspectables
    
    @IBInspectable var backgroundViewColor: UIColor = .clear {
        didSet {
            self.backgroundView.backgroundColor = backgroundViewColor
            self.backgroundView.borderColor = backgroundViewColor
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.backgroundView.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.backgroundView.borderWidth = borderWidth
        }
    }
    
    // MARK: Subview
    private var backgroundView = RoundedView()
    
    // MARK: Private properties
    private var scale: CGFloat {
        Constants.placeholderSize / fontSize
    }
    
    private var fontSize: CGFloat {
        font?.pointSize ?? 0
    }
    
    private var labelHeight: CGFloat {
        ceil(font?.withSize(Constants.placeholderSize).lineHeight ?? 0)
    }
    
    private var textHeight: CGFloat {
        ceil(font?.lineHeight ?? 0)
    }
    
    private var isEmpty: Bool {
        text?.isEmpty ?? true
    }
    
    private var textInsets: UIEdgeInsets {
        UIEdgeInsets(top: Constants.offset, left: Constants.offset, bottom: Constants.offset, right: Constants.offset)
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UITextField
    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: textInsets.top + textHeight + textInsets.bottom)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        //           updateLabel(animated: false)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard !isFirstResponder else {
            return
        }
        
        //        label.transform = .identity
        //        label.frame = bounds.inset(by: textInsets)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        borderStyle = .none
        
        //        border.backgroundColor = .inactive
        backgroundView.isUserInteractionEnabled = false
        addSubview(backgroundView)
        //
        //        label.textColor = .inactive
        //        label.font = font
        //        label.text = placeholder
        //        label.isUserInteractionEnabled = false
        //        addSubview(label)
        
        addTarget(self, action: #selector(handleEditing), for: .allEditingEvents)
    }
    
    @objc
    private func handleEditing() {
        //           updateLabel()
        updateBorder()
    }
    
    
    private func updateBorder() {
        let borderColor = isFirstResponder ? tintColor : .clear
        UIView.animate(withDuration: 0) {
            self.backgroundView.borderColor = borderColor!
        }
    }
}
