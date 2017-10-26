//
//  ForgetView.swift
//  FuTu
//
//  Created by Administrator1 on 2/1/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit

class ForgetView: UIView {
    var width,height: CGFloat!
    var textFieldDelegate:UITextFieldDelegate!
    var delegate: BtnActDelegate!
    //基础空间
    let baseVC = BaseViewController()
    let model = ForgetModel()
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
        initNavigationBar()
        initStepLabel()
        initInputTextField()
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
    
    func initStepLabel() -> Void {
        let stepLabel = UILabel(frame: CGRect(x: 0, y: adapt_H(height: isPhone ? 70 : 50), width: width, height: adapt_H(height: isPhone ? 20 : 15)))
        setLabelProperty(label: stepLabel, text: "第一步填写账户信息", aligenment: .center, textColor: .colorWithCustom(r: 169, g: 169, b: 169), backColor: .clear, font: fontAdapt(font: isPhone ? 14 : 9))
        self.addSubview(stepLabel)
    }
    
    //================================
    //Mark:- 用户名输入框
    //================================
    private func initInputTextField() -> Void {
        let labelImg = ["forget_text_userName.png","find_text_realName.png"]
        let placeholderText = ["您的用户名","您的真实姓名"]
        let textHeight = adapt_H(height: isPhone ? 25 : 15)
        let textWidth = width - adapt_W(width: isPhone ? 60 : 200)
        for i in 0 ..< 2 {
            
            let textImg = UIImageView()
            self.addSubview(textImg)
            
            
            textImg.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(adapt_H(height: (isPhone ? 150 : 120) + adapt_H(height: (isPhone ? 65 : 35) * CGFloat(i))))
                _ = make?.left.equalTo()(self.mas_left)?.setOffset((self.width - textWidth) / 2)
                _ = make?.width.equalTo()(textWidth)
                //_ = make?.right.equalTo()(self.scroll.mas_right)?.setOffset(adapt_W(width: -50))
                _ = make?.height.equalTo()(textHeight)
            }
            textImg.image = UIImage(named: "login_text_line.png")
            
            let textField = baseVC.textFieldCreat(frame: initFrame, placeholderText: placeholderText[i], aligment: .left, fonsize: fontAdapt(font: isPhone ? 17 : 11), borderWidth: 0, borderColor: .clear, tag: 10)
            textField.textColor = UIColor.colorWithCustom(r: 37, g: 37, b: 37)
            self.addSubview(textField)
            textField.keyboardType = .default
            textField.delegate = self.textFieldDelegate
            textField.tag = ForgetTag.usernameText.rawValue + i
            textField.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(textImg.mas_top)?.setOffset(adapt_H(height: -5))
                _ = make?.left.equalTo()(textImg.mas_left)
                _ = make?.right.equalTo()(textImg.mas_right)
                _ = make?.height.equalTo()(textImg.mas_height)
            }
            //添加左侧视图
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: adapt_W(width: isPhone ? 100 : 60), height: adapt_H(height: isPhone ? 20 : 15)))
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
                _ = make?.left.equalTo()(adapt_W(width: isPhone ? 10 : 6))
                _ = make?.right.equalTo()(line.mas_right)?.setOffset(adapt_W(width: isPhone ? -10 : -6))
            })
            //leftImg.center.y = textField.center.y
            
            line.mas_makeConstraints({ (make) in
                _ = make?.top.equalTo()
                _ = make?.bottom.equalTo()(adapt_H(height: isPhone ? -3 : -2))
                _ = make?.width.equalTo()(adapt_W(width: 0.5))
                _ = make?.right.equalTo()(adapt_W(width: isPhone ? -14 : -8))
            })
            
            //添加右侧视图:红色错误提示文字
            let alertLabel = UILabel()
            alertLabel.frame = CGRect(x: textField.frame.width - adapt_W(width: isPhone ? 80 : 60), y: 0, width: adapt_W(width: isPhone ? 90 : 65), height: adapt_H(height: isPhone ? 20 : 15))
            setLabelProperty(label: alertLabel, text: self.model.alertLabelText[i], aligenment: .right, textColor: .red, backColor: .clear, font: fontAdapt(font: isPhone ? 12 : 8))
            alertLabel.tag = ForgetTag.forgetAlergLabel.rawValue + i
            textField.rightView = alertLabel
            textField.rightViewMode = .always
            alertLabel.isHidden = true
        }
        
        //next button
        let nextFrame = CGRect(x: (width - adapt_W(width: isPhone ? 275 : 180)) / 2, y: adapt_H(height: isPhone ? 300 : 250), width: adapt_W(width: isPhone ? 275 : 180), height: adapt_H(height: isPhone ? 45 : 25))
        let nextBtn = baseVC.buttonCreat(frame: nextFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"login_button_back1.png"), hightImage: UIImage(named:"login_button_back2.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.addSubview(nextBtn)
        nextBtn.tag = ForgetTag.nextBtnTag.rawValue
        let loginLabelFrame = CGRect(x: 0, y: 0, width: nextFrame.width, height: nextFrame.height)
        let loginLabel = baseVC.labelCreat(frame: loginLabelFrame, text:  "下一步", aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 11))
        nextBtn.addSubview(loginLabel)

        
        
    }
    
    func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag:\(sender.tag)")
        delegate.btnAct(btnTag: sender.tag)
    }

}
