//
//  RightIconButton.swift
//  GCRecord
//
//  Created by Prank on 18/11/24.
//

import UIKit

public class RightIconButton: UIButton {
    // Callback property
    public var didSelectButton: (() -> Void)?
    
    // Add a target for the button's action
    public init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        // Trigger the callback when the button is tapped
        didSelectButton?()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        
        // Adjust title label position
        titleLabel.frame.origin.x = 0
        
        // Adjust image view position
        let imageX = bounds.width - imageView.frame.width - 8
        imageView.frame.origin.x = imageX
        
        // Center the title and image vertically
        titleLabel.center.y = bounds.height / 2
        imageView.center.y = bounds.height / 2
        
        // set alight left for tex is 10
        titleLabel.frame.origin.x = 10
        
    }
}

