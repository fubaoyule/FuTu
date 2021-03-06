//
//  FindView.swift
//  FuTu
//
//  Created by Administrator1 on 2/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class FindView: UIView,UIAlertViewDelegate {

    var width,height: CGFloat!
    var textFieldDelegate:UITextFieldDelegate!
    var delegate: BtnActDelegate!
    var alertDelegate: UIAlertViewDelegate!
    //基础空间
    let baseVC = BaseViewController()
    let model = LoginModel()
    let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var findWay:Int = 0
    
    init(frame:CGRect,rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = deviceScreen.width
        self.height = deviceScreen.height
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.delegate = rootVC as! BtnActDelegate
        self.alertDelegate = rootVC as! UIAlertViewDelegate
        
        //self.initScrollView()
        initBackImg()
        initNavigationBar()
        initStepLabel()
        initFindWay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //================================
    //Mark:- 背景图
    //================================
    private func initBackImg() -> Void {
        
        let backImg = UIImageView(frame: self.frame)
        backImg.image = UIImage(named: "login_bg.png")
        
        self.addSubview(backImg)
    }
    
    //================================
    //Mark:- 导航头
    //================================
    func initNavigationBar() -> Void {
        //view
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20 + navBarHeight))
        self.addSubview(navigationView)
        navigationView.backgroundColor = UIColor.clear
        //label
        let titleLabel = UILabel(frame: CGRect(x: 0, y: adapt_H(height: 20), width: width, height: navBarHeight))
        setLabelProperty(label: titleLabel, text: "找回密码", aligenment: .center, textColor: .colorWithCustom(r: 81, g: 81, b: 81), backColor: .clear, font: fontAdapt(font: isPhone ? 20 : 13))
        
        navigationView.addSubview(titleLabel)
        
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: adapt_W(width: 10), y: 20, width: adapt_W(width: isPhone ? 40 : 30), height: navBarHeight), title: "取消", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 16 : 10), events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.setTitleColor(UIColor.colorWithCustom(r: 81, g: 81, b: 81), for: .normal)
        backBtn.tag = ForgetTag.cancelBtnTag.rawValue
        
        
    }

    //================================
    //Mark:- 步骤标签
    //================================
    func initStepLabel() -> Void {
        let stepLabel = UILabel(frame: CGRect(x: 0, y: adapt_H(height: isPhone ? 70 : 50), width: width, height: adapt_H(height: isPhone ? 20 : 15)))
        setLabelProperty(label: stepLabel, text: "第二步选择找回密码方式", aligenment: .center, textColor: .colorWithCustom(r: 169, g: 169, b: 169), backColor: .clear, font: fontAdapt(font: isPhone ? 14 : 9))
        self.addSubview(stepLabel)
    }
    
    //================================
    //Mark:- 选择找回密码的方式
    //================================
    func initFindWay() -> Void {
        
        let findWay = ["手机号码找回密码","电子邮箱找回密码"]
        let findImg = ["forget_find_way1.png","forget_find_way2.png"]
        let findColor = [UIColor.colorWithCustom(r: 0, g: 101, b: 215),UIColor.colorWithCustom(r: 81, g: 81, b: 81)]
        
        
        for i in 0 ..< 2 {
            let wayFrame = CGRect(x: adapt_W(width: 110), y: adapt_H(height: (isPhone ? 150 : 120) + CGFloat(i) * 50), width: width - adapt_W(width: isPhone ? 220 : 280), height: adapt_H(height: isPhone ? 25 : 15))
            
            let wayView = baseVC.buttonCreat(frame: wayFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
            self.addSubview(wayView)
            wayView.center.x = self.center.x
            wayView.tag = FindTag.findByPhone.rawValue + i
            let wayTap = UITapGestureRecognizer(target: self, action: #selector(self.tapGuesAct(sender:)))
            wayView.addGestureRecognizer(wayTap)
            
            let wayLabel = UILabel(frame: CGRect(x: adapt_W(width: isPhone ? 25 : 15), y: 0, width: wayView.frame.width - adapt_W(width: isPhone ? 30 : 20), height: wayView.frame.height))
            wayView.addSubview(wayLabel)
            setLabelProperty(label: wayLabel, text: findWay[i], aligenment: .center, textColor: findColor[i], backColor: .clear, font: fontAdapt(font: isPhone ? 15 : 10))
            wayLabel.tag = FindTag.findByPhonelabel.rawValue + i
            
            let leftImg = UIImageView(frame: CGRect(x: 0, y: 0, width: wayLabel.frame.height, height: wayLabel.frame.height))
            wayView.addSubview(leftImg)
            leftImg.image = UIImage(named: findImg[i])
            leftImg.tag = FindTag.findByPhoneImg.rawValue + i
            
        }
        
        
        //next button
        let nextFrame = CGRect(x: (width - adapt_W(width: isPhone ? 275 : 180)) / 2, y: adapt_H(height: isPhone ? 300 : 250), width: adapt_W(width: isPhone ? 275 : 180), height: adapt_H(height: isPhone ? 45 : 25))
        let nextBtn = baseVC.buttonCreat(frame: nextFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"login_button_back1.png"), hightImage: UIImage(named:"login_button_back2.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.addSubview(nextBtn)
        nextBtn.tag = FindTag.nextBtnTag.rawValue
        let loginLabelFrame = CGRect(x: 0, y: 0, width: nextFrame.width, height: nextFrame.height)
        let loginLabel = baseVC.labelCreat(frame: loginLabelFrame, text:  "下一步", aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 11))
        nextBtn.addSubview(loginLabel)
    }
    
    func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag:\(sender.tag)")
        delegate.btnAct(btnTag: sender.tag)
    }
    
    func tapGuesAct(sender:UITapGestureRecognizer) -> Void {
        tlPrint(message: "tapGuesAct sender.tag = \(sender.view!.tag)")
        let index = sender.view!.tag - FindTag.findByPhone.rawValue
        for i in 0 ..< 2{
            let img = self.viewWithTag(FindTag.findByPhoneImg.rawValue + i) as! UIImageView
            let label = self.viewWithTag(FindTag.findByPhonelabel.rawValue + i) as! UILabel
            if i == index {
                img.image = UIImage(named: "forget_find_way1.png")
                label.textColor = UIColor.colorWithCustom(r: 0, g: 101, b: 215)
            } else {
                img.image = UIImage(named: "forget_find_way2.png")
                label.textColor = UIColor.colorWithCustom(r: 81, g: 81, b: 81)
            }
        }
        self.findWay = index
    }
    //index 为0就是发送密码到手机，为1就是发送密码到邮箱
    func sendPassword(index:Int) -> Void {
        tlPrint(message: "sendPasswordAlert index = \(index)")
        
        
    }
}
