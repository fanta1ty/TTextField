//
//  ViewController+ContentView.swift
//  TTextField_Example
//
//  Created by Nguyen, Thinh on 31/07/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import TTextField

extension ViewController {
    final class ContentView: UIView {
        private lazy var stackView = UIStackView(arrangedSubviews: [
            textField
        ])
        
        let textField = TTextField()
        
        init() {
            super.init(frame: .zero)
            addSubviews()
            setupSubviews()
            setupLayout()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
    }
}

extension ViewController.ContentView {
    private func addSubviews() {
        addSubview(stackView)
    }
    
    private func setupSubviews() {
        backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.isLayoutMarginsRelativeArrangement = true
        
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor(rgb: 0x333333)
        textField.textAlignment = .left
        textField.title = "Email address"
        textField.placeholder = "Enter your work email address"
        textField.isUnderline = true
    }
    
    private func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
