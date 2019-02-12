//
//  EasyRadarPointView.swift
//  productFrame
//
//  Created by Howard on 2019/2/12.
//  Copyright © 2019 Howard. All rights reserved.
//
    

import UIKit

open class EasyRadarPointView: UIView {
    public var userInfo: Any? //用户数据
    
    var pointTapBlock: ((_ radarPointView: EasyRadarPointView) -> Void)?
    var angle: Int = 0 //角度
    var radius: Int = 0 //距离中心点的距离
    var icon: UIImageView?//小头像
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        icon = UIImageView(frame: self.bounds)
        self.addSubview(icon!)
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapAction() {
        if self.pointTapBlock != nil {
            self.pointTapBlock!(self)
        }
    }
}
