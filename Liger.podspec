Pod::Spec.new do |s|
  s.name         = "Liger"
  s.version      = "0.0.8"
  s.summary      = "A framework to help building HTML5 apps using native navigation."

  s.description  = <<-DESC
  		   # Welcome to Liger!

		   Liger is thin layer added to iOS or Android to enabled developing using both native code and in web views. In it's most basic form it's a series of pages displayed in an app. Each individual page can be implemented either using native code or inside of a web view using javascript, html, and css. Any page can open up any other page, making it possible to mix and match.

		   Some will use Liger to write a prototype app in HTML and implement a native version later. Some will write a fully quality app in web views alone. Yet other's will mix and match. Some might even be inclined to write a fully native app in Liger from the start! No matter which way you being and end your app journey in Liger we hope you enjoy it and that we've added value.
                   DESC

  s.homepage     = "https://github.com/reachlocal/liger"
  s.license      = 'MIT'

  s.author       = { "John Gustafsson" => "john.gustafsson.liger@gmail.com" }

  s.platform     = :ios, '6.1'
  s.source       = { :git => "https://github.com/reachlocal/liger-ios.git", :tag => "#{s.version}" }

  s.source_files  = 'Liger/**/*.{h,m}'
  s.resources = 'Liger/**/*.{xib}'

  s.requires_arc = true

  s.dependency 'Cordova', '3.1.0'
  s.dependency 'UIColor-HTMLColors', '1.0.0'
end
