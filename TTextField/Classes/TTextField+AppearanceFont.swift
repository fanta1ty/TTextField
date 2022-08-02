////
////  TTextField+AppearanceFont.swift
////  TTextField
////
////  Created by Nguyen, Thinh on 31/07/2022.
////

import Foundation

public extension TTextField {
    struct AppearanceFont {
        var fieldFont: UIFont
        var errorMessageFont: UIFont
        var titleFont: UIFont

        public init(fieldFont: UIFont = UIFont.systemFont(ofSize: 16),
                    errorMessageFont: UIFont = UIFont.systemFont(ofSize: 14),
                    titleFont: UIFont = UIFont.systemFont(ofSize: 12)) {
            self.fieldFont = fieldFont
            self.errorMessageFont = errorMessageFont
            self.titleFont = titleFont
        }
    }
}
