//
//  TTextField.swift
//  TTextField
//
//  Created by Nguyen, Thinh on 31/07/2022.
//

import Foundation
import UIKit

private extension UIColor {
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

private extension TTextField {
    #if SWIFT_PACKAGE
    static let bundle = Bundle.module
    #else
    static let bundle = Bundle(for: TTextField.self)
    #endif
    

    enum Const {
        // MARK: - Colors

        static let primary500 = UIColor(rgb: 0x30C554)
        static let grayScale600 = UIColor(rgb: 0x858585)
        static let underlineColor = UIColor(rgb: 0xD0D0D0)
        static let error500 = UIColor(rgb: 0xFF1919)

        // MARK: - Fonts

        static let titleFont = UIFont.systemFont(ofSize: 12)
        static let errorFont = UIFont.systemFont(ofSize: 14)

        // MARK: - Image

        static let errorImage = UIImage(
            named: "danger_triangle",
            in: bundle,
            compatibleWith: nil
        )!

        // MARK: - Size

        static let defaultUnderlineWidth: CGFloat = 2.0
        static let underlineSpacing: CGFloat = 8.0
        static let errorIconSize: CGFloat = 16
        static let errorIconPadding: CGFloat = 8.0
        static let errorLabelSpacing: CGFloat = 8.0
        static let titleSpacing: CGFloat = 8.0
        static let horizontalInputViewSpacing: CGFloat = 12.0
    }

    struct ContentOption: OptionSet {
        static let underline = ContentOption(rawValue: 1 << 1)
        static let errorMessageLabel = ContentOption(rawValue: 1 << 2)
        static let titleLabel = ContentOption(rawValue: 1 << 3)

        var rawValue: UInt
        typealias RawValue = UInt

        init(rawValue: UInt) {
            self.rawValue = rawValue
        }
    }
}

public class TTextField: UITextField {
    // MARK: - Private Properties

    private var contentOptions: ContentOption = []
    private var underlineView: UIView?
    private var errorMessageLabel: UILabel?
    private var errorImageView: UIImageView?

    // MARK: - Public Properties

    public var titleLabel: UILabel?

    // MARK: - Computed Properties

    public var title: String? {
        didSet {
            if let title = title {
                contentOptions.insert(.titleLabel)

                if titleLabel == nil {
                    let tempLb = createTitle()
                    addSubview(tempLb)

                    titleLabel = tempLb
                }
                titleLabel?.text = title
            } else {
                contentOptions.remove(.titleLabel)
                titleLabel?.removeFromSuperview()
                titleLabel = nil
            }

            invalidateIntrinsicContentSize()
        }
    }

    public var isUnderline = false {
        didSet {
            if isUnderline {
                contentOptions.insert(.underline)

                if underlineView == nil {
                    let tempView = createUnderlineView()
                    addSubview(tempView)

                    underlineView = tempView
                }
            } else {
                contentOptions.remove(.underline)
                underlineView?.removeFromSuperview()
                underlineView = nil
            }

            invalidateIntrinsicContentSize()
        }
    }

    public var underlineWidth: CGFloat = Const.defaultUnderlineWidth {
        didSet {
            if isUnderline {
                setNeedsLayout()
            }
        }
    }

    public var inactiveUnderlineColor: UIColor = Const.underlineColor {
        didSet {
            updateUnderlineColor()
        }
    }

    private var underlineActiveColor: UIColor = Const.primary500 {
        didSet {
            updateUnderlineColor()
        }
    }

    private var underlineErrorColor: UIColor = Const.error500 {
        didSet {
            updateUnderlineColor()
        }
    }

    public var errorMessage: String? {
        didSet {
            if let message = errorMessage {
                contentOptions.insert(.errorMessageLabel)

                if errorMessageLabel == nil {
                    let tempLb = createErrorMessageLabel()
                    let tempImageView = UIImageView(image: errorImage)
                    addSubview(tempLb)
                    addSubview(tempImageView)

                    errorMessageLabel = tempLb
                    errorImageView = tempImageView
                }

                errorMessageLabel?.text = message
            } else {
                contentOptions.remove(.errorMessageLabel)
                errorMessageLabel?.removeFromSuperview()
                errorImageView?.removeFromSuperview()

                errorMessageLabel = nil
                errorImageView = nil
            }

            updateUnderlineColor()
            invalidateIntrinsicContentSize()
        }
    }

    public var inputRectLeftInset: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    public var extraSpacingTitle: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    public var appearanceFont = AppearanceFont() {
        didSet {
            font = appearanceFont.fieldFont
        }
    }

    public var errorImage: UIImage = Const.errorImage

    public var showsCaret = true

    @available(*, unavailable)
    public required init?(coder _: NSCoder) { nil }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        font = appearanceFont.fieldFont

        addTarget(self, action: #selector(updateUnderlineColor), for: .editingDidEnd)
        addTarget(self, action: #selector(updateUnderlineColor), for: .editingDidBegin)
    }

    override public class func isAccessibilityElement() -> Bool {
        false
    }

    override public func accessibilityElement(at index: Int) -> Any? {
        if index == 0 {
            return errorMessageLabel
        }
        return nil
    }

    override open func caretRect(for position: UITextPosition) -> CGRect {
        showsCaret ? super.caretRect(for: position) : .zero
    }

    override public var tintColor: UIColor? {
        didSet {
            underlineView?.backgroundColor = tintColor
            leftView?.tintColor = tintColor
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()

        if contentOptions.contains(.titleLabel) {
            titleLabel?.frame = titleLabelRectForBounds(bounds)
        }

        if contentOptions.contains(.underline) {
            underlineView?.frame = underlineViewRectForBounds(bounds)
        }

        if
            contentOptions.contains(.errorMessageLabel),
            let errorLabel = errorMessageLabel,
            let errorIcon = errorImageView
        {
            errorLabel.frame = errorLabelRectForBounds(bounds)
            errorIcon.frame = errorIconRectForOriginY(errorLabel.frame.origin.y)
        }
    }

    override public var intrinsicContentSize: CGSize {
        var height: CGFloat = 0

        if let font = font {
            height += ceil(font.ascender - font.descender)
        } else {
            height += 20
        }

        height += inputTopSpacing()

        if contentOptions.contains(.underline) {
            height += Const.underlineSpacing + underlineWidth
        }

        let errorHeight = errorLabelRectForBounds(bounds).height
        if errorHeight > 0 {
            height += errorHeight + Const.errorLabelSpacing
        }

        return CGSize(width: bounds.width, height: height)
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        inputRect(forBounds: bounds)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        inputRect(forBounds: bounds)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        inputRect(forBounds: bounds)
    }

    override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return CGRect(
            x: rect.origin.x,
            y: inputTopSpacing(),
            width: rect.width,
            height: rect.height
        )
    }
}

// MARK: - Public Functions

public extension TTextField {
    func applyErrorUnderlineStyle() {
        underlineView?.backgroundColor = underlineErrorColor
    }

    func applyNonErrorUnderlineStyle() {
        let color: UIColor = isEditing ? underlineActiveColor : inactiveUnderlineColor
        underlineView?.backgroundColor = color
    }

    @objc
    internal func updateUnderlineColor() {
        var color: UIColor

        if isEditing {
            color = errorMessage == nil ? underlineActiveColor : underlineErrorColor
        } else {
            color = errorMessage == nil ? inactiveUnderlineColor : underlineErrorColor
        }

        underlineView?.backgroundColor = color
    }
}

// MARK: - Private Functions

extension TTextField {
    private func createTitle() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = Const.grayScale600
        label.font = Const.titleFont

        return label
    }

    private func createUnderlineView() -> UIView {
        let tempView = UIView()
        tempView.backgroundColor = inactiveUnderlineColor

        return tempView
    }

    private func createErrorMessageLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = Const.grayScale600
        label.font = Const.errorFont
        label.numberOfLines = 0

        return label
    }

    private func titleLabelRectForBounds(_ bounds: CGRect) -> CGRect {
        guard let title = title, !title.isEmpty else {
            return CGRect.zero
        }

        let font: UIFont = titleLabel?.font ?? UIFont.systemFont(ofSize: 12.0)
        var containerBounds = bounds
        containerBounds.origin.x += inputRectLeftInset
        containerBounds.size.width -= inputRectLeftInset

        let boundingRect = boundingRect(for: title, with: font, containerBounds: containerBounds)

        return CGRect(
            x: inputRectLeftInset,
            y: 0,
            width: ceil(boundingRect.size.width),
            height: ceil(boundingRect.size.height)
        )
    }

    private func boundingRect(
        for text: String,
        with font: UIFont,
        containerBounds bounds: CGRect
    )
        -> CGRect
    {
        let textAttributes = [NSAttributedString.Key.font: font]
        let constraint = CGSize(
            width: bounds.size.width,
            height: .greatestFiniteMagnitude
        )

        let boundingRect = text.boundingRect(
            with: constraint,
            options: .usesLineFragmentOrigin,
            attributes: textAttributes,
            context: nil
        )
        return boundingRect
    }

    private func underlineViewRectForBounds(_ bounds: CGRect) -> CGRect {
        guard contentOptions.contains(.underline) else {
            return CGRect.zero
        }

        return CGRect(
            x: 0,
            y: inputRect(forBounds: bounds).maxY + Const.underlineSpacing,
            width: bounds.width,
            height: underlineWidth
        )
    }

    private func inputRect(forBounds bounds: CGRect) -> CGRect {
        let inputHeight = inputHeight(forBounds: bounds)
        var rect = CGRect(
            x: inputRectLeftInset,
            y: inputTopSpacing(),
            width: bounds.width - inputRectLeftInset,
            height: inputHeight
        )

        if let imageView = leftView {
            let offset = imageView.frame.maxX + Const.horizontalInputViewSpacing
            rect.origin.x += offset
            rect.size.width -= offset
        }

        if let button = rightView {
            let offset = button.frame.width + Const.horizontalInputViewSpacing
            rect.size.width -= offset
        }

        return rect
    }

    private func inputHeight(forBounds bounds: CGRect) -> CGFloat {
        let errorHeight = errorLabelRectForBounds(self.bounds).height
        let errorLabelSpacing = errorHeight == 0 ? 0 : Const.errorLabelSpacing
        let underlineWidth: CGFloat = contentOptions.contains(.underline) ? underlineWidth : 0
        let topSpacing = inputTopSpacing()
        let height = ceil(bounds.height - errorHeight - errorLabelSpacing - underlineWidth - Const.underlineSpacing - topSpacing)
        return height
    }

    private func errorLabelRectForBounds(_ bounds: CGRect) -> CGRect {
        guard let message = errorMessage, !message.isEmpty else { return .zero }

        let imageWidth = Const.errorIconSize + (Const.errorIconPadding * 2)
        let font: UIFont = errorMessageLabel?.font ?? UIFont.systemFont(ofSize: 14.0)

        let containerBounds = CGRect(
            origin: bounds.origin,
            size: CGSize(
                width: bounds.width - imageWidth,
                height: bounds.height
            )
        )

        let boundingRect = boundingRect(
            for: message,
            with: font,
            containerBounds: containerBounds
        )

        return CGRect(
            x: imageWidth,
            y: bounds.height - ceil(boundingRect.size.height),
            width: boundingRect.width,
            height: ceil(boundingRect.size.height)
        )
    }

    private func inputTopSpacing() -> CGFloat {
        if contentOptions.contains(.titleLabel) {
            return titleLabelRectForBounds(bounds).height + Const.titleSpacing + extraSpacingTitle
        }

        return 0
    }

    private func errorIconRectForOriginY(_ originY: CGFloat) -> CGRect {
        CGRect(
            x: Const.errorIconPadding,
            y: originY,
            width: Const.errorIconSize,
            height: Const.errorIconSize
        )
    }
}
