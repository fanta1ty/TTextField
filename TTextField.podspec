Pod::Spec.new do |s|
  s.name             = 'TTextField'
  s.version          = '1.0.2'
  s.summary          = 'TTextField is a simple and flexible UI component fully written in Swift.'
  s.description      = 'TTextField is developed to help developers can initiate a fully standard textfield including title, placeholder and error message in fast and convinient way without having to write many lines of codes'

  s.homepage         = 'https://github.com/fanta1ty/TTextField'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fanta1ty' => 'thinhnguyen12389@gmail.com' }
  s.source           = { :git => 'https://github.com/fanta1ty/TTextField.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '11.0'
  s.platform = :ios, '11.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/TTextField/**/*.{swift}'
  s.resources = 'Sources/TTextField/Resources/*.xcassets'
end
