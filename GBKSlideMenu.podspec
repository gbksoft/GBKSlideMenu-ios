Pod::Spec.new do |spec|

  spec.name                  = "GBKSlideMenu"
  spec.version               = "0.4"
  spec.summary               = "Easy and simple way for adding and managing a slide-menu in your app"
  spec.license               = 'MIT'
  spec.homepage              = 'https://gbksoft.com/'
  spec.authors               = { 'GBKSoft' => 'dev@gbksoft.com' }
  spec.source                = {:git => 'https://github.com/gbksoft/GBKSlideMenu-ios.git', :tag => spec.version }
  spec.ios.deployment_target = '9.0'
  spec.source_files          = 'GBKSlideMenu/GBKSlideMenu/**/*.swift'
  spec.swift_version         = '5.0'

end
