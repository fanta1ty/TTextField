![LOGO](https://github.com/fanta1ty/TTextField/blob/master/ScreenShot/Logo.png)

# TTextField
TTextField is developed to help developers can initiate a fully standard textfield including title, placeholder and error message in fast and convinient way without having to write many lines of codes
  
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-brightgreen)](https://developer.apple.com/swift/)
[![Version](https://img.shields.io/cocoapods/v/TTextField.svg?style=flat)](https://cocoapods.org/pods/TTextField)
[![License](https://img.shields.io/cocoapods/l/TTextField.svg?style=flat)](https://cocoapods.org/pods/TTextField)
[![Platform](https://img.shields.io/cocoapods/p/TTextField.svg?style=flat)](https://cocoapods.org/pods/TTextField)
[![Email](https://img.shields.io/badge/contact-@thinhnguyen12389@gmail.com-blue)](thinhnguyen12389@gmail.com)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TTextField is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TTextField'
```
## Usage
```swift
import TTextField
```

1) Initiate ``TTextField``
```swift
let textField = TTextField()
```

2) To show title, please input into ``title`` property
```swift
textField.title = "Email address"
```

3) To show the placeholder, please input into ``placeholder`` property
```swift
textField.placeholder = "Enter your work email address"
```

4) To enable/disable underline, please setup into ``isUnderline`` property
```swift
textField.isUnderline = true
```

5) To show error message, please input into ``errorMessage`` property
```swift
textField.errorMessage = "The e-mail address entered is incorrect"
```

6) To change settings more deeply, you can refer to the following functions and properties:
```swift
- underlineWidth: CGFloat
- inactiveUnderlineColor: UIColor
- inputRectLeftInset: CGFloat
- extraSpacingTitle: CGFloat
- appearanceFont: AppearanceFont
- errorImage: UIImage
- showsCaret: Bool

- func applyErrorUnderlineStyle()
- func applyNonErrorUnderlineStyle()
```

![alt text](https://github.com/fanta1ty/TTextField/blob/master/ScreenShot/Screen%20Shot%201.png)
![alt text](https://github.com/fanta1ty/TTextField/blob/master/ScreenShot/Screen%20Shot%202.png)

## Requirements
- iOS 9.3 or later
- Swift 5.0 or later

## Author

fanta1ty, thinhnguyen12389@gmail.com

## License

TTextField is available under the MIT license. See the LICENSE file for more info.
