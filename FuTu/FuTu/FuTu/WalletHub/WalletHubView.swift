//
//  WalletHubView.swift
//  FuTu
//
//  Created by Administrator1 on 27/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class WalletHubView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var scroll: UIScrollView!
    var titleLabel,amountLabel: UILabel!
    var tradeSearchBtn: UIButton!
    var titleView,logoImg: UIImageView!
    var delegate:BtnActDelegate!
    
    var scrollDelegate: UIScrollViewDelegate!
    var width,height: CGFloat!
    let model = WalletHubModel()
    
    var refreshIndicator:RefreshIndicator!
    
    let baseVC = BaseViewController()
    
    
    init(frame:CGRect, param:AnyObject,rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        delegate = rootVC as! BtnActDelegate
        self.scrollDelegate = rootVC as! UIScrollViewDelegate
        
        initScrollView()
        initBackBtn()
    }
    
    func initScrollView() -> Void {
        
        scroll = baseVC.scrollViewCreat(frame: self.frame, delegate: scrollDelegate, contentSize: CGSize(width:width,height:height+1), showsIndicatorV: false, showsIndecatorH: false, backColor: .colorWithCustom(r: 244, g: 244, b: 244))
        self.insertSubview(scroll, at: 0)
        scroll.delegate = scrollDelegate
        
        //titleView
        let titleFrame = CGRect(x: 0, y: 0, width: width, height: adapt_H(height: model.titleHeight))
        titleView = baseVC.imageViewCreat(frame: titleFrame, image: UIImage(named:"wallet_title_bg.png")!, highlightedImage: UIImage(named:"wallet_title_bg.png")!)
        scroll.addSubview(titleView)
        
        //title label
        let titleLabelFrame = CGRect(x: 0, y: 20 + adapt_H(height: 16), width: width, height: 20)
        titleLabel = baseVC.labelCreat(frame: titleLabelFrame, text: "中心钱包", aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 12))
        scroll.addSubview(titleLabel)
        
        //search button
        let searchFrame = CGRect(x: width - adapt_W(width: isPhone ? 80 : 50), y: 20 + adapt_H(height: 10), width: adapt_W(width: isPhone ? 80 : 50), height: adapt_H(height: isPhone ? 40 : 25))
        tradeSearchBtn = baseVC.buttonCreat(frame: searchFrame, title: "交易查询", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 13 : 9), events: .touchUpInside)
        scroll.addSubview(tradeSearchBtn)
        tradeSearchBtn.tag = walletHubTag.TradeSearchBtnTag.rawValue
        
        //logo
        let logoFrame = CGRect(x: (width - adapt_W(width: model.logoWidth)) / 2, y: adapt_H(height: isPhone ? 85 : 55), width: adapt_W(width: model.logoWidth), height: adapt_W(width: model.logoWidth))
        logoImg = UIImageView(frame: logoFrame)
        logoImg.image = UIImage(named: "wallet_center_Logo.png")
        scroll.addSubview(logoImg)
        
        //amount label
        var amountText = "¥0.00"
        if let amount = userDefaults.value(forKey: userDefaultsKeys.userInfoBalance.rawValue) {
            amountText = "¥\(amount)"
        }
        let amountFrame = CGRect(x: 0, y: adapt_H(height: isPhone ? 200 : 140), width: width, height: adapt_H(height: isPhone ? 55 : 35))
        amountLabel = baseVC.labelCreat(frame: amountFrame, text: amountText, aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 32 : 20))
        scroll.addSubview(amountLabel)
        
        //Bailouts button
        //
        let bailoutsView = UIView(frame: CGRect(x: 0, y: self.titleView.frame.height - adapt_H(height: isPhone ? 70 : 40), width: width, height: adapt_H(height: isPhone ? 70 : 40)))
        scroll.addSubview(bailoutsView)
        bailoutsView.backgroundColor = UIColor.black
        bailoutsView.layer.opacity = 0.1

        let bailoutsButtonWidth:CGFloat = isPhone ? 115 : 90
        let bailoutsButtonHeight:CGFloat = isPhone ? 35 : 25
        let bailoutsButtonXArray = [width / 2 - adapt_W(width: (isPhone ? 12 : 18) + bailoutsButtonWidth), width / 2 + adapt_W(width: isPhone ? 12 : 18)]
        let bailoutsBtnName = ["昨日救援","今日救援"]
        for i in 0 ..< 2 {
            let btnFrame = CGRect(x: bailoutsButtonXArray[i], y:titleFrame.height - (bailoutsView.frame.height + bailoutsButtonHeight) / 2, width:adapt_W(width: bailoutsButtonWidth), height:adapt_H(height:  bailoutsButtonHeight))
            let button = baseVC.buttonCreat(frame: btnFrame, title: bailoutsBtnName[i], alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: isPhone ? 15 : 10), events: .touchUpInside)
            scroll.insertSubview(button, aboveSubview: bailoutsView)
            button.tag = walletHubTag.BailoutsBtnTag.rawValue + i
            button.layer.cornerRadius = btnFrame.height / 2
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = adapt_H(height: 1)
            button.layer.cornerRadius = adapt_H(height: (isPhone ? 35 : 25) / 2)
            button.center.y = bailoutsView.center.y
            //当前隐藏救援金功能
            button.isHidden = true
            
        }
        //3 buttons
        let buttonWidth = adapt_W(width: isPhone ? 270 : 220)
        let buttonHeight = adapt_H(height: isPhone ? 45 : 30)
        let buttonDist = adapt_H(height: isPhone ? 60 : 45)
        let buttonY = adapt_H(height: isPhone ? 380 : 250)
        for i in 0 ..< 3 {
            let btnFrame = CGRect(x: (width - buttonWidth) / 2, y:buttonY + CGFloat(i) * buttonDist, width: buttonWidth, height: buttonHeight)
            let button = baseVC.buttonCreat(frame: btnFrame, title: model.buttonInfo[i][0] as! String, alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: model.buttonInfo[i][1] as! UIColor, fonsize: fontAdapt(font: isPhone ? 17 : 12), events: .touchUpInside)
            scroll.addSubview(button)
            button.tag = walletHubTag.RechargeBtnTag.rawValue + i
            button.layer.cornerRadius = btnFrame.height / 2
        }
    }
    
    func initBackBtn() {
        //back button
        let backFrame = CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight)
        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.insertSubview(backBtn, at: 1)
        backBtn.tag = walletHubTag.HubBackBtnTag.rawValue
        //back button image
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
    }
    
    
    func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag: \(sender.tag)")
        delegate.btnAct(btnTag: sender.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
