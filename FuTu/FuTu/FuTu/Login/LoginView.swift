//
//  LoginView.swift
//  FuTu
//
//  Created by Administrator1 on 31/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class LoginView: UIView {

    //var scroll: UIScrollView!
    //头像图像视图
    var headImgView: UIImageView!
    var width,height: CGFloat!
    var scrollDelgate:UIScrollViewDelegate!
    var textFieldDelegate:UITextFieldDelegate!
    var delegate: BtnActDelegate!
    //基础控件
    let baseVC = BaseViewController()
    let model = LoginModel()
    let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    init(frame:CGRect,rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = deviceScreen.width
        self.height = deviceScreen.height
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.textFieldDelegate = rootVC as! UITextFieldDelegate
        self.delegate = rootVC as! BtnActDelegate
        
        //self.initScrollView()
        initBackImg()
        initHeadImgView()
        initInputTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func initScrollView() -> Void {
//        
//        let scrollFrame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
//        scroll = UIScrollView(frame: scrollFrame)
//        self.addSubview(scroll)
//        scroll.delegate = scrollDelgate
//        //scroll.backgroundColor = UIColor.green
//        scroll.contentSize = CGSize(width: self.width, height: self.height + 1)
//        scroll.showsVerticalScrollIndicator = false
//        scroll.showsHorizontalScrollIndicator = false
//        
//        
//        initBackImg()
//        initHeadImgView()
//        initInputTextField()
//    }
//    
    
    //================================
    //Mark:- 背景图
    //================================
    private func initBackImg() -> Void {
        
        let backImg = UIImageView(frame: self.frame)
        backImg.image = UIImage(named: "login_bg.png")
        
        self.addSubview(backImg)
    }
    
    
    //================================
    //Mark:- 头像视图
    //================================
    private func initHeadImgView() -> Void {
        
        headImgView = UIImageView()
        headImgView.image = UIImage(named: "login_logo.png")
        
        self.addSubview(headImgView)
        let imgWidth = adapt_W(width: isPhone ? 85 : 65)
        headImgView.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(adapt_H(height: isPhone ? 80 : 60))
            _ = make?.left.equalTo()((self.width - imgWidth) / 2)
            _ = make?.width.equalTo()(imgWidth)
            _ = make?.height.equalTo()(imgWidth)
        }
        headImgView.center.x = self.center.x
        headImgView.layer.cornerRadius = adapt_W(width: isPhone ? 10 : 6)
        headImgView.clipsToBounds = true
    }
    
    
    //================================
    //Mark:- 用户名输入框
    //================================
    private func initInputTextField() -> Void {
        let labelImg = ["login_text_userName.png","login_text_password.png","login_button_forget.png","login_button_register.png"]
        let placeholderText = ["输入您的账户","输入您的密码"]
        for i in 0 ..< 2 {
            
            let textImg = UIImageView()
            self.addSubview(textImg)
            textImg.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(adapt_H(height: (isPhone ? 225 : 175) + adapt_H(height: (isPhone ? 65 : 15) * CGFloat(i))))
                _ = make?.left.equalTo()(self.mas_left)?.setOffset(adapt_W(width: isPhone ? 30 : 100))
                _ = make?.width.equalTo()(self.width - adapt_W(width: isPhone ? 60 : 200))
                _ = make?.height.equalTo()(adapt_H(height: isPhone ? 25 : 15))
            }
            textImg.image = UIImage(named: "login_text_line.png")
            
            let textField = baseVC.textFieldCreat(frame: initFrame, placeholderText: placeholderText[i], aligment: .left, fonsize: fontAdapt(font: isPhone ? 17 : 12), borderWidth: 0, borderColor: .clear, tag: 10)
            textField.textColor = UIColor.colorWithCustom(r: 37, g: 37, b: 37)
            self.addSubview(textField)
            textField.delegate = self.textFieldDelegate
            textField.tag = LoginTag.userText.rawValue + i
            textField.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(textImg.mas_top)?.setOffset(adapt_H(height: -5))
                _ = make?.left.equalTo()(textImg.mas_left)
                _ = make?.right.equalTo()(textImg.mas_right)
                _ = make?.height.equalTo()(textImg.mas_height)
            }
            if i == 1 {
                textField.isSecureTextEntry = true
            }
            //添加左侧视图
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: adapt_W(width: isPhone ? 90 : 60), height: adapt_H(height: isPhone ? 20 : 12)))
            textField.leftView = leftView
            textField.leftViewMode = .always
            
            let leftImg = UIImageView(image: UIImage(named: labelImg[i]))
            leftView.addSubview(leftImg)
            let line = UIView()
            line.backgroundColor = UIColor.colorWithCustom(r: 161, g: 161, b: 161)
            leftView.addSubview(line)
            
            leftImg.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()
                _ = make?.bottom.equalTo()
                _ = make?.left.equalTo()(adapt_W(width: isPhone ? 5 : 3))
                _ = make?.right.equalTo()(line.mas_right)
            })
            //leftImg.center.y = textField.center.y
            
            line.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()
                _ = make?.bottom.equalTo()(adapt_H(height: isPhone ? -3 : -2))
                _ = make?.width.equalTo()(adapt_W(width: 0.5))
                _ = make?.right.equalTo()(adapt_W(width: isPhone ? -14 : -10))
            })
        }
        
        //login button
        let loginFrame = CGRect(x: (width - adapt_W(width: isPhone ? 275 : 200)) / 2, y: adapt_H(height: isPhone ? 350 : 250), width: adapt_W(width: isPhone ? 275 : 200), height: adapt_H(height: isPhone ? 45 : 28))
        let loginBtn = baseVC.buttonCreat(frame: loginFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"login_button_back1.png"), hightImage: UIImage(named:"login_button_back2.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.addSubview(loginBtn)
        loginBtn.tag = LoginTag.loginBtnTag.rawValue
        let loginLabelFrame = CGRect(x: 0, y: 0, width: loginFrame.width, height: loginFrame.height)
        let loginLabel = baseVC.labelCreat(frame: loginLabelFrame, text:  "登  录", aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 12))
        loginBtn.addSubview(loginLabel)
        
        
        //back to home button
        let homeFrame = CGRect(x: (width - adapt_W(width: isPhone ? 275 : 200)) / 2, y: adapt_H(height: isPhone ? 400 : 280), width: adapt_W(width: isPhone ? 275 : 200), height: adapt_H(height: isPhone ? 45 : 28))
        let homeBtn = baseVC.buttonCreat(frame: homeFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"login_homeBtn.png"), hightImage: UIImage(named:"login_homeBtn.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.addSubview(homeBtn)
        homeBtn.tag = LoginTag.HomeBtnTag.rawValue
        let homeLabelFrame = CGRect(x: 0, y: 0, width: loginFrame.width, height: loginFrame.height)
        let homeLabel = baseVC.labelCreat(frame: homeLabelFrame, text:  "富宝首页", aligment: .center, textColor: .colorWithCustom(r: 26, g: 123, b: 233), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 15 : 10))
        homeBtn.addSubview(homeLabel)
        
        
        //forget & register button
        for i in 0 ..< 2 {
            
            let btnFrame = CGRect(x: adapt_W(width: (isPhone ? 103 : 110) * (CGFloat(i) + 1)), y: adapt_H(height: isPhone ? 455 : 320), width: adapt_W(width: isPhone ? 65 : 45), height: adapt_H(height: isPhone ? 22 : 15))
            let button = baseVC.buttonCreat(frame: btnFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:labelImg[i + 2]), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
            self.addSubview(button)
            button.tag = LoginTag.forgetBtnTag.rawValue + i
        }
    }
    
    
    func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag:\(sender.tag)")
        delegate.btnAct(btnTag: sender.tag)
    }

}
