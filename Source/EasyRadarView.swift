//
//  EasyRadarView.swift
//  EasyRadarView
//
//  Created by Howard on 2019/2/12.
//  Copyright © 2019 Howard. All rights reserved.
//
    

import UIKit

let RADAR_DEFAULT_CENTERVIEW_RADIUS: CGFloat = 38.0 //默认中心视图半径大小
let RADAR_DEFAULT_CIRCLE_NUM: Int = 4 //默认圈数
let RADAR_DEFAULT_CIRCLE_INCREMENT: CGFloat = 10.0 //默认圈与圈的增长量
let RADAR_DEFAULT_RADIUS: CGFloat = 240.0 //默认指针半径大小

//MARK:- Lifecycle
open class EasyRadarView: UIView {
    //MARK:- public属性
    public static let shared = EasyRadarView()
    public var pointTapBlock: ((_ radarPointView: EasyRadarPointView) -> Void)?//标注点击事件
    
    public var indicatorViewRadius: CGFloat = 0.0 //指针半径
    public var centerViewRadius: CGFloat = 0.0 //中间视图半径
    public var circleNum: Int = 0 //圈与圈的增长量
    public var circleIncrement: CGFloat = 0 //圈的个数
    
    public var bgImage: UIImage? //背景图片
    public var centerViewImage: UIImage? //中间视图图片
    public var pointImages: [UIImage?]? //标注点随机图片数组
    
    //MARK:- Private属性
    private var pointViewArr: [UIView] = []//所有的点视图
    
    lazy var radarIndicatorView: EasyRadarIndicatorView = {
        let radarIndicatorView = EasyRadarIndicatorView()
        return radarIndicatorView
    }()
    
    lazy var pointsView: UIView = {
        let pointsView = UIView()
        return pointsView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        debug_log("视图初始化")
        self.clipsToBounds = false
        initView()
        initData()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        debug_log("视图开始绘制")
        //背景图片
        self.bgImage?.draw(in: rect)
        //中间视图
        let centerView = UIImageView(frame: CGRect(x: self.center.x - self.centerViewRadius, y: self.center.y - self.centerViewRadius, width: 2 * self.centerViewRadius, height: 2 * self.centerViewRadius))
        centerView.backgroundColor = UIColor.lightGray
        if centerViewImage != nil {
            centerView.image = self.centerViewImage
        }
        centerView.layer.cornerRadius = self.centerViewRadius
        centerView.layer.masksToBounds = true
        //圆与圆之间间隔距离
        let space = (self.indicatorViewRadius - self.centerViewRadius - self.getIncrement()) / CGFloat(self.circleNum)
        var sectionRadius = space + self.centerViewRadius
        self.addSubview(centerView)
        for i in 1...self.circleNum {
            let context = UIGraphicsGetCurrentContext()
            //颜色为白色，透明度渐变
            context?.setStrokeColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: (1 - CGFloat(i) / CGFloat(self.circleNum + 1)) * 0.6).cgColor)
            context?.setLineWidth(1.0)
            let path = CGMutablePath()
            path.addArc(center: self.center, radius: sectionRadius, startAngle: 0, endAngle: CGFloat(2.0 * Double.pi), clockwise: false)
            context?.addPath(path)
            context?.strokePath()
            sectionRadius += space + CGFloat(i) * self.circleIncrement
        }
        self.radarIndicatorView.clipsToBounds = false
        self.radarIndicatorView.frame = CGRect(x: 0, y: 0, width: 2 * self.indicatorViewRadius, height: rect.height)
        self.radarIndicatorView.center = self.center
        self.radarIndicatorView.radius = self.indicatorViewRadius
        self.radarIndicatorView.backgroundColor = UIColor.clear
        self.pointsView.frame =  self.radarIndicatorView.bounds
    }
}
//MARK:- 公共方法
extension EasyRadarView {
    //是否启用日志，默认未启用
    public static var enableLog: Bool = false
    //显示雷达扫描
    //view:父视图
    public func showInView(view: UIView) {
        self.frame = view.bounds
        view.addSubview(self)
        self.scan()
    }
    //添加标注点
    public func addPointView(_ userInfo: Any? = nil) {
        let safeRadius: UInt32 = UInt32(self.indicatorViewRadius - centerViewRadius - 25)
        let angle = arc4random() % 360
        let radius = arc4random() % safeRadius + UInt32(centerViewRadius) + 25
        let pointView = EasyRadarPointView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        pointView.tag = pointViewArr.count
        pointView.userInfo = userInfo
        pointView.layer.cornerRadius = pointView.frame.size.width / 2
        pointView.layer.masksToBounds = true
        pointView.isUserInteractionEnabled = true
        pointView.pointTapBlock = {[weak self](radarPointView) in
            guard let self = self else { return }
            if self.pointTapBlock != nil {
                self.pointTapBlock!(radarPointView)
            }
        }
        let pointX = self.center.x + CGFloat(radius) * cos(CGFloat(angle) * CGFloat.pi / 180)
        let pointY = self.center.y + CGFloat(radius) * sin(CGFloat(angle) * CGFloat.pi / 180)
        if ((pointX - pointView.frame.size.width / 2) < 0) || (pointX + pointView.frame.size.width / 2 > UIScreen.main.bounds.size.width) {
            debug_log("超出屏幕")
            self.addPointView(userInfo)
            return
        }
        pointView.center = CGPoint(x: pointX, y: pointY)
        for pView in pointViewArr {
            if (pointView.frame.intersects(pView.frame)) {
                debug_log("两视图相交")
                self.addPointView(userInfo)
                return
            }
        }
        pointViewArr.append(pointView)
        //动画
        pointView.alpha = 0
        pointView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 1.5, animations: {
            pointView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            pointView.alpha = 1.0
        }) { (_) in
        }
        pointsView.addSubview(pointView)
        if let images = self.pointImages {
            let imageIndex = arc4random() % UInt32(images.count)
            pointView.icon?.image = images[Int(imageIndex)]
        }
    }
    //开始扫描
    public func scan() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = 2 * Double.pi
        animation.duration = 3
        animation.autoreverses = false
        animation.repeatCount = Float.greatestFiniteMagnitude
        self.radarIndicatorView.layer.add(animation, forKey: nil)
    }
    //停止扫描
    public func stop() {
        self.radarIndicatorView.layer.removeAllAnimations()
    }
    
}
//MARK:- 私有方法
extension EasyRadarView {
    //初始化视图
    private func initView() {
        self.addSubview(radarIndicatorView)
        self.addSubview(pointsView)
    }
    //初始化数据
    private func initData() {
        indicatorViewRadius = RADAR_DEFAULT_RADIUS
        centerViewRadius = RADAR_DEFAULT_CENTERVIEW_RADIUS
        circleNum = RADAR_DEFAULT_CIRCLE_NUM
        circleIncrement = RADAR_DEFAULT_CIRCLE_INCREMENT
    }
    
    //获取圈与圈的增长总量
    private func getIncrement() -> CGFloat {
        var increment: CGFloat = 0.0
        for i in 1..<self.circleNum {
            increment += CGFloat(i) * self.circleIncrement
        }
        return increment
    }
}
//log
func debug_log(_ msg: String) {
    if EasyRadarView.enableLog {
        print(msg)
    }
}
