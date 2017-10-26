////
////  BailoutsView.swift
////  FuTu
////
////  Created by Administrator1 on 25/2/17.
////  Copyright © 2017 Taylor Tan. All rights reserved.
////
//
//import UIKit
//
//class BailoutsView: UIView {
//
//    
//    var scroll:UIScrollView!
//    var height,width:CGFloat!
//    var delegate:BtnActDelegate!
//    var shadowView,alertView: UIView!
//    var alertBackImg:UIImageView!
//    
//    let baseVC = BaseViewController()
//    init(frame:CGRect,rootVC:UIViewController) {
//        super.init(frame: frame)
//        self.width = frame.width
//        self.height = frame.height
//
//        self.delegate = rootVC as! BtnActDelegate
//        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
//        initScrollView()
//    }
//    
//    func initScrollView() -> Void {
//        
//        scroll = UIScrollView(frame: frame)
//        self.addSubview(scroll)
//        scroll.contentSize = CGSize(width: frame.width, height: height + adapt_H(height: 0.5))
//        scroll.showsVerticalScrollIndicator = false
//        scroll.showsHorizontalScrollIndicator = false
//        self.addSubview(scroll)
//        
//        //back button
//        let backFrame = CGRect(x: adapt_W(width: isPhone ? 12 : 10), y: adapt_H(height: isPhone ? 25 : 20), width: adapt_W(width: isPhone ? 35 : 25), height: adapt_W(width: isPhone ? 35 : 25))
//        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named: "lobby_PT_back.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
//        self.scroll.insertSubview(backBtn, at: 1)
//        backBtn.tag = bailoutsTag.backBtnTag.rawValue
//        
//        
//        //background 1
//        let backImg1 = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: adapt_H(height: isPhone ? 383 : 300)))
//        backImg1.image = UIImage(named: "Bailouts_back1.png")
//        self.scroll.insertSubview(backImg1, at: 0)
//        //background 2
//        let backImg2 = UIImageView(frame: CGRect(x: 0, y: backImg1.frame.height - adapt_H(height: isPhone ? 25 : 15), width: width, height: height - backImg1.frame.height + adapt_H(height: isPhone ? 28 : 18)))
//        backImg2.image = UIImage(named: "Bailouts_back2.png")
//        self.scroll.insertSubview(backImg2, aboveSubview: backImg1)
//        //title label imgae
//        let titleImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 0 : 60), y: 0, width: width - adapt_W(width: isPhone ? 0 : 120), height: adapt_H(height: isPhone ? 242 : 180)))
//        titleImg.image = UIImage(named: "Bailouts_name_label.png")
//        self.scroll.insertSubview(titleImg, aboveSubview: backImg1)
//        
////        //time label
////        let timeLabelFrame = CGRect(x: adapt_W(width: 145), y: adapt_H(height: 166), width: adapt_W(width: 120), height: adapt_H(height: 40))
////        let timeLabel = baseVC.labelCreat(frame: timeLabelFrame, text: "2小时35分", aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: 17))
////        titleImg.addSubview(timeLabel)
////        timeLabel.font = UIFont(name: "HelveticaNeue-Bold", size: fontAdapt(font: 18))
//        
//        
//        
//        //case base imgae
//        let caseBaseImg = UIImageView(frame: CGRect(x: adapt_W(width: 40), y: adapt_H(height: isPhone ? 390 : 300), width: adapt_W(width: isPhone ? 290 : 160), height: adapt_H(height: isPhone ? 140 : 80)))
//        caseBaseImg.center.x = self.center.x
//        caseBaseImg.image = UIImage(named: "Bailouts_base_star.png")
//        self.scroll.insertSubview(caseBaseImg, aboveSubview: backImg2)
//        self.alphaAnimatioin(view: caseBaseImg)
//        
//        
//        //case imgae
//        let caseImg = UIImageView(frame: CGRect(x: adapt_W(width: 80), y: adapt_H(height: isPhone ? 250 : 180), width: adapt_W(width: isPhone ? 237 : 160), height: adapt_H(height: isPhone ? 237 : 160)))
//        caseImg.center.x = self.center.x
//        caseImg.image = UIImage(named: "Bailouts_case.png")
//        caseImg.tag = bailoutsTag.caseTapTag.rawValue
//        self.scroll.insertSubview(caseImg, aboveSubview: caseBaseImg)
//        caseImg.isUserInteractionEnabled = true
//        let bailoutsTap = UITapGestureRecognizer(target: self, action: #selector(self.tapAct(sender:)))
//        caseImg.addGestureRecognizer(bailoutsTap)
//        self.floatAnimation(view: caseImg)
//        
//        //get button
//        let getBtnFrame = CGRect(x: adapt_W(width: 88), y: adapt_H(height: isPhone ? 550 : 420), width: adapt_W(width: isPhone ? 218 : 150), height: adapt_H(height: isPhone ? 66 : 44))
//        let getBtn = baseVC.buttonCreat(frame: getBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"Bailouts_button_get_normal.png"), hightImage: UIImage(named:"Bailouts_button_get_click.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
//        getBtn.center.x = self.center.x
//        getBtn.tag = bailoutsTag.getBtnTag.rawValue
//        self.scroll.insertSubview(getBtn, aboveSubview: backImg2)
//        
//    }
//    
//    //初始化救援金弹窗视图
//    //alertType:0 可以领取  1 不可以领取  2 领取成功
//    func initAlertView(alertType:Int,amount:CGFloat?,alertMsg:String) -> Void {
//        tlPrint(message: "initAlertView")
//        if self.alertView != nil {
//            for view in alertView.subviews {
//                view.removeFromSuperview()
//            }
//            alertView.removeFromSuperview()
//            alertView = nil
//        }
//        if self.shadowView != nil {
//            shadowView.removeFromSuperview()
//            shadowView = nil
//        }
//        self.alertView = UIView(frame: self.frame)
//        self.insertSubview(self.alertView, aboveSubview: self.scroll)
//        
//        //mask view
//        self.shadowView = UIView(frame: self.frame)
//        self.shadowView.backgroundColor = UIColor.colorWithCustom(r: 7, g: 18, b: 35)
//        self.shadowView.alpha = 0.7
//        self.alertView.insertSubview(shadowView, at: 0)
//        self.shadowView.tag = bailoutsTag.shadowViewTapTag.rawValue
//        let shadowTap = UITapGestureRecognizer(target: self, action: #selector(self.tapAct(sender:)))
//        self.shadowView.addGestureRecognizer(shadowTap)
//        
//        
//        //alert back imgae
//        alertBackImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 80), y: adapt_H(height: isPhone ? 250 : 180), width: width - adapt_W(width: isPhone ? 20 : 160), height: adapt_H(height: isPhone ? 370 : 200)))
////        alertBackImg = UIImageView(frame: CGRect(x: (alertBackImg.frame.width - adapt_W(width: isPhone ? 100 : 80)) / 2, y: adapt_H(height: isPhone ? 250 : 220), width: adapt_W(width: isPhone ? 100 : 80), height: adapt_H(height: isPhone ? 370 : 250)))
//        alertBackImg.center.x = self.center.x
//        alertBackImg.image = UIImage(named: "Bailouts_back_alert.png")
//        self.alertView.insertSubview(alertBackImg, aboveSubview: shadowView)
//        alertBackImg.isUserInteractionEnabled = true
//        
//        
//        //case imgae
////        let caseImg = UIImageView(frame: CGRect(x: 0, y: adapt_W(width: isPhone ? -94 : -60), width: adapt_W(width: isPhone ? 188 : 120), height: adapt_H(height: isPhone ? 188 : 120)))
//        let caseWidth = adapt_W(width: isPhone ? 188 : 120)
//        let caseImg = UIImageView(frame: CGRect(x: (alertBackImg.frame.width - caseWidth) / 2, y: adapt_W(width: isPhone ? -94 : -60), width: caseWidth, height: caseWidth))
////        caseImg.backgroundColor = UIColor.blue
////        caseImg.center.x = self.center.x
//        caseImg.image = UIImage(named: "Bailouts_case.png")
//        alertBackImg.addSubview(caseImg)
//        
//
//        
//        //label info array
//        
//        let labelInfoArray = [["恭喜你获得救援金：",
//                               CGRect(x: 0, y: adapt_H(height: isPhone ? 170 : 90), width: alertBackImg.frame.width, height: adapt_H(height: 20)),
//                               UIColor.colorWithCustom(r: 245, g: 63, b: 0),
//                               fontAdapt(font: isPhone ? 16 : 11),
//                               "\(amount!)元",
//            CGRect(x: 0, y: adapt_H(height: isPhone ? 200 : 110), width: alertBackImg.frame.width, height: adapt_H(height: isPhone ? 50 : 30)),
//                                UIColor.colorWithCustom(r: 245, g: 63, b: 0),
//                                fontAdapt(font: isPhone ? 35 : 25),
//                                "Bailouts_button_get_alert.png"],
//                              
//                              
//                              ["\(alertMsg)",
//                                CGRect(x: adapt_W(width: 30), y: adapt_H(height: isPhone ? 140 : 40), width: alertBackImg.frame.width - adapt_W(width: 60), height: adapt_H(height: 160)),
//                                UIColor.colorWithCustom(r: 0, g: 101, b: 215),
//                                fontAdapt(font: isPhone ? 16 : 11),
//                                "",
//                                CGRect(x: 0, y: 0, width: 0, height: 0),
//                                UIColor.clear,
//                                fontAdapt(font: 16),
//                                "Bailouts_button_confirm.png"],
//                              
//                              ["领取成功!",
//                               CGRect(x: 0, y: adapt_H(height: isPhone ? 180 : 90), width: alertBackImg.frame.width, height: adapt_H(height: 40)),
//                               UIColor.colorWithCustom(r: 245, g: 63, b: 0),
//                               fontAdapt(font: isPhone ? 35 : 18),
//                               "（已转入中心钱包）",
//                               CGRect(x: 0, y: adapt_H(height: isPhone ? 240 : 125), width: alertBackImg.frame.width, height: adapt_H(height: 20)),
//                               UIColor.colorWithCustom(r: 245, g: 63, b: 0),
//                               fontAdapt(font: isPhone ? 16 : 8),
//                               "Bailouts_button_confirm.png"]]
//        
//        
//        let alertGetBtnFrame = CGRect(x: (alertBackImg.frame.width - adapt_W(width: isPhone ? 175 : 120)) / 2, y: adapt_H(height: isPhone ? 290 : 150), width: adapt_W(width: isPhone ? 175 : 120), height: adapt_H(height: isPhone ? 54 : 35))
//        let alertGetBtn = baseVC.buttonCreat(frame: alertGetBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named: (labelInfoArray[alertType][8] as! String)), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
//        //alertGetBtn.center.x = alertBackImg.center.x
//        alertGetBtn.tag = bailoutsTag.alergGetBtnTag.rawValue
//        alertBackImg.addSubview(alertGetBtn)
//        
//        
//        
//        let alertLabel1 = baseVC.labelCreat(frame: labelInfoArray[alertType][1] as! CGRect, text: labelInfoArray[alertType][0] as! String, aligment: .center, textColor: labelInfoArray[alertType][2] as! UIColor, backgroundcolor: .clear, fonsize: labelInfoArray[alertType][3] as! CGFloat)
//        alertLabel1.numberOfLines = 0
//        alertLabel1.lineBreakMode = NSLineBreakMode.byWordWrapping//按照单词分割换行，保证换行时的单词完整。
//        self.alertBackImg.addSubview(alertLabel1)
//        
//        let alertLabel2 = baseVC.labelCreat(frame: labelInfoArray[alertType][5] as! CGRect, text: labelInfoArray[alertType][4] as! String, aligment: .center, textColor: labelInfoArray[alertType][6] as! UIColor, backgroundcolor: .clear, fonsize: labelInfoArray[alertType][7] as! CGFloat)
//        self.alertBackImg.addSubview(alertLabel2)
//
//        
//        
//        alertGetBtn.setImage(UIImage(named:labelInfoArray[alertType][8] as! String), for: UIControlState.highlighted)
//        
//        self.scaleAnimation(view: alertBackImg, delay: 0, scale1: 1, scale2: 0.8, duration: 0.8, outDuration: 0.3)
//        
//    }
//    
//    //宝箱上下浮动动画
//    func floatAnimation(view:UIView) -> Void {
//        
//        let float = CABasicAnimation(keyPath: "transform.translation.y")
//        float.duration = CFTimeInterval(CGFloat(3))
//        float.autoreverses = true//是否重复
//        float.repeatCount = HUGE
//        float.isRemovedOnCompletion = false
//        float.fillMode = kCAFillModeForwards
//        float.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        float.fromValue = NSNumber(value: Float(adapt_H(height: 10)))
//        float.toValue = NSNumber(value: Float(adapt_H(height: -10)))
//        view.layer.animation(forKey: "caseFloat")
//        view.layer.add(float, forKey: nil)
//        
//    }
//    //封印透明度变化动画
//    func alphaAnimatioin(view:UIView) -> Void {
//        let alpha = CABasicAnimation(keyPath: "opacity")
//        alpha.duration = CFTimeInterval(CGFloat(3))
//        alpha.autoreverses = true//是否重复
//        alpha.repeatCount = HUGE
//        alpha.isRemovedOnCompletion = false
//        alpha.fillMode = kCAFillModeForwards
//        alpha.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        alpha.fromValue = NSNumber(value: 1.0)
//        alpha.toValue = NSNumber(value: 0.35)
//        view.layer.add(alpha, forKey: nil)
//    }
//    
//    
//    func btnAct(sender:UIButton) -> Void {
//        tlPrint(message: "btnAct:sender.tag = \(sender.tag)")
//        
//        
//        self.delegate.btnAct(btnTag: sender.tag)
//    }
//    func tapAct(sender:UITapGestureRecognizer) -> Void {
//        tlPrint(message: "tapAct: sender = \(String(describing: sender.view?.tag))")
//        if sender.view?.tag == bailoutsTag.shadowViewTapTag.rawValue {
//            self.removeAlertView()
//            return
//        }
//        self.delegate.btnAct(btnTag: sender.view!.tag)
//    }
//    
//    
//    
//    func removeAlertView() -> Void {
//        
//        for view in self.alertView.subviews {
//            view.removeFromSuperview()
//        }
//        self.alertView.removeFromSuperview()
//        self.alertView = nil
////        if self.shadowView != nil {
////            self.shadowView.removeFromSuperview()
////            self.shadowView = nil
////        }
//    }
//    
//    
//    
//    //缩放动画
//    func scaleAnimation(view:UIView,delay:CGFloat,scale1:CGFloat,scale2:CGFloat,duration:CGFloat,outDuration:CGFloat) -> Void {
//        tlPrint(message: "scaleAnimation")
//        
//        UIView.animate(withDuration: 0.0001, animations: {
//            view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//            view.isHidden = true
//        }, completion: { (finished) in
//            let durations = duration * 0.8
//            UIView.animate(withDuration: TimeInterval(durations), delay: TimeInterval(delay), options: .allowUserInteraction, animations: {
//                view.isHidden = false
//                view.transform = CGAffineTransform(scaleX: scale1, y: scale1)
//            }, completion: { (finisehd) in
//                let durations = duration * 0.1
//                UIView.animate(withDuration: TimeInterval(durations), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
//                    view.transform = CGAffineTransform(scaleX: scale2, y: scale2)
//                }, completion: { (finisehd) in
//                    let durations = duration * outDuration
//                    UIView.animate(withDuration: TimeInterval(durations), delay: TimeInterval(0), options: .allowUserInteraction, animations: {
//                        view.transform = CGAffineTransform(scaleX: 1, y: 1)
//                    }, completion: { (finisehd) in
//                        tlPrint(message: "动画完成")
//                    })
//                })
//            })
//        })
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//}
