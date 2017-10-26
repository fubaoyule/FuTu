////
////  CommissionViewController.swift
////  FuTu
////
////  Created by Administrator1 on 12/12/16.
////  Copyright © 2016 Taylor Tan. All rights reserved.
////
//
//import UIKit
//
//class CommissionViewController: UIViewController, UIScrollViewDelegate {
//
//    var height, width: CGFloat!
//    var titleImg: UIImageView!
//    let model = CommissionModel()
//    var commissionView:CommissionView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        height = self.view.frame.height
//        width = self.view.frame.width
//        
//        commissionView = CommissionView(frame: self.view.frame, param: "我来自佣金控制器" as AnyObject)
//        commissionView.scroll.delegate = self
//        //self.view.addSubview(commissionView.scroll)
//        self.view.addSubview(commissionView.self)
//        
//        titleImg = commissionView.titleBackImg
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }    
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        tlPrint(message: "scrollViewDidScroll")
//        let offSetY:CGFloat = scrollView.contentOffset.y
//        if offSetY < 0 {
//            let originH = adapt_H(height: model.titleViewHeight)
//            let newHeight = -offSetY + originH
//            titleImg.frame = CGRect(x: 0, y: offSetY, width: width, height: newHeight)
//            
//            changeViewWhilePull(offSetY: offSetY)
//
//        } else if offSetY >= 0{
//            commissionView.progressLayer.isHidden = false
//            commissionView.progressView.isHidden = false
//            if offSetY == 0 {
//                self.animations()
//            }
//        }
//    }
//    
//    
//    //下拉视图变动函数
//    func changeViewWhilePull(offSetY:CGFloat) -> Void {
//        
//        
//        //固定住头部的label和按钮
//        commissionView.titleText.frame = CGRect(x: 0, y: adapt_H(height: 37 + offSetY * 0.666), width: width, height: adapt_H(height: 20))
//        commissionView.serviceBtn.frame = CGRect(x:width - adapt_W(width: 50), y:adapt_H(height: 25 + offSetY * 0.666), width:adapt_W(width: 35), height:adapt_H(height: 35))
//        commissionView.detailBtn.frame = CGRect(x:width - adapt_W(width: 72 + 13), y:adapt_H(height: 250 + offSetY * 0.333), width:adapt_W(width: 72), height:adapt_H(height: 26))
//        
//        //球形视图
//        commissionView.ballView.frame = CGRect(x: model.ballFrame.origin.x + offSetY * 0.1, y: model.ballFrame.origin.y + offSetY * 0.333 + offSetY * 0.1, width: model.ballFrame.width - offSetY * 0.2, height: model.ballFrame.height - offSetY * 0.2)
//        
//        //球形图片
//        commissionView.ballImg.frame = CGRect(x: 0, y: 0, width: model.ballFrame.width - offSetY * 0.2, height: model.ballFrame.height - offSetY * 0.2)
//        //金额标签
//        commissionView.commissionLabel.frame = CGRect(x: 0, y: commissionView.ballImg.frame.width * 0.3, width: commissionView.ballImg.frame.width, height: commissionView.ballImg.frame.height * 0.15)
//        commissionView.commissionLabel.font = UIFont.systemFont(ofSize: fontAdapt(font: model.commissionValueFont) - offSetY * 0.05)
//        
//        //百分比标签
//        commissionView.percentLabel.frame = CGRect(x: 0, y: commissionView.ballImg.frame.width * 0.5, width: commissionView.ballImg.frame.width, height: adapt_H(height: 60))
//        commissionView.percentLabel.font = UIFont.systemFont(ofSize: fontAdapt(font: model.percentFont) - offSetY * 0.01)
//        let textString = "您已超越\n全国\(model.dataSource[1])％的小伙伴"
//        commissionView.setLabelWithDiff(label: commissionView.percentLabel, text: textString, font: fontAdapt(font: model.percentFont + 2 - offSetY * 0.03), color: .colorWithCustom(r: 197, g: 255, b: 145), range: NSRange(location: 7, length: "\(model.dataSource[1])".characters.count + 1))
//        //隐藏进度条
//        commissionView.lightImg.isHidden = true
//        commissionView.progressLayer.isHidden = true
//        commissionView.progressView.isHidden = true
//    }
//    
//    
//    //佣金页面所有动画启动函数
//    func animations() -> Void {
//        DispatchQueue.main.async {
//        
//            //进度条动画
//            self.setProgress(progress: 0, time: 0, animate: false)
//            self.setProgress(progress: 0.8, time: 2, animate: true)
//            let userInfo0 = [self.commissionView.commissionLabel,CGFloat(self.model.dataSource[0])] as [Any]
//            self.valueAnimate(timeInterval: 0.1, userInfo: userInfo0)
//        }
//    }
//
//    //数据跳动的定时器入口
//    var comsTimer,percentTimer: Timer!
//    func valueAnimate(timeInterval:CGFloat,userInfo:[Any]) -> Void {
//        self.commissionView.commissionLabel.text = "0.00"
//        if comsTimer != nil {
//            comsTimer.invalidate()
//            comsTimer = nil
//        }
//        comsTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(self.changeValue(sender:)), userInfo: userInfo, repeats: true)
//        
//        
//        let percentInfo = [self.commissionView.percentLabel,CGFloat(self.model.dataSource[1])] as [Any]
//        if percentTimer != nil {
//            percentTimer.invalidate()
//            currentPercent = 0
//            percentTimer = nil
//        }
//        percentTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(self.percentChangeValue(sender:)), userInfo: percentInfo, repeats: true)
//        
//        
//    }
//    
//    //修改label数据
//    func changeValue(sender:Timer) -> Void {
//        
//        print("changeValue function: \(String(describing: sender.userInfo))")
//        let label = (sender.userInfo as! [Any])[0] as! UILabel
//        let stringValue = label.text
//        var currentValue = CGFloat(NumberFormatter().number(from: stringValue!)!)
//        
//        let endValue = (sender.userInfo as! [Any])[1] as! CGFloat
//        let addValueStr = String(format: "%.2f", (endValue / 20))
//        let addValue = CGFloat(NumberFormatter().number(from: addValueStr)!)
//        
//        if currentValue < endValue {
//            currentValue += addValue
//            DispatchQueue.main.async {
//                label.text = String(format: "%.2f", currentValue)
//            }
//        } else {
//            comsTimer.invalidate()
//            //comsTimer = nil
//            label.text = "\(endValue)"
//        }
//    }
//    
//    var currentPercent:CGFloat = 0
//    func percentChangeValue(sender:Timer) -> Void {
//        
//        print("changeValue function: \(sender)")
//        let label = (sender.userInfo as! [Any])[0] as! UILabel
//        
//        let endValue = (sender.userInfo as! [Any])[1] as! CGFloat
//        let addValueStr = String(format: "%.1f", (endValue / 20))
//        let addValue = CGFloat(NumberFormatter().number(from: addValueStr)!)
//        var text = ""
//        let percentValue = String(format: "%.1f", self.currentPercent)
//        if currentPercent < endValue {
//            currentPercent += addValue
//            text = "您已超越\n全国\(percentValue)％的小伙伴"
//            
//        } else {
//            percentTimer.invalidate()
//            //percentTimer = nil
//            text = "您已超越\n全国\(endValue)％的小伙伴"
//            currentPercent = 0
//        }
//        label.text = text
//        //保持label样式
//        let textString = text
//        commissionView.setLabelWithDiff(label: commissionView.percentLabel, text: textString, font: fontAdapt(font: model.percentFont + 2), color: .colorWithCustom(r: 197, g: 255, b: 145), range: NSRange(location: 7, length: "\(percentValue)".characters.count + 1))
//        
//    }
//    
//    func setProgress(progress:CGFloat,time:CFTimeInterval,animate:Bool) {
//        
//        //进度条动画
//        let progressLayer = commissionView.progressLayer
////        tlPrint(message: "**********************  setProgress ")
////        CATransaction.begin()
////        CATransaction.setDisableActions(false)
////        CATransaction.setAnimationDuration(0.1)
////        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear))
////        progressLayer?.strokeEnd = 0
////        CATransaction.commit()
//        
//        
//        CATransaction.begin()
//        CATransaction.setDisableActions(!animate)
//        CATransaction.setAnimationDuration(time)
//        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear))
//        progressLayer?.strokeEnd = progress
//        CATransaction.commit()
//        
//        
//        //亮点动画
//        let lightImg = self.commissionView.lightImg
//        lightImg?.isHidden = false
//        // 1.创建动画
//        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation")
//        // 2.设置动画的属性
//        rotationAnim.fromValue = 0
//        rotationAnim.toValue = -Double.pi * Double( progress) * 2
//        rotationAnim.duration = time
//        // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
//        rotationAnim.isRemovedOnCompletion = false
//        rotationAnim.fillMode = kCAFillModeForwards
//        
//        // 3.将动画添加到layer中
//        lightImg?.layer.add(rotationAnim, forKey: nil)
//         
//    }
//}
