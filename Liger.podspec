Pod::Spec.new do |s|
  s.name         = "Liger"
  s.version      = "0.0.7"
  s.summary      = "A framework to help building HTML5 apps using native navigation."

  s.description  = <<-DESC
                   A longer description of liger in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = ""
  s.license      = 'MIT'

  s.author       = { "John Gustafsson" => "john.gustafsson@" }

  s.platform     = :ios, '6.1'
  s.source       = { :git => "", :tag => "#{s.version}" }

  s.source_files  = 'Liger/**/*.{h,m}'
  s.resources = 'Liger/**/*.{xib}'

  s.requires_arc = true

  s.dependency 'Cordova', '3.1.0'
  s.dependency 'UIColor-HTMLColors', '1.0.0'
end
