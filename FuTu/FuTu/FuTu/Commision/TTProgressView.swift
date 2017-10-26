////
////  TTProgressView.swift
////  FuTu
////
////  Created by Administrator1 on 14/12/16.
////  Copyright © 2016 Taylor Tan. All rights reserved.
////
//
//import UIKit
//
//struct ProgressProperty{
//    var width:CGFloat
//    var trackColor:UIColor
//    var progressColor :UIColor
//    var progressStart:CGFloat
//    var progressEnd:CGFloat
//    
//    init(width:CGFloat,progressEnd:CGFloat,progressColor:UIColor) {
//        self.width = width
//        self.progressEnd = progressEnd
//        self.progressColor = progressColor
//        trackColor = UIColor.gray
//        progressStart = 0
//    }
//    
//    init() {
//        width = 10
//        trackColor = UIColor.clear
//        progressColor = UIColor.green
//        progressStart = 0
//        progressEnd = 0.8
//    }
//}
//
//
//
//class TTProgressView: UIView {
//
//    var progressProperty = ProgressProperty.init()
//    let progressLayer = CAShapeLayer()
//    var progressView: UIImageView!
//    
//    init(propressProperty:ProgressProperty,frame:CGRect) {
//        self.progressProperty = propressProperty
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.clear
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.clear
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func draw(_ rect: CGRect) {
//        let path = UIBezierPath(ovalIn: bounds).cgPath
//        
////        let trackLayer = CAShapeLayer()
////        trackLayer.frame = bounds
////        trackLayer.fillColor = UIColor.clear.cgColor
////        trackLayer.strokeColor = progressProperty.trackColor.cgColor
////        trackLayer.lineWidth = progressProperty.width
////        trackLayer.path = path
////        layer.addSublayer(trackLayer)
//        
//        progressLayer.frame = bounds
//        progressLayer.fillColor = UIColor.clear.cgColor
//        progressLayer.strokeColor = progressProperty.progressColor.cgColor
//        progressLayer.lineWidth = progressProperty.width
//        progressLayer.path = path
//        progressLayer.strokeStart = progressProperty.progressStart
//        progressLayer.strokeEnd = progressProperty.progressEnd
//        
//        
//        
//        //翻转
//        var transform = CATransform3DIdentity
//        transform = CATransform3DRotate(transform, CGFloat(Double.pi / 2), 0, 0, 1)//z轴旋转
//        transform = CATransform3DRotate(transform, CGFloat(Double.pi), 0, 1, 0)//压轴旋转
//        
//        //彩色背景
//        progressView = UIImageView(frame: frame)
//        progressView.image = UIImage(named: "commission_ball_colorBoard.png")
//        progressView.layer.mask = progressLayer
//        progressView.layer.transform = transform
//        
//        
//        //layer.addSublayer(progressLayer)
//        
//    }
//    
//    func setProgress(progress:CGFloat,time:CFTimeInterval,animate:Bool) {
//        
//        print("setProgress")
//        CATransaction.begin()
//        CATransaction.setDisableActions(!animate)
//        CATransaction.setAnimationDuration(time)
//        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
//        progressLayer.strokeEnd = progress
//        CATransaction.commit()
//    }
//
//
//}
