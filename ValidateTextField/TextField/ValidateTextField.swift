//
//  ValidateTextField.swift
//  ValidateTextField
//
//  Created by Udit on 28/06/19.
//  Copyright © 2019 uDemo. All rights reserved.
//

import UIKit
//import Validator

protocol ValidateTextFieldDelegate {
    func errorLabelHeightUpdated(newHeight: CGFloat)
}

public enum ValidateTextFieldState: String {
    case empty
    case focused
    case filled
    case error
}

open class ValidateTextField: UITextField {
    
    public var errorMessage: String? {
        didSet { updateUI() }
    }
    
    public var titleText: String? {
        didSet { updateUI() }
    }
    
    open var style: Style = Style.default {
        didSet {
            textColor = style.textColor
            updateUI()
        }
    }
    
    open override var text: String? {
        get {
            return super.text
        }
        set {
            super.text = newValue
            fillState = isEmpty ? .empty : .filled
            updateUI()
        }
    }
    
    var themeDelegate: ValidateTextFieldDelegate?
    
    // MARK: - Constants
    let errorHeight: CGFloat = 16
    let errorYMargin: CGFloat = 8
    let fontMultiplier: CGFloat = 11.0 / 12.0
    
    // MARK: - Private
    private var titleLabel: UILabel!
    private var lineView: UIView!
    private var lineViewHeight: NSLayoutConstraint!
    private var errorLabel: UILabel!
    private var fillState = ValidateTextFieldState.empty
    
    var isEmpty: Bool { return text?.isEmpty ?? true }
    
    // MARK: - Lifecycle
    var isSetUp = false
    lazy var setupOnce: () -> Void = {
        defer {
            updateUI()
        }
        self.setup()
        self.isSetUp = true
        return {}
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        borderStyle = .none
        layer.borderWidth = 0.5
        layer.borderColor = ColorConstants.textFieldTextColor.cgColor
        layer.cornerRadius = 0.0
        backgroundColor = .white
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setupOnce()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return textBoundsWithInset(forBounds: bounds)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textBoundsWithInset(forBounds: bounds)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textBoundsWithInset(forBounds: bounds)
    }
    
    private func textBoundsWithInset(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8.8, dy: 0.0)
    }
    
    // MARK: - Setup
    internal func setup() {
        setTitleLabel()
        setLineView()
        setErrorView()
        setControlEventObservers()
        
        clipsToBounds = false
    }
    
    private func setTitleLabel() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        
        titleLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -errorYMargin).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: errorHeight).isActive = true
        
        guard let font = self.font else { return }
        titleLabel.font = font.withSize(font.pointSize * fontMultiplier)
    }
    
    private func setLineView() {
        let lineHeight = style.lineHeight(forState: .empty)
        lineView?.removeFromSuperview()
        lineView = UIView(frame: CGRect(x: 0, y: bounds.height, width: bounds.width, height: lineHeight))
        lineView.backgroundColor = style.lineColor(forState: .empty)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(lineView)
        
        let evenSpacing: CGFloat = Int(lineHeight) % 2 == 0 ? 0 : 0.5
        
        lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        lineView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: evenSpacing).isActive = true
        lineViewHeight = lineView.heightAnchor.constraint(equalToConstant: lineHeight)
        lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lineViewHeight.isActive = true
    }
    
    private func setErrorView() {
        errorLabel = UILabel(frame: .zero)
        errorLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.numberOfLines = 0
        
        addSubview(errorLabel)
        
        errorLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: errorYMargin).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        //        errorLabel.heightAnchor.constraint(equalToConstant: errorHeight).isActive = true
        
        guard let font = self.font else { return }
        errorLabel.font = font.withSize(font.pointSize * fontMultiplier)
    }
    
//    public func setValidationRules(rules: ValidationRuleSet<String>) {
//        self.validationRules = rules
//        self.validateOnEditingEnd(enabled: true)
//        self.validationHandler = { result in self.updateValidationState(result: result) }
//    }
//    
//    func updateValidationState(result: ValidationResult) {
//        switch result {
//        case .valid:
//            self.errorMessage = nil
//        case .invalid(let failures):
//            if let errorMessage = failures.first as? ValidationError {
//                self.errorMessage = errorMessage.message
//            } else {
//                self.errorMessage = nil
//            }
//        }
//    }
    
    private func setControlEventObservers() {
        addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
    }
    
    // MARK: - Control Events
    @objc func didBeginEditing() {
        fillState = .focused
        updateUI()
    }
    
    @objc func didEndEditing() {
        fillState = isEmpty ? .empty : .filled
        updateUI()
    }
    
    private func updateUI() {
        guard isSetUp else { return }
        titleLabel.text = titleText
        titleLabel.textColor = style.titleColor
        
        switch fillState {
        case .empty:
            fillState = .filled
            lineView.backgroundColor = style.lineColor(forState: .empty)
        case .focused, .filled:
            lineView.backgroundColor = style.lineColor(forState: .focused)
        case .error:
            lineView.backgroundColor = style.lineColor(forState: .error)
        }
        
        set(error: errorMessage)
    }
    
    private func set(error message: String?) {
        errorLabel.text = message
        
        let visible = message != nil
        let color = visible ? style.errorMessageColor : style.lineColor(forState: fillState)
        errorLabel.textColor = color
        
        errorLabel.isHidden = !visible
        lineViewHeight.constant = visible ? style.lineHeight(forState: .error) :
            style.lineHeight(forState: fillState)
        
        lineView.backgroundColor = color
        self.lineView.superview?.setNeedsLayout()
        
        if let delegate = themeDelegate {
            var font = self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
            font = font.withSize(font.pointSize * fontMultiplier)
            let errorHeight = heightForText(message, withConstrainedWidth: errorLabel.frame.size.width, font: font) + 2*errorYMargin
            delegate.errorLabelHeightUpdated(newHeight: errorHeight)
        }
    }
    
    func heightForText(_ text: String?, withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        guard let text = text else {
            return 0.0
        }
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
}

extension ValidateTextField {
    public struct Style {
        public var tintColor: UIColor
        public var textColor: UIColor
        public var errorMessageColor: UIColor
        public var titleColor: UIColor
        public var lines: [ValidateTextFieldState: (color: UIColor, height: CGFloat)]
        
        private static let lineHeight = CGFloat(8.0)
        
        public func lineColor(forState state: ValidateTextFieldState) -> UIColor {
            return lines[state]?.color ?? tintColor
        }
        
        public func lineHeight(forState state: ValidateTextFieldState) -> CGFloat {
            return lines[state]?.height ?? 1
        }
        
        public mutating func setLine(color: UIColor, forState state: ValidateTextFieldState) {
            guard var line = lines[state] else { return }
            line.color = color
            lines[state] = line
        }
        
        public mutating func setLine(height: CGFloat, forState state: ValidateTextFieldState) {
            guard var line = lines[state] else { return }
            line.height = height
            lines[state] = line
        }
        
        // MARK: - Themes
        public static var `default`: ValidateTextField.Style {
            let lines: [ValidateTextFieldState: (color: UIColor, height: CGFloat)] = [
                .empty: (color: .clear, height: lineHeight),
                .filled: (color: .clear, height: lineHeight),
                .focused: (color: ColorConstants.lightGray, height: lineHeight),
                .error: (color: ColorConstants.errorColor, height: lineHeight)
            ]
            
            return ValidateTextField.Style(tintColor: ColorConstants.textFieldTextColor,
                                        textColor: ColorConstants.textFieldTextColor,
                                        errorMessageColor: ColorConstants.errorColor,
                                        titleColor: .black,
                                        lines: lines)
        }
        
        public static var dark: ValidateTextField.Style {
            let lines: [ValidateTextFieldState: (color: UIColor, height: CGFloat)] = [
                .empty: (color: .clear, height: lineHeight),
                .filled: (color: .clear, height: lineHeight),
                .focused: (color: .white, height: lineHeight),
                .error: (color: ColorConstants.errorColor, height: lineHeight)
            ]
            
            return ValidateTextField.Style(tintColor: ColorConstants.textFieldTextColor,
                                           textColor: ColorConstants.textFieldTextColor,
                                           errorMessageColor: ColorConstants.errorColor,
                                           titleColor: .red,
                                           lines: lines)
        }
    }
}

extension ValidateTextFieldDelegate {
    func errorLabelHeightUpdated(newHeight: CGFloat) { }
}

