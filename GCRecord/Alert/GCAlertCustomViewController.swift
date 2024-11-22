//
//  GCAlertCustomViewController.swift
//  GCRecord
//
//  Created by Prank on 19/11/24.
//

import UIKit

class GCAlertCustomViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let checkBoxButton = UIButton(type: .system)
    private let checkBoxLabel = UILabel()
    private let cancelButton = UIButton(type: .system)
    private let okButton = UIButton(type: .system)
    
    // MARK: - Properties
    var titleText: String?
    var messageText: String?
    var checkBoxText: String = "I agree to the terms and conditions"
    var cancelButtonTitle: String = "Cancel"
    var okButtonTitle: String = "OK"
    var onOkTapped: ((Bool) -> Void)?
    var onCancelTapped: (() -> Void)?
    
    private var isCheckBoxSelected = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        // Container View
        let containerView = UIView()
        // background is groupTableViewBackground
        containerView.backgroundColor = UIColor.systemGroupedBackground
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        
        // Message
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.setContentHuggingPriority(.required, for: .vertical)
        
        // Checkbox
        checkBoxButton.setImage(UIImage(systemName: "square"), for: .normal)
        checkBoxButton.setImage(UIImage(named: "tick_ico"), for: .selected)
        checkBoxButton.addTarget(self, action: #selector(toggleCheckBox), for: .touchUpInside)
        // fix checkBoxButton width
        checkBoxButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        checkBoxLabel.font = UIFont.systemFont(ofSize: 14)
        checkBoxLabel.textAlignment = .left
        checkBoxLabel.numberOfLines = 2
        checkBoxLabel.lineBreakMode = .byWordWrapping
        
        // Buttons
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        // okButton font is bold
        okButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        okButton.setTitle(okButtonTitle, for: .normal)
        okButton.setTitleColor(.systemRed, for: .normal)
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        
        // StackViews
        let checkBoxStack = UIStackView(arrangedSubviews: [checkBoxButton, checkBoxLabel])
        checkBoxStack.axis = .horizontal
        checkBoxStack.spacing = 8
        
        let buttonsStack = UIStackView(arrangedSubviews: [cancelButton, okButton])
        buttonsStack.axis = .horizontal
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 16
        
        let mainStack = UIStackView(arrangedSubviews: [titleLabel, messageLabel, checkBoxStack, buttonsStack])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(mainStack)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
        ])
    }

    
    private func configureUI() {
        titleLabel.text = titleText
        messageLabel.text = messageText
        checkBoxLabel.text = checkBoxText
    }
    
    // MARK: - Actions
    @objc private func toggleCheckBox() {
        isCheckBoxSelected.toggle()
        checkBoxButton.isSelected = isCheckBoxSelected
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: onCancelTapped)
    }
    
    @objc private func okButtonTapped() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.onOkTapped?(self.isCheckBoxSelected)
        }
    }
    
    func setCancelButtonTitle(_ title: String) {
        cancelButtonTitle = title
    }
    
    func setOkButtonTitle(_ title: String) {
        okButtonTitle = title
    }
}
