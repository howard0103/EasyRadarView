# EasyRadarView
仿微信雷达扫描Swift版

## 示例
![](/Screenshots/radar_example_1.gif) ![](/Screenshots/radar_example_2.gif) ![](/Screenshots/radar_example_3.gif)

## 背景
swift项目中使用超炫的雷达扫描功能

## 功能
-  超炫的扫描效果
-  动态添加标注图标/标注图标不超出屏幕/标注图标不重叠
-  标注点击交互
-  圈数可动态配置
-  可设置圈与圈的增量距离
-  开启和关闭调试日志

## 要求
-  iOS 8.0+
-  Swift 4.0+

## 安装
#### CocoaPods
`Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!
pod 'EasyRadarView'
```

然后运行:
```bash
$ pod install
```

## 使用
#### 导入头文件
```swift
import EasyRadarView
```
#### 具体用法
开启调试日志信息
```swift
EasyRadarView.enableLog = true //默认未启动调试日志
```

设置背景图
```swift
EasyRadarView.shared.bgImage = UIImage(named: "radar_bg")
```

设置中心视图图片
```swift
EasyRadarView.shared.centerViewImage = UIImage(named: "photo")
```
设置圈数
```swift
EasyRadarView.shared.circleNum = 3
```

设置每个圈与圈的增量距离
 ```swift
EasyRadarView.shared.circleIncrement = 10.0
```

设置指针半径
```swift
EasyRadarView.shared.indicatorViewRadius = 230
```

设置随机标注图片
```swift
EasyRadarView.shared.pointImages = [UIImage?]
```

设置标注点击回调
```swift
EasyRadarView.shared.pointTapBlock = { (radarPointView) in
    print("tag:\(radarPointView.tag)")
    if let userInfo = radarPointView.userInfo as? NSDictionary {
        print("username:\(userInfo["key"] ?? "")")
    }
}
```

显示
```swift
EasyRadarView.shared.showInView(view: self.view)
```

添加一个标注
```swift
EasyRadarView.shared.addPointView()
```

添加一个带参数标注
```swift
EasyRadarView.shared.addPointView(["key":"abc"])
```

## 最后
使用过程中如果有任何问题和建议都可以随时联系我，我的邮箱 344185723@qq.com
愿大家都可以开开心心的写代码！



