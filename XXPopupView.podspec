Pod::Spec.new do |s|
  s.name         = "XXPopupView"
  s.version      = "0.0.1"
  s.summary      = "Pop-up based view(e.g. AlertView SheetView), or you can easily customize for your own usage."
  s.homepage     = "https://github.com/HistoryZhang/XXPopupView"
  s.license      = { :type => 'MIT License', :file => 'LICENSE' }
  s.author       = { "HistoryZhang" => "history_zq@163.com" }
  s.source       = { :git => "https://github.com/HistoryZhang/XXPopupView.git", :tag => "0.0.1" }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Classes/*.swift'
  s.requires_arc = true
  s.frameworks = 'Foundation'
  s.dependency 'SnapKit', '~> 4.0.0'
end
