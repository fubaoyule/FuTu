////
////  EggPurchaseView.swift
////  FuTu
////
////  Created by Administrator1 on 22/1/17.
////  Copyright © 2017 Taylor Tan. All rights reserved.
////
//
//import UIKit
//
//class EggPurchaseView: UIView {
//
//    
//    
//    var delegate: eggPurchaseDelegate!
//    var width,height: CGFloat!
//    //let model = EggModel()
//    let baseVC = BaseViewController()
//    init(frame:CGRect, param:AnyObject,rootVC:UIViewController) {
//        super.init(frame: frame)
//        self.width = frame.width
//        self.height = frame.height
//        self.delegate = rootVC as! eggPurchaseDelegate
//        //self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
//        self.backgroundColor = UIColor.clear
//        purchaseHideView()
//        purchaseAlertView()
//        
//    }
//    
//    func purchaseHideView() -> Void {
//        tlPrint(message: "purchaseHideView")
//        let backView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//        backView.backgroundColor = UIColor.black
//        backView.alpha = 0.5
//        self.insertSubview(backView, at: 0)
////        backView.tag = EggTag.purchaseHidenViewTag.rawValue
////        let backTap = UIGestureRecognizer(target: nil, action: #selector(self.tapAct(sender:)))
////        backView.addGestureRecognizer(backTap)
//    }
//    
//    func purchaseAlertView() -> Void {
//        tlPrint(message: "purchaseAlertView")
//        let alertView = UIView(frame: CGRect(x: adapt_W(width: isPhone ? 20 : 80), y: adapt_H(height: isPhone ? 175 : 150), width: width - adapt_W(width: isPhone ? 40 : 160), height: adapt_H(height: isPhone ? 280 : 210)))
//        self.addSubview(alertView)
//        alertView.backgroundColor = UIColor.white
//        alertView.layer.cornerRadius = adapt_W(width: isPhone ? 15 : 10)
//        //title imgae
//        let purchaseImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 50 : 30), y: adapt_H(height: isPhone ? -25 : -20), width: alertView.frame.width - adapt_W(width: isPhone ? 100 : 60), height: adapt_H(height: isPhone ? 50 : 40)))
//        alertView.addSubview(purchaseImg)
//        purchaseImg.image = UIImage(named:"egg_purchase_title.png")
//        
//        //Account view 
//        let amountSelectView = UIView(frame: CGRect(x: 0, y: adapt_H(height: 35), width: alertView.frame.width, height: adapt_H(height: isPhone ? 180 : 130)))
//        alertView.addSubview(amountSelectView)
//        amountSelectView.backgroundColor = UIColor.colorWithCustom(r: 228, g: 228, b: 228)
//        
//        let labelInfo = [["2次","","20元"],["10次","","100元"],["100次","","1000元"],["500次","（送2次）","5000元"],["1000次","（送6次）","10000元"],["2000次","（送20次）","20000元"]]
//        //
//        for i in 0 ..< 6 {
//            
//            let btnW:CGFloat = (amountSelectView.frame.width - adapt_W(width: isPhone ? 22 : 14)) / 3
//            let btnH:CGFloat = (amountSelectView.frame.height - adapt_H(height: isPhone ? 35 : 23)) / 2
//            let btnX = CGFloat(i % 3) * (btnW + adapt_W(width: isPhone ? 5 : 3))  + adapt_W(width: isPhone ? 6 : 4)
//            let btnY = CGFloat(i / 3) * (btnH + adapt_W(width: isPhone ? 5 : 3)) + adapt_W(width: isPhone ? 15 : 10)
//            let btnFrame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
//            let btnView = UIView(frame: btnFrame)
//            amountSelectView.addSubview(btnView)
//            btnView.backgroundColor = UIColor.white
//            btnView.layer.cornerRadius = adapt_W(width: isPhone ? 10 : 5)
//            btnView.layer.borderColor = UIColor.colorWithCustom(r: 255, g: 138, b: 0).cgColor
//            btnView.layer.borderWidth = adapt_W(width: 0.6)
//            btnView.tag = EggTag.purchaseViewTag.rawValue + i
//            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAct(sender:)))
//            btnView.addGestureRecognizer(tap)
//            
//            let line = UIView(frame: CGRect(x: 0, y: adapt_H(height: isPhone ? 45 : 30), width: btnFrame.width, height: adapt_H(height: isPhone ? 0.6 : 0.4)))
//            line.backgroundColor = UIColor.colorWithCustom(r: 255, g: 138, b: 0)
//            btnView.addSubview(line)
//            var timeHeight = adapt_H(height: isPhone ? 45 : 30)
//            if i >= 3 {
//                timeHeight = adapt_H(height: isPhone ? 35 : 25)
//            }
//            //次数标签
//            let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: btnFrame.width, height: timeHeight))
//            btnView.addSubview(timeLabel)
//            setLabelProperty(label: timeLabel, text: labelInfo[i][0], aligenment: .center, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backColor: .clear, font: fontAdapt(font: isPhone ? 17 : 12))
//            timeLabel.font = UIFont.init(name: "Verdana-Bold", size: fontAdapt(font: isPhone ? 17 : 12))
//            timeLabel.tag = EggTag.purchaseTimeLabelTag.rawValue + i
////            if i >= 3 {
//            //赠送标签
//            let giveLabel = UILabel(frame: CGRect(x: 0, y: adapt_H(height: isPhone ? 25 : 15), width: btnFrame.width, height: adapt_H(height: 20)))
//                btnView.addSubview(giveLabel)
//            setLabelProperty(label: giveLabel, text: labelInfo[i][1], aligenment: .center, textColor: .colorWithCustom(r: 129, g: 129, b: 129), backColor: .clear, font: fontAdapt(font: isPhone ? 11 : 7))
//                giveLabel.tag = EggTag.purchaseGivelabelTag.rawValue + i
////            }
//            //金额标签
//            let amountLabel = UILabel(frame: CGRect(x: 0, y: adapt_H(height: isPhone ? 45 : 32), width: btnFrame.width, height: adapt_H(height: isPhone ? 25 : 15)))
//            btnView.addSubview(amountLabel)
//            setLabelProperty(label: amountLabel, text: labelInfo[i][2], aligenment: .center, textColor: .colorWithCustom(r: 255, g: 138, b: 0), backColor: .clear, font: fontAdapt(font: isPhone ? 15 : 10))
//            amountLabel.tag = EggTag.purchaseAmountLabelTag.rawValue + i
//            
//            if i == 4 {
//                btnView.backgroundColor = UIColor.colorWithCustom(r: 255, g: 138, b: 0)
//                timeLabel.textColor = UIColor.white
//                giveLabel.textColor = UIColor.white
//                amountLabel.textColor = UIColor.white
//                currentBtnView = btnView
//            }
//        }
//        
//        
//        let confirmFrame = CGRect(x: adapt_W(width: isPhone ? 60 : 40), y: adapt_H(height: isPhone ? 225 : 170), width: alertView.frame.width - adapt_W(width: isPhone ? 120 : 80), height: adapt_H(height: isPhone ? 40 : 30))
//        let confirBtn = baseVC.buttonCreat(frame: confirmFrame, title: "确认支付", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: fontAdapt(font: isPhone ? 17 : 12), events: .touchUpInside)
//        alertView.addSubview(confirBtn)
//        confirBtn.setTitleColor(UIColor.colorWithCustom(r: 255, g: 138, b: 0), for: .normal)
//        confirBtn.layer.cornerRadius = confirmFrame.height / 2
//        confirBtn.layer.borderColor = UIColor.colorWithCustom(r: 255, g: 138, b: 0).cgColor
//        confirBtn.layer.borderWidth = adapt_W(width: 0.6)
//        confirBtn.tag = EggTag.purchaseConfirmBtnTag.rawValue
//        
//        
//    }
//    
//    var currentBtnView:UIView!
//    func tapAct(sender:UITapGestureRecognizer) -> Void {
//        tlPrint(message: "tapAct tag:\(sender.view!.tag) ")
//        
//        
//        let labelTagArray = [EggTag.purchaseTimeLabelTag.rawValue,EggTag.purchaseGivelabelTag.rawValue,EggTag.purchaseAmountLabelTag.rawValue]
//        let labelColorArray = [UIColor.colorWithCustom(r: 35, g: 35, b: 35),UIColor.colorWithCustom(r: 129, g: 129, b: 129),UIColor.colorWithCustom(r: 255, g: 138, b: 0)]
//        
//        let tag = sender.view!.tag
//        if tag == EggTag.purchaseHidenViewTag.rawValue {
//            
//            self.removeFromSuperview()
//        } else if tag == currentBtnView.tag {
//            return
//        } else if tag >= EggTag.purchaseViewTag.rawValue && tag < EggTag.purchaseTimeLabelTag.rawValue {
//            let btnView = self.viewWithTag(tag)! as UIView
//            btnView.backgroundColor = UIColor.colorWithCustom(r: 255, g: 138, b: 0)
//            if currentBtnView == nil {
//                currentBtnView = sender.view
//                return
//            }
//            currentBtnView.backgroundColor = UIColor.white
//            for i in 0 ..< 3 {
//                
//                let beforLabel = self.viewWithTag(currentBtnView.tag - EggTag.purchaseViewTag.rawValue + labelTagArray[i]) as! UILabel
//                beforLabel.textColor = labelColorArray[i]
//                let currentLabel = sender.view?.viewWithTag(tag - EggTag.purchaseViewTag.rawValue + labelTagArray[i]) as! UILabel
//                currentLabel.textColor = UIColor.white
//            }
//            currentBtnView = btnView
//        }
//    }
//    
//    func btnAct(sender:UIButton) -> Void {
//        tlPrint(message: "btnAct ")
//        self.delegate.eggPuchaseBtnAction(btnTag: sender.tag, selectedTag: currentBtnView.tag - EggTag.purchaseViewTag.rawValue)
//    }
//    
//    
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//        
//        
//        
//    }
//
//}
