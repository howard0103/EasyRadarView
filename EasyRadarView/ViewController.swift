//
//  ViewController.swift
//  EasyRadarView
//
//  Created by Howard on 2019/2/12.
//  Copyright © 2019 Howard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置是否开启调试日志
        EasyRadarView.enableLog = true
        //设置背景图
        EasyRadarView.shared.bgImage = UIImage(named: "radar_bg")
        //设置中心视图图片
        EasyRadarView.shared.centerViewImage = UIImage(named: "photo")
        //设置圈数
        EasyRadarView.shared.circleNum = 3
        //设置指针半径
        EasyRadarView.shared.indicatorViewRadius = 230
        //设置每个圈与圈的增量距离
        EasyRadarView.shared.circleIncrement = 10.0
        //设置随机标注图片
        var images: [UIImage?] = []
        for i in 0...5 {
            images.append(UIImage(named: String(format: "photo%d", i)))
        }
        EasyRadarView.shared.pointImages = images
        //设置标注点击回调
        EasyRadarView.shared.pointTapBlock = { (radarPointView) in
            print("tag:\(radarPointView.tag)")
            if let userInfo = radarPointView.userInfo as? NSDictionary {
                print("username:\(userInfo["key"] ?? "")")
            }
        }
        //显示
        EasyRadarView.shared.showInView(view: self.view)
//        //添加一个标注
//        EasyRadarView.shared.addPointView()
//        EasyRadarView.shared.addPointView()
//        EasyRadarView.shared.addPointView()
//        EasyRadarView.shared.addPointView()
//        //添加一个带参数标注
//        EasyRadarView.shared.addPointView(["key":"abc"])
        
        for i in 1...20 {
            let delayTime = Double(i * 1)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime) {
                EasyRadarView.shared.addPointView()
            }
            
        }
        
        
    }


}

