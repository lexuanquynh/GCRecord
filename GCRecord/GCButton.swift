//
//  GCButton.swift
//  GooCo
//
//  Created by GCS_PC0092 on 2018/06/07.
//  Copyright © 2018年 グッドサイクルシステム. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class GCButton: UIButton {
    enum GradientColorType {
        case gray
        case green
        case blue
        case grayFlat
        case registButton
        case header
        case warning
        case sattoCategory
        case lightGray
        case lightOrange
        case lightBlue
        case lightPink
        
        func getColors(alpha: CGFloat = 1) -> [UIColor] {
            let topColor: UIColor
            let bottomColor: UIColor
            switch self {
            case .gray:
                topColor = .white
                bottomColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: alpha)
            case .green:
                topColor = .white
                bottomColor = UIColor(red: 200/255, green: 255/255, blue: 215/255, alpha: 1.0)
            case .blue:
                topColor = .white
                bottomColor = UIColor(red: 0.75, green: 1.0, blue: 1.0, alpha: alpha)
            case .grayFlat:
                topColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: alpha)
                bottomColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: alpha)
            case .registButton:
                topColor = UIColor(red: 0.10, green: 0.84, blue: 0.99, alpha: alpha)
                bottomColor = UIColor(red: 0.11, green: 0.38, blue: 0.94, alpha: alpha)
            case .header:
                topColor = UIColor(red: 0.86, green: 0.87, blue: 0.87, alpha: alpha)
                bottomColor = UIColor(red: 0.54, green: 0.55, blue: 0.56, alpha: alpha)
            case .warning:
                topColor = UIColor(red: 1, green: 1, blue: 1, alpha: alpha)
                bottomColor = UIColor(red: 1, green: 0.8196, blue: 0.5882, alpha: alpha)
            case .sattoCategory:
                topColor = UIColor(red: 0.64, green: 0.91, blue: 0.53, alpha: 0.6)
                bottomColor = UIColor(red: 0.35, green:0.83, blue: 0.15, alpha: 0.6)
            case .lightGray:
                topColor = UIColor(white: 0.863, alpha: 1)
                bottomColor = UIColor(white: 0.557, alpha: 1)
            case .lightOrange:
                topColor = UIColor(red: 0.997, green: 0.855, blue: 0.674, alpha: 1)
                bottomColor = UIColor(red: 0.996, green: 0.733, blue: 0.407, alpha: 1)
            case .lightBlue:
                topColor = UIColor(red: 0.676, green: 0.902, blue: 0.997, alpha: 1)
                bottomColor = UIColor(red: 0.449, green: 0.793, blue: 0.953, alpha: 1)
            case .lightPink:
                topColor = UIColor(red: 1, green: 0.631, blue: 0.631, alpha: 1)
                bottomColor = UIColor(red: 1, green: 0.580, blue: 0.831, alpha: 1)
            }
            
            return [topColor, bottomColor]
        }
    }
    
    @IBInspectable var topColor: UIColor? {
        didSet {
            if let topColor = topColor, let bottomColor = bottomColor {
                self.applyGradient(colours: [topColor, bottomColor])
            }
        }
    }
    
    @IBInspectable var bottomColor: UIColor? {
        didSet {
            if let topColor = topColor, let bottomColor = bottomColor {
                self.applyGradient(colours: [topColor, bottomColor])
            }
        }
    }
    
    private let gradient: CAGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.applyGradientButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
        self.applyGradientButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
    }
    
    private func setupUI() {
        self.setTitleColor(.white, for: .highlighted)
    }
    
    func setGradient(type: GradientColorType, alpha: CGFloat = 1) {
        self.applyGradient(colours: type.getColors(alpha: alpha))
    }
    
    func setGradient(topColor: UIColor, bottomColor: UIColor) {
        self.applyGradient(colours: [topColor, bottomColor])
    }
    
    /// Apply default gradient in runtime
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]? = nil) -> CAGradientLayer {
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        return gradient
    }
    
    /// Apply default gradient when init button
    func applyGradientButton(alpha: CGFloat = 1) {
        let topCgColor = topColor?.cgColor ?? UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: alpha).cgColor
        let bottomCgColor = bottomColor?.cgColor ?? UIColor.init(red: 0.64, green: 0.64, blue: 0.64, alpha: alpha).cgColor
        self.tintColor = .gray
        self.setTitleColor(.black, for: .normal)
        gradient.colors = [topCgColor, bottomCgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(gradient, at: 0)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
    }
}

// MARK: - SummaryButton
class SummaryButton: UIButton {
    private let colorName1 = "button_summary_1"
    private let colorName2 = "button_summary_2"
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAttributes()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupAttributes()
    }
    
    private func setupAttributes() {
        isExclusiveTouch = true
        setupGradient()
    }
    
    private func setupGradient() {
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor(named: colorName1)?.cgColor ?? UIColor.clear.cgColor,
            UIColor(named: colorName2)?.cgColor ?? UIColor.clear.cgColor,
        ]
        gradientLayer.cornerRadius = 4.0
        layer.replace(gradientLayer)
    }
}

class HeaderButton: UIButton {
    private let colorName1 = "button_mode_normal_1"
    private let colorName2 = "button_mode_normal_2"
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAttributes()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupAttributes()
    }
    
    private func setupAttributes() {
        isExclusiveTouch = true
        setupGradient()
    }
    
    private func setupGradient() {
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor(named: colorName1)!.cgColor,
            UIColor(named: colorName2)!.cgColor,
        ]
        gradientLayer.cornerRadius = 4.0
        layer.replace(gradientLayer)
    }
}

// MARK: - ToggleButton
class ToggleButton: UIButton {
    private let colorName1 = "button_toggle_unselect_1"
    private let colorName2 = "button_toggle_unselect_2"
    private let selectColorName1 = "button_toggle_select_1"
    private let selectColorName2 = "button_toggle_select_2"
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override var isSelected: Bool {
        didSet {
            setupGradient()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAttributes()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupAttributes()
    }
    
    private func setupAttributes() {
        isExclusiveTouch = true
        setupGradient()
    }
    
    private func setupGradient() {
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor(named: isSelected ? selectColorName1 : colorName1)!.cgColor,
            UIColor(named: isSelected ? selectColorName2 : colorName2)!.cgColor,
        ]
        gradientLayer.cornerRadius = 4.0
        layer.replace(gradientLayer)
    }
}

extension CALayer {
    func replace(_ layer: CALayer) {
        if let oldLayer = sublayers?[0] {
            replaceSublayer(oldLayer, with: layer)
        } else {
            insertSublayer(layer, at: 0)
        }
    }
}
