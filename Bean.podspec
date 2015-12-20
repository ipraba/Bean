Pod::Spec.new do |s|
s.name             = "Bean"
s.version          = "1.0.0"
s.summary          = "Image downloading and caching made easy"
s.description      = <<-DESC
Features
1. Download files easily
2. Imageview Extension to set the images from url
3. Cancelation of image loads
4. Caching of resources using NSCache

DESC

s.homepage         = "https://github.com/ipraba/Bean"
s.license          = 'MIT'
s.author           = { "Prabaharan" => "mailprabaharan.e@gmail.com" }
s.source           = { :git => "https://github.com/ipraba/Bean.git", :tag => '1.0.0' }
s.platform     = :ios, '8.0'
s.requires_arc = true
s.source_files = 'Pod/Classes'
s.frameworks = 'UIKit', 'Foundation'
end