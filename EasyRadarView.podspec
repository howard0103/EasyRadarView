Pod::Spec.new do |s|
  s.name          = "EasyRadarView"
  s.version       = "1.0.1"
  s.summary       = "仿微信雷达扫描Swift版"
  s.description   = "1 超炫的扫描效果 2 动态添加标注 3 标注点击交互 4 圈数可动态配置"
  s.homepage      = "https://github.com/howard0103/EasyRadarView.git"
  s.license       = "MIT"
  s.author        = { "howard" => "344185723@qq.com" }
  s.platform      = :ios, "8.0"
  s.source        = { :git => "https://github.com/howard0103/EasyRadarView.git", :tag => "#{s.version}" }
  s.source_files  = "Source"
  s.exclude_files = "Classes/Exclude"
end
